//
//  ReceiptPrintFormatViewController + extension + setup.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 26/12/2023.
//

import UIKit


extension ReceiptPrintFormatViewController {

    
    func firstSetup(){
        scrollView.isHidden = true
        
        let blurEffectView: UIVisualEffectView = {
            let blurEffect = UIBlurEffect(style: .systemThickMaterialDark)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            
            blurEffectView.alpha = 0.8
            
            // Setting the autoresizing mask to flexible for
            // width and height will ensure the blurEffectView
            // is the same size as its parent view.
            blurEffectView.autoresizingMask = [
                .flexibleWidth, .flexibleHeight
            ]
            return blurEffectView
        }()
//
//
//        progressView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        // Add the blurEffectView with the same
        // size as view
        blurEffectView.frame = self.progressView.bounds
        progressView.insertSubview(blurEffectView, at: 0)
        progressView.backgroundColor = UIColor.systemGray4

        progressBar.progress = 0.0
        progressBar.layer.cornerRadius = 1.5
        progressBar.clipsToBounds = true
        progressBar.layer.sublayers![1].cornerRadius = 1.5
        progressBar.subviews[1].clipsToBounds = true
        
        progressBarTimer = Timer.scheduledTimer(timeInterval: 0.001, target: self, selector: #selector(updateProgressView), userInfo: nil, repeats: true)
        NotificationCenter.default.addObserver(self,selector:#selector(connectPrinterSuccessfully(_:)),name: NSNotification.Name(PRINTER_NOTIFI.CONNECT_SUCCESS),object: nil)
        NotificationCenter.default.addObserver(self,selector:#selector(connectPrinterFail(_:)),name: NSNotification.Name(PRINTER_NOTIFI.CONNECT_FAIL),object: nil)
        NotificationCenter.default.addObserver(self,selector:#selector(printReceiptSuccessFully(_:)),name: NSNotification.Name(PRINTER_NOTIFI.PRINT_SUCCESS),object: nil)
        NotificationCenter.default.addObserver(self,selector:#selector(printFail(_:)),name: NSNotification.Name(PRINTER_NOTIFI.PRINT_FAIL),object: nil)
        
        
        
        if printer.connection_type == .wifi{
            timerOFCheckingPrinterStatus?.invalidate()
            timerOFCheckingPrinterStatus = nil
            
            timerOFCheckingPrinterStatus = Timer.scheduledTimer(withTimeInterval:1, repeats: true) { [weak self] _ in
                print("start swiping")
    //            self?.POSPrinterUtility?.checkStatus()
            }
        }
        
      
        
    }
    
    
    @objc func updateProgressView(){
        progressBar.setProgress(progressPercent, animated: true)
      
        if progressBar.progress == 1.0{
            progressBarTimer.invalidate()
        }
    }
    
    
    @objc func printReceiptSuccessFully(_ notification: Notification){

        let object = notification.object as! [String:Any]
        
        if !object.isEmpty,
            let printMethod = PRINTER_METHOD.init(rawValue: object[PRINTER_NOTIFI.PRINTER_METHOD_KEY] as? Int ?? 0),
            let isLastItem = object["isLastItem"]as? Bool
        {
            progressPercent = 1.0
            lbl_already_printed_number.text = "1/1"
                        
            
            switch printMethod {
                
                case .POSPrinter:
                    POSPrinterUtility?.wifiDisconnect()
                    
                case .BLEPrinter:
                    BLEPrinterUtility?.bleManager.disconnectRootPeripheral()
                
                default:
                    break
                    
            }
            
            if isLastItem{
          
                DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                    self.dismiss(animated: true)
                })

            }
           
          
        }else{
            progressPercent += 0.5
        }
        
        
    }
    
    @objc func printFail(_ notification: Notification){
        let object = notification.object as! [String:Any]
        if let error = object["error"] as? NSError{
            messageBox(error.localizedDescription, withTitle: "Cảnh báo", withAutoDismiss: true)
        }else{
            messageBox("Lỗi In", withTitle: "Cảnh báo", withAutoDismiss: true)
        }
        
        
    }
    
    
    @objc func connectPrinterSuccessfully(_ notification: Notification){
        let object = notification.object as! [String:Any]
        
        
        let printMethod = PRINTER_METHOD.init(rawValue: object[PRINTER_NOTIFI.PRINTER_METHOD_KEY] as? Int ?? 0)
        
        backGroundQueue.async(group: dispatchGroup,execute: {[self] in
        

            switch printMethod {
                
                case .POSPrinter:
                    viewModel.WifiWorkItem.value?.printWork.perform()
                    
                case .BLEPrinter:
                    viewModel.BLEWorkItem.value?.printWork.perform()
                
                 
                default:
                    break
                    
            }
            
       })
               
        
    }
    
    @objc func connectPrinterFail(_ notification: Notification){

        let object = notification.object as! [String:Any]
        
      
        if let error = object["error"] as? NSError,
           let printMethod = PRINTER_METHOD.init(rawValue: object[PRINTER_NOTIFI.PRINTER_METHOD_KEY] as? Int ?? 0){
            
            
            if printMethod == .POSPrinter, let image = viewModel.WifiWorkItem.value?.image{
                _ = LocalDataBaseUtils.saveToLocalDataBase(order:self.order! ,printer: printer, img: image, printItems: [], isLastItem: true)
            }
        
            messageBox(error.localizedDescription, withTitle: "Cảnh báo", withAutoDismiss: true)
        }
        
    }
    
    private func address<T: AnyObject>(of object: T) -> Int {
        return unsafeBitCast(object, to: Int.self)
    }

    func messageBox(_ message: String, withTitle title: String, withAutoDismiss dismiss: Bool){
        let alert: UIAlertController = UIAlertController(title:title, message: message, preferredStyle:  UIAlertController.Style.alert)
        progressView.isHidden = true
        if dismiss == true {
            present(alert, animated: true, completion: {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                    alert.dismiss(animated: false, completion: {
                        self.dismiss(animated: true)
                    })
                })
            })
         }else {

        let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:{
            (action: UIAlertAction!) -> Void in
        })

        alert.addAction(defaultAction)
        present(alert, animated: true, completion: nil)
        }
    }
}





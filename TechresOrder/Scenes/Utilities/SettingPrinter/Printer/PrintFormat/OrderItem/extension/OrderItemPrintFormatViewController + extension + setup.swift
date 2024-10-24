//
//  OrderItemPrintFormatViewController + extension.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 22/12/2023.
//

import UIKit

extension OrderItemPrintFormatViewController {

    
    func firstSetup(){
        scrollview.isHidden = true
        generalView.backgroundColor = .white
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
        NotificationCenter.default.addObserver(self,selector:#selector(printSuccessFully(_:)),name: NSNotification.Name(PRINTER_NOTIFI.PRINT_SUCCESS),object: nil)
        NotificationCenter.default.addObserver(self,selector:#selector(printFail(_:)),name: NSNotification.Name(PRINTER_NOTIFI.PRINT_FAIL),object: nil)

    }
    
    
    @objc func updateProgressView(){
        progressBar.setProgress(progressPercent, animated: true)
        
        switch viewModel.printType.value{
           case .print_test:
                if progressBar.progress == 1.0{
                    progressBarTimer.invalidate()
                    Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { timer in
                        self.actionBack("")
                    }
                }
               break
           default:

               break
       }
    }
    
    
    @objc func printSuccessFully(_ notification: Notification){
        
        let object = notification.object as! [String:Any]
        if !object.isEmpty,
           let id = UUID(uuidString: object["id"] as? String ?? ""),
           let isLastItem = object["isLastItem"]as? Bool,
           let printMethod = PRINTER_METHOD.init(rawValue: object[PRINTER_NOTIFI.PRINTER_METHOD_KEY] as? Int ?? 0)
        {
            

            progressPercent +=  1.0/Float(viewModel.printNumber.value)
            //===================================================================================
            viewModel.alreadyPrintedNumber.accept(viewModel.alreadyPrintedNumber.value + 1)//||
            //===================================================================================
            lbl_already_printed_number.text = String(format: "%d/%d",viewModel.alreadyPrintedNumber.value,viewModel.printNumber.value)

    
            switch printMethod {
                case .POSPrinter:
                    let wifiWorkItems = viewModel.WIFIWorkItem.value
                    if let p = wifiWorkItems.firstIndex(where: {$0.id == id}){
                       wifiWorkItems[p].printWork.notify(queue: backGroundQueue) {
                           self.POSPrinterUtility?.wifiDisconnect()
                           self.viewModel.startTheNextWorkItem()
                       }
                    }
                    break
                
                
            case .TSCPrinter:
                    isLastItem ? TSCPrinterUtility?.wifiDisconnect() : {}()
                    break
                
                case .BLEPrinter:
                    isLastItem ? BLEPrinterUtility?.bleManager.disconnectRootPeripheral() : {}()
                    break
                
            }
            
            
            if isLastItem{
                switch viewModel.printType.value{
                    case .new_item,.cancel_item,.return_item:
                        updateAlReadyPrinted(order:order,alreadyPrintedItems:[])
                        break

                    default:
                        break
                }
            }
            
        }

    }
    
    @objc func printFail(_ notification: Notification){
        messageBox("Lỗi In", withTitle: "Cảnh báo", withAutoDismiss: true)
    }
                                        
    
    @objc func connectPrinterFail(_ notification: Notification){
        let object = notification.object as! [String:Any]
      
        guard 
            let error = object["error"] as? NSError,
            let printMethod = PRINTER_METHOD.init(rawValue: object[PRINTER_NOTIFI.PRINTER_METHOD_KEY] as? Int ?? 0)
        else{
            actionBack("")
            return
        }
                
        switch printMethod {
            case .POSPrinter:
                for workItem in viewModel.WIFIWorkItem.value{
                    
                    LocalDataBaseUtils.saveToLocalDataBase(
                        order: viewModel.order.value,
                        printer: workItem.printer ?? Printer(),
                        img: workItem.image ?? UIImage(),
                        printItems: workItem.printItems ?? [],
                        isLastItem: workItem.islastItem ?? true
                    )
                }
            
            case .TSCPrinter:
                if let workItem = viewModel.TSCWorkItem.value{
                    
                    LocalDataBaseUtils.saveTSCDataToDB(
                        orderId: workItem.orderId,
                        printer: workItem.printer ?? Printer(),
                        imgs: workItem.image,
                        isLastItem: workItem.islastItem
                    )
                }
            
            
                break
            
            case .BLEPrinter:
                break
        }
                
        messageBox(error.localizedDescription, withTitle: "Cảnh báo", withAutoDismiss: true)
        
    }
    
    
    @objc func connectPrinterSuccessfully(_ notification: Notification){
        let object = notification.object as! [String:Any]
        
        let printMethod = PRINTER_METHOD.init(rawValue: object[PRINTER_NOTIFI.PRINTER_METHOD_KEY] as? Int ?? 0)
        
        
        switch printMethod {
            
            case .POSPrinter:
                if let id = UUID(uuidString: object["id"] as? String ?? ""){
           
                   let workItems = viewModel.WIFIWorkItem.value
                   if let p = workItems.firstIndex(where: {$0.id == id}){
                       workItems[p].printWork.perform()
                   }
                }
            
            case .TSCPrinter:
            
                if let workItem = self.viewModel.TSCWorkItem.value{
                    workItem.printWork.perform()
                }
            
             
            case .BLEPrinter:
                
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1){
                    let workItem = self.viewModel.BLEWorkItem.value
                    workItem?.printWork.perform()
                }
            
            default:
                actionBack("")
                break
                
        }

    }
    
    
    func messageBox(_ message: String, withTitle title: String, withAutoDismiss dismiss: Bool){
        let alert: UIAlertController = UIAlertController(title:title, message: message, preferredStyle:  UIAlertController.Style.alert)

        if dismiss == true {
            mainQueue.async {
                self.progressView.isHidden = true
                self.present(alert, animated: true, completion: {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                        alert.dismiss(animated: false, completion: {
                            self.viewModel.cancelAllWorkItems()

                        })
                    })
                })
            }
            
        
         }else {
             let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:{
                (action: UIAlertAction!) -> Void in
                
            })
            alert.addAction(defaultAction)
            present(alert, animated: true, completion: nil)
        }
    }
    
}

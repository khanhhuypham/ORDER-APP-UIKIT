//
//  FoodAppPrintFormatViewController + extension + setup.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 21/08/2024.
//

import UIKit



extension FoodAppPrintFormatViewController {

    
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
           let id =  UUID(uuidString: object["id"] as? String ?? ""),
           let isLastItem = object["isLastItem"]as? Bool,
           let printMethod = PRINTER_METHOD.init(rawValue: object[PRINTER_NOTIFI.PRINTER_METHOD_KEY] as? Int ?? 0)
        {
            
            progressPercent += 1.0/Float(viewModel.printNumber.value)
            //===================================================================================
            viewModel.alreadyPrintedNumber.accept(viewModel.alreadyPrintedNumber.value + 1)//||
            //===================================================================================
            lbl_already_printed_number.text = String(format: "%d/%d",viewModel.alreadyPrintedNumber.value,viewModel.printNumber.value)


            switch printMethod {
                case .POSPrinter:
                    let wifiWorkItems = viewModel.WIFIWorkItems.value
                    if let p = wifiWorkItems.firstIndex(where: {$0.id == id}){
//                        wifiWorkItems[p].printWork.notify(queue: <#T##DispatchQueue#>, execute: <#T##() -> Void#>)
                        
                        wifiWorkItems[p].printWork.notify(queue: DispatchQueue.main) {
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
                        updateAlreadyPrintedItem()
                        break

                    default:
                        break
                }
            }
        }
    }
    
    @objc func printFail(_ notification: Notification){
        
//        mainQueue.async {
//            Toast.show(message:"Lỗi In", controller: self)
//        }
        Toast.show(message:"Lỗi In", controller: self)
     
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
            

        
                for workItem in viewModel.WIFIWorkItems.value{
                    
                    if let printer = workItem.printer, let image = workItem.image{
                        
                        var order = OrderDetail()
                        order.id = viewModel.order.value.id
                        LocalDataBaseUtils.saveToLocalDataBase(order: order,printer: printer,img:image,printItems: [],isLastItem: true)
                    }
                }
                updateAlreadyPrintedItem(WithError: true,type: .wifi)
            
                break
            
            case .TSCPrinter:
            
                if let workItem = viewModel.TSCWorkItem.value,let printer = workItem.printer{
                    
                    workItem.connectionWork.cancel()
                    
                    workItem.printWork.cancel()
                    
                    
                    if workItem.connectionWork.isCancelled{
                        TSCPrinterUtility?.wifiDisconnect()
                    }
                    
                    LocalDataBaseUtils.saveTSCDataToDB(orderId:workItem.orderId,printer: printer,imgs: workItem.image,isLastItem: workItem.islastItem)
                    updateAlreadyPrintedItem(WithError: true,type: .tsc)
                }
                break
            
            case .BLEPrinter:
                break
        }
        Toast.show(message: error.localizedDescription, controller: self)
//        mainQueue.async {
//            Toast.show(message: error.localizedDescription, controller: self)
//        }
        
    }
    
    
    @objc func connectPrinterSuccessfully(_ notification: Notification){
        let object = notification.object as! [String:Any]
                
        let printMethod = PRINTER_METHOD.init(rawValue: object[PRINTER_NOTIFI.PRINTER_METHOD_KEY] as? Int ?? 0)
        _ =  UUID(uuidString: object["id"] as? String ?? "")
        switch printMethod {
            
            case .POSPrinter:
                if let workItem = viewModel.WIFIWorkItems.value.first{
                    workItem.printWork.perform()
                }
            
            case .TSCPrinter:
            
                if let workItem = viewModel.TSCWorkItem.value{
                    workItem.printWork.perform()
                }
            
        
            
            default:
                actionBack("")
                break
                
        }

    }
    
     
    
    func updateAlreadyPrintedItem(WithError:Bool = false, type:itemType? = nil){
        
        if WithError, let typeItem = type{
            var printNumber = viewModel.printNumber.value
            switch typeItem{
                case .wifi:
                    for workItem in viewModel.WIFIWorkItems.value{
                        workItem.connectionWork.cancel()
                        workItem.printWork.cancel()
                    }
                    printNumber -= viewModel.WIFIWorkItems.value.count
                
                case .tsc:
                    printNumber -= viewModel.TSCWorkItem.value?.image.count ?? 0
                    viewModel.TSCWorkItem.accept(nil)
            }
            viewModel.printNumber.accept(printNumber)
            
            lbl_already_printed_number.text = String(format: "%d/%d",viewModel.alreadyPrintedNumber.value,printNumber)
            
            if viewModel.alreadyPrintedNumber.value == 0 && printNumber == 0{
               lbl_already_printed_number.text = "--/--"
            }

        }
        
        
        if viewModel.alreadyPrintedNumber.value == viewModel.printNumber.value{
            progressBar.setProgress(1, animated: true)
            progressBarTimer.invalidate()
            Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { timer in
                self.actionBack("")
                NotificationCenter.default.post(name:NSNotification.Name(rawValue: PRINTER_NOTIFI.ERROR_FROM_PRINT_FUNCTION_OF_FOOD_APP), object: nil)
                
            }
        }
    }
    
}

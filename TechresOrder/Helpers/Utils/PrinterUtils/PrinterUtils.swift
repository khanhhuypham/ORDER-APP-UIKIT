//
//  PrinterUtils.swift
//  Techres - Order
//
//  Created by pham khanh huy on 31/03/2022.
//  Copyright © 2022 vn.techres.sale. All rights reserved.
//

import UIKit
import JonAlert
import RealmSwift
import RxSwift
class PrinterUtils:NSObject {

    let rxbag = DisposeBag()
    var POSPrinterUtility = CustomPOSPrinter.shared()
    let TSCPrinterUtility = TSCPrinter.shared()
    var BLEPrinterUtility = BLEPrinter.shared()
    
    
    
    let backGroundQueue = DispatchQueue.global(qos: .userInteractive)
    
    var workItems:[WIFIWorkItem] = []
    var tscWorkItem:TSCWorkItem? = nil
    
    
    var printTimer: Timer?
    var deleteTimer: Timer?
    
    
    static let shared: PrinterUtils = {
        let printerUtils = PrinterUtils()
        return printerUtils
    }()

    
    override init() {
        super.init()
        NotificationCenter.default.addObserver(self,selector:#selector(connectPrinterSuccessfully(_:)),name: NSNotification.Name(PRINTER_NOTIFI.BACKGROUND_CONNECT_SUCCESS),object: nil)
        NotificationCenter.default.addObserver(self,selector:#selector(connectPrinterFail(_:)),name: NSNotification.Name(PRINTER_NOTIFI.BACKGROUND_CONNECT_FAIL),object: nil)
        NotificationCenter.default.addObserver(self,selector:#selector(printSuccessFully(_:)),name: NSNotification.Name(PRINTER_NOTIFI.BACKGROUND_PRINT_SUCCESS),object: nil)
        NotificationCenter.default.addObserver(self,selector:#selector(printFail(_:)),name: NSNotification.Name(PRINTER_NOTIFI.BACKGROUND_PRINT_FAIL),object: nil)
        
        BLEPrinterUtility?.bleManager.delegate = self
    }
    
    deinit{
        printTimer?.invalidate()
        printTimer = nil
        
        deleteTimer?.invalidate()
        deleteTimer = nil
    }
    
  
    @objc func printSuccessFully(_ notification: Notification){
  
        let object = notification.object as! [String:Any]
        
        if !object.isEmpty{

            guard
                let printMethod = PRINTER_METHOD.init(rawValue: object[PRINTER_NOTIFI.PRINTER_METHOD_KEY] as? Int ?? 0),
                let _ = object["isLastItem"]as? Bool
            else{
                dLog("phạm khánh huy")
                return
            }
    
            
            do {
                
                let id = try ObjectId.init(string: object["id"] as? String ?? "")
                
                switch printMethod {
                    case .POSPrinter:
                        canncelWorkItem(id: id, isErrorOccur: false)
                    case .TSCPrinter:
                        canncelTSCWorkItem(id: id, isErrorOccur: false)
                    case .BLEPrinter:
                        break
                }
                
            }catch{}
            
        }
  
    }
    
    
    @objc func printFail(_ notification: Notification){
        canncelAllWorkItem()
    }
    
    
    @objc func connectPrinterFail(_ notification: Notification){
        
        let object = notification.object as! [String:Any]
       

        if let error = object["error"] as? NSError,let printMethod = PRINTER_METHOD.init(rawValue: object[PRINTER_NOTIFI.PRINTER_METHOD_KEY] as? Int ?? 0){
            
            do {
                
                let id = try ObjectId.init(string: object["id"] as? String ?? "")
                
                switch printMethod {
                    case .POSPrinter:
                        canncelWorkItem(id: id, isErrorOccur: true)
                    case .TSCPrinter:
                        canncelTSCWorkItem(id: id, isErrorOccur: true)
                    case .BLEPrinter:
                        break
                }
                
            }catch{}
            
        }
        
    }
     
    
    @objc func connectPrinterSuccessfully(_ notification: Notification){
        
        backGroundQueue.async(execute: {
            
            let object = notification.object as! [String:Any]
            
            if let printMethod = PRINTER_METHOD.init(rawValue: object[PRINTER_NOTIFI.PRINTER_METHOD_KEY] as? Int ?? 0){

                switch printMethod {

                    case .POSPrinter:
                    
                         do{
                             let queueId = try ObjectId.init(string: object["id"] as? String ?? "")
                             if let position = self.workItems.firstIndex(where: {$0.objectId == queueId}){
                                 self.workItems[position].printWork.perform()
                             }
                         }catch{
                             
                         }


                    case .TSCPrinter:
                        if let tscWorkItem = self.tscWorkItem{
                            tscWorkItem.printWork.perform()
                        }


                    case .BLEPrinter:
                        break
                }

            }
           
        })
    }
        
    
}


extension PrinterUtils{


    func PrintReceipt(presenter:UIViewController,order:OrderDetail,bankAccount:BankAccount,printer:Printer,completetHandler:(()->Void)? = nil){
        let vc = ReceiptPrintFormatViewController()
        vc.printer = printer
        vc.order = order
        vc.bankAccount = bankAccount
        vc.completeHandler = completetHandler
        vc.view.backgroundColor = .clear
        vc.modalPresentationStyle = .overCurrentContext
        presenter.present(vc, animated: false, completion: nil)
    }
    

    func PrintItems(presenter:UIViewController,order:OrderDetail,printItem:[Food], printers:[Printer],printType:Constants.printType,completetHandler:(()->Void)? = nil){
        
        if LocalDataBaseUtils.isOrderPerformingPrintProcess(orderId: order.id){
            presenter.showAlertWithMessage("Hệ thống đang xử lý quy trình in của đơn hàng này, vui lòng chờ trong giây lát", with: nil)
        }else{
            let vc = OrderItemPrintFormatViewController()
            vc.printers = printers
            vc.order = order
            vc.printItem = printItem
            vc.printType = printType
            vc.completeHandler = completetHandler
            vc.view.backgroundColor = .clear
            vc.modalPresentationStyle = .overCurrentContext
            presenter.present(vc, animated: false, completion: nil)
        }
    }
    
}


//MARK: print for food app
extension PrinterUtils{
    
    func PrintFoodAppItems(presenter:UIViewController,isCustomerOrder:Bool = false,printers:[Printer],orders:[FoodAppOrder],completetHandler:(()->Void)? = nil){
        
        if printers.filter{$0.is_have_printer == ACTIVE}.isEmpty{
            presenter.showAleartViewwithTitle("Cảnh báo", message:"Không tìm thấy máy in đang hoạt động cho chức năng in stamp của Food App",withAutoDismiss: true)
            (completetHandler ?? {})()
        }else if printers.isEmpty{
            presenter.showAleartViewwithTitle("Cảnh báo", message:"Vui lòng thiết lập máy in cho Food App",withAutoDismiss: true)
            (completetHandler ?? {})()
        }else{
            let vc = FoodAppPrintFormatViewController()
            vc.isCustomerOrder = isCustomerOrder
            vc.printers = printers
            vc.orders = orders
            vc.completeHandler = completetHandler
            vc.printType = .new_item
            vc.view.backgroundColor = .clear
            vc.modalPresentationStyle = .formSheet
            presenter.present(vc, animated: false, completion: nil)
        }
    
    }

}



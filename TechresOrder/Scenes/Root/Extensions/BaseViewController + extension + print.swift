//
//  BaseViewController + extension + print.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 25/01/2024.
//

import UIKit
import ObjectMapper
import BackgroundTasks
extension BaseViewController {
    
    
    @objc func sceneChange(_ notification: Notification){
        
        if permissionUtils.GPBH_2_o_1 && permissionUtils.Cashier{
            
            switch notification.object as! UIApplication.State {
                
                case .background:
                    if timerForPrinter != nil && backgroundTask == .invalid{
                        registerBackgroundTask()
                    }
                    break
                    
                case .active:
                    endBackgroundTaskIfActive()
                    break
                    
                default:
                    break
            }
        }
    }
    
    
    private func schedule(){
        //Manual Test: e -l objc -- (void)[[BGTaskScheduler sharedScheduler] _simulateLaunchForTaskWithIdentifier:@"BACKGROUNDTASK"]
        BGTaskScheduler.shared.cancel(taskRequestWithIdentifier: "BACKGROUNDTASK")
        BGTaskScheduler.shared.getPendingTaskRequests{request in
            print("\n\(request.count) BGTasks pending...")
            guard request.isEmpty else {return}
            do {
                let request = BGAppRefreshTaskRequest(identifier: "BACKGROUNDTASK")
                request.earliestBeginDate = Date(timeIntervalSinceNow: 10)
                try BGTaskScheduler.shared.submit(request)
                print("task scheduled")
            } catch {
                //ignore
                print("Couldn't schedule app refresh \(error.localizedDescription)")
            }
        }
    }
    
    
    
    func setUpPrinterTimer(){
        if permissionUtils.GPBH_2_o_1{
            dLog(UIApplication.backgroundFetchIntervalMinimum)
        
        
            DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
//                self.schedule()
            })
            
            UIApplication.shared.isIdleTimerDisabled = ManageCacheObject.getIdleTimerStatus()
   
            timerForPrinter?.invalidate()
            timerForPrinter = nil
            timerForPrinter = Timer.scheduledTimer(withTimeInterval:5, repeats: true) { [weak self] _ in
//                self?.getOrderNeedToPrint()
            }
        }
    }
    

    private func registerBackgroundTask() {
        backgroundTask = UIApplication.shared.beginBackgroundTask { [weak self] in
            self?.endBackgroundTaskIfActive()
            
        }
    }
    
    private func endBackgroundTaskIfActive() {
        if backgroundTask != .invalid {
            UIApplication.shared.endBackgroundTask(backgroundTask)
            backgroundTask = .invalid
        }
    }

    
//    private func getOrderDetail(orderId:Int){
//        viewModels.getOrderDetail(orderId: orderId).subscribe(onNext: { (response) in
//            if(response.code == RRHTTPStatusCode.ok.rawValue){
//        
//                if let order  = Mapper<OrderDetail>().map(JSONObject: response.data){
//                    self.getPrintItemFromOrder(order: order)
//                }
//                
//            }
//        }).disposed(by: rxbag)
//    }
    
    
//    private func getPrintItemFromOrder(order:OrderDetail){
//        viewModels.getPrintItemFromOrder(orderId:order.id).subscribe(onNext: { [self] (response) in
//            if(response.code == RRHTTPStatusCode.ok.rawValue){
//   
//                if let printItem = Mapper<Food>().mapArray(JSONObject: response.data){
//                 
//                    
//                    let pendingItem = printItem.filter{$0.status == PENDING}
//                    let cancelItem = printItem.filter{$0.status == CANCEL_FOOD}
//                    let returnedItem = printItem.filter{$0.category_type == .drink && $0.enable_return_beer == ACTIVE && $0.return_quantity_for_drink > 0}
//                    
//                    
//                    if pendingItem.count > 0 {
//                        printItems(order:order,items:pendingItem,printType: .new_item)
//                    }
//                    
//                    if cancelItem.count > 0{
//                        printItems(order:order,items: cancelItem,printType: .cancel_item)
//                    }
//                    
//                    
//                    if returnedItem.count > 0{
//                        printItems(order:order,items: returnedItem,printType: .return_item)
//                    }
//                    
//
//                }
//            }
//        }).disposed(by: rxbag)
//    }
    

    
    
//    //MARK: print_type = 0 => món mới; print_type = 1 => món cập nhật tăng giảm; print_type = 2 => món huỷ;
//    private func printItems(order:OrderDetail,items:[Food], printType:Constants.printType) {
//        let printers = ManageCacheObject.getChefBarConfigs(cache_key: KEY_CHEF_BARS)
//        
//        var itemSendToPrinter:[Food] = []
//      
//        for printer in printers{
//    
//            if printer.is_have_printer == ACTIVE{
//                itemSendToPrinter += items.filter{$0.restaurant_kitchen_place_id == printer.id}
//            }
//            
//        }
//        
//        if itemSendToPrinter.count > 0 && printers.filter{$0.is_have_printer == ACTIVE}.count > 0{
//            
//            PrinterUtils.shared.PrintItems(
//                presenter: self,
//                order:order,
//                printItem:itemSendToPrinter,
//                printers:printers.filter{$0.is_have_printer == ACTIVE},
//                printType:printType)
//        }
//   
//    }
    
    
    
}

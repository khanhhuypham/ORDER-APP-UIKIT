//
//  OrderItemPrintFormatViewModel.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 26/12/2023.
//

import UIKit
import RxRelay
import RxSwift
import RealmSwift
class OrderItemPrintFormatViewModel: BaseViewModel {
    
    private(set) weak var view: OrderItemPrintFormatViewController?

    var order = BehaviorRelay<OrderDetail>(value: OrderDetail.init())
    var printItems = BehaviorRelay<[Food]>(value: [])
//    var printers = BehaviorRelay<[Printer]>(value: [])
    var printNumber = BehaviorRelay<Int>(value: 1) // số tờ cần in ra trên mỗi item
    var alreadyPrintedNumber = BehaviorRelay<Int>(value: 0) // số tờ đã được in ra
    var printType = BehaviorRelay<Constants.printType>(value: .new_item)
    
    
    
    
    public var TSCWorkItem = BehaviorRelay<TSCWorkItem?>(value: nil)
    
    public var WIFIWorkItem = BehaviorRelay<[WIFIWorkItem]>(value: [])
    
    public var BLEWorkItem = BehaviorRelay<BLEWorkItem?>(value: nil)


    func bind(view: OrderItemPrintFormatViewController){
        self.view = view
    }
    
    func startTheNextWorkItem(){
        var wifiWorkItems = WIFIWorkItem.value
                
        if wifiWorkItems.count > 0, let currentWork = wifiWorkItems.first{
            
            currentWork.connectionWork.cancel()
            currentWork.printWork.cancel()
            
            wifiWorkItems.removeFirst()
            
            self.WIFIWorkItem.accept(wifiWorkItems)
            
            if WIFIWorkItem.value.count > 0, let nextWork = WIFIWorkItem.value.first{
                
                if currentWork.connectionWork.isCancelled{
                    let time: DispatchTime = .now() + .milliseconds(1000)
                    nextWork.connectionWork.wait(timeout:time)
                    nextWork.connectionWork.perform()
                }
            }
        }
    }
    
    
    func cancelAllWorkItems(){
        for workItem in WIFIWorkItem.value{
            workItem.connectionWork.cancel()
            workItem.printWork.cancel()
        }
        
        view?.dismiss(animated: true, completion: {
            self.view?.POSPrinterUtility?.wifiDisconnect()
        })
    }
    
    func calculatePrintNumber(){
        var printNumber = 0
      
        printNumber = WIFIWorkItem.value.count
        
        
        if let BLEWorkItem = BLEWorkItem.value{
            printNumber += BLEWorkItem.images
        }
        
        
        if let TSCWorkItem = TSCWorkItem.value{
            printNumber += TSCWorkItem.image.count
        }
        
        self.printNumber.accept(printNumber)
        
        self.view?.lbl_already_printed_number.text = String(format: "0/%d",printNumber)
    }
    
    func address<T: AnyObject>(of object: T) -> Int {
        return unsafeBitCast(object, to: Int.self)
    }

    func updateReadyPrinted(alreadyPrintedItems:[Int]) -> Observable<APIResponse> {
        return appServiceProvider.rx.request(.updateReadyPrinted(order_id: order.value.id, order_detail_ids: alreadyPrintedItems))
               .filterSuccessfulStatusCodes()
               .mapJSON().asObservable()
               .showAPIErrorToast()
               .mapObject(type: APIResponse.self)
    }
}

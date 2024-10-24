//
//  OrderDetailRebuildViewController + extension + print.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 03/09/2023.
//

import UIKit
import ObjectMapper
import RxSwift
import JonAlert
extension OrderDetailViewController {
    
    
    
    func getOrderNeedToPrintFor2o1(print:Bool = false){
        viewModel.requestPrintChefBar(printType:.new_item).subscribe(onNext: { (response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){
                self.a(print: print)
            }else{
                JonAlert.showError(message: response.message ?? "Có lỗi xảy ra trong quá trình kết nối tới máy chủ. Vui lòng thử lại.", duration: 3.0)
            }
        }).disposed(by: rxbag)
    }
    
    
    func a(print:Bool){
        viewModel.getOrderNeedToPrintForGPBH_2o1().subscribe(onNext: {[self] (response) in
            
            if(response.code == RRHTTPStatusCode.ok.rawValue){
                if let res = Mapper<OrderNeedToPrint>().mapArray(JSONObject: response.data){
                                        
                    let printItem = res.filter{$0.order_id == viewModel.order.value.id}.flatMap{$0.order_details}
                    
                    let pendingItem = printItem.filter{$0.status == PENDING}
                    let cancelItem = printItem.filter{$0.status == CANCEL_FOOD}
                    let returnedItem = printItem.filter{$0.category_type == .drink && $0.return_quantity_for_drink > 0}
                    
                    if pendingItem.count > 0 && print{
                        printItems(items:pendingItem,printType: .new_item)
                    }
                    
                    if cancelItem.count > 0{
                        printItems(items: cancelItem,printType: .cancel_item)
                    }
                    
                    if returnedItem.count > 0{
                        printItems(items: returnedItem,printType: .return_item)
                    }
                    
                    viewModel.foodsNeedToPrint.accept(pendingItem)
                        
                }
            }
        }).disposed(by: rxbag)
    }
        
    

    // ============== Handler printer ==============
    
    //MARK: print_type = 0 => món mới; print_type = 1 => món cập nhật tăng giảm; print_type = 2 => món huỷ;
    func printItems(items:[Food], printType:Constants.printType) {
        let printers = Constants.printers.filter{$0.type == .bar || $0.type == .chef}
        var itemSendToPrinter:[Food] = []
        var itemSendToServer:[Food] = []
        
        for printer in printers{
    
            if printer.is_have_printer == ACTIVE{
                itemSendToPrinter += items.filter{$0.restaurant_kitchen_place_id == printer.id}
            }
            
            itemSendToServer += items.filter{$0.restaurant_kitchen_place_id == printer.id}
        }
            
        itemSendToServer += items.filter{(item) in
            let printerIds = printers.map{$0.id}
            
            return !printerIds.contains(item.restaurant_kitchen_place_id) ? true : false
        }
        
    
        if itemSendToServer.count > 0{
            updateReadyPrinted(order_detail_ids: itemSendToServer.map{$0.id})
        }
       
        if itemSendToPrinter.count > 0 && printers.filter{$0.is_have_printer == ACTIVE}.count > 0{
            
            PrinterUtils.shared.PrintItems(
                presenter: self,
                order:viewModel.order.value,
                printItem:itemSendToPrinter,
                printers:printers.filter{$0.is_have_printer == ACTIVE},
                printType:printType,
                completetHandler: {self.getOrder()})
        }
    }
}





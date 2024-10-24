//
//  PaymentRebuildViewController + Extension + print.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 24/10/2023.
//

import UIKit
import JonAlert
import ObjectMapper

extension PaymentRebuildViewController {
    
    //MARK: print_type = 0 => món mới; print_type = 1 => món cập nhật tăng giảm; print_type = 2 => món huỷ;
    func printItems(items:[Food], printType:Constants.printType) {
        
        let printers = Constants.printers.filter{$0.type == .chef || $0.type == .bar}
        
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
                completetHandler: {self.getOrderDetail()})
        }
        
    }
    
    
    //MARK: Print receipt
    func printReceipt(orderDetail:OrderDetail, bankAccount:BankAccount) {
        var order = orderDetail
        let completeHandler = {
            self.navigationController?.viewControllers.removeAll(where: { (vc) -> Bool in
                return vc.isKind(of: OrderDetailViewController.self) ? true : false
            })
            self.viewModel.makePopViewController()
        }
        
        if var buffet = order.buffet, buffet.id > 0{
          
            if let position =  order.order_details.firstIndex(where: {$0.id == buffet.id}){
                order.order_details.remove(at: position)
            }
            
            if buffet.ticketChildren.count > 0{
                
                for ticket in buffet.ticketChildren{
                    order.order_details.append(OrderItem(
                          name: String(format:"%@ (%@)",buffet.buffet_ticket_name,ticket.name),
                          price:ticket.price,
                          quantity: Float(ticket.quantity),
                          total_price: Double(ticket.total_amount),
                          discount_percent: ticket.discountPercent,
                          discount_amount: ticket.discountAmount,
                          discount_price: ticket.discountPrice
                          
                    ))
                }
                
            }else{
                
                order.order_details.append(OrderItem(
                    name: buffet.buffet_ticket_name,
                    price:buffet.adult_price,
                    quantity: Float(buffet.adult_quantity),
                    total_price: Double(buffet.total_adult_amount),
                    discount_percent: buffet.adult_discount_percent,
                    discount_amount: buffet.adult_discount_amount,
                    discount_price: buffet.adult_discount_price
                ))
            }
        }
        
        PrinterUtils.shared.PrintReceipt(
            presenter: self,
            order: order,
            bankAccount: bankAccount,
            printer: Constants.printers.filter{$0.type == .cashier}.first ?? Printer(),
            completetHandler: order.status == ORDER_STATUS_COMPLETE || order.status == ORDER_STATUS_DEBT_COMPLETE ? nil : completeHandler
        )
    }

}






extension PaymentRebuildViewController {
    
    
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
                    
                    let items_need_to_print = res.filter{$0.order_id == viewModel.order.value.id}.flatMap{$0.order_details}
                    
                    /*
                        nếu có món cần in thì in
                        nếu ko có cần in thì ta thực hiện bước thanh toán tiếp theo (step2: yêu cầu người dùng nhập số lượng người)
                        */
                    
                    if (items_need_to_print.count > 0) {
                        self.viewModel.itemsNeedToPrint.accept(items_need_to_print)
                        self.presentModalDialogConfirmViewController(
                            content: "Hiện tại còn món chưa gửi Bếp/Bar bạn có muốn gửi Bếp/Bar trước khi thanh toán không?",
                            confirmClosure: {
                                let itemsNeedToPrint = self.viewModel.itemsNeedToPrint.value

                                if(itemsNeedToPrint.count > 0){
                                    permissionUtils.GPBH_2_o_2
                                    ? self.requestPrintChefBar(printType: .new_item)
                                    : self.printItems(items:itemsNeedToPrint,printType: .new_item)
                                }
                            }
                        )
                    }else{
                        self.executePaymentProcedure(step: 2)
                    }
                    
                }
            }
        }).disposed(by: rxbag)
    }
    
}





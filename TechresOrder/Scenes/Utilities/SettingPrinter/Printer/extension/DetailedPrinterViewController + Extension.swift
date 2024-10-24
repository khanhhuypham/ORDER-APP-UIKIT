//
//  StampPrinterViewController + Extension.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 20/09/2023.
//

import UIKit
import RxSwift
import JonAlert
extension DetailedPrinterViewController{
    func updateKitchen(){
        viewModel.updateStampPrinter().subscribe(onNext: { [self] (response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){
                dLog("Update Kitchen Success...")
                self.viewModel.makePopViewController()
            }else{
                JonAlert.showError(message: response.message ?? "", duration: 2)
            }
        }).disposed(by: rxbag)
    }
    
}


//MARK: print test data for Techres order app
extension DetailedPrinterViewController{
    func printTestForTechResOrderApp(printer:Printer){
       
        if printer.type == .cashier{
            printTestReceipt(printer: printer)
        }else if printer.type == .stamp{
            printTestLabel(printer: printer)
        }else if printer.type == .chef || printer.type == .bar{
            printTestChefBar(printer: printer)
        }
        
    }
    
    private func printTestReceipt(printer:Printer){
        
        var printItems:[OrderItem] = []
        printItems.append(OrderItem.init(name: "Đậu phộng rang", price: 10000, quantity: 3, total_price: 30000))
        printItems.append(OrderItem.init(name: "Mì xào hải sản", price: 50000, quantity: 2, total_price: 100000))
      
        var item = OrderItem.init(name: "Lẩu thái", price: 290000, quantity: 2, total_price: 580000)
        item.order_detail_additions.append(OrderDetailAddition.init(id: 1, name: "Rau", quantity: 1, price: 10000, total_price: 10000))
        item.order_detail_additions.append(OrderDetailAddition.init(id: 2, name: "Mì gói", quantity: 2, price: 5000, total_price: 10000))
        item.order_detail_additions.append(OrderDetailAddition.init(id: 3, name: "Tôm", quantity: 3, price: 15000, total_price: 45000))
        item.total_price_include_addition_foods = item.total_price + item.order_detail_additions.map{Double($0.total_price)}.reduce(0,+)
        printItems.append(item)
     
        var order = OrderDetail()
        order.created_at = TimeUtils.getCurrentDateTime().dateTimeNow
        order.id = 34567
        order.table_name = "BÀN A1"
        order.table_id = 100
        order.employee_name = "Phục vụ 001"
        order.branch_phone = "0123456789"
        order.total_amount = 1000000
        order.total_amount_discount_amount = 20000
        order.vat_amount = 10000
        order.vat_percent = 35
        order.total_final_amount = 970000
        order.branch_address = ManageCacheObject.getCurrentBranch().address
        order.order_details = printItems
        
        let bankAccount = BankAccount.init(
            bank_number: "012345678910",
            bank_name: "Ngân hàng TMCP Ngoại Thương Việt Nam - Vietcombank",
            bank_account_name: "Huy Chicken NO.1",
            qr_code: String(format: "%@:%d:%d:%d",
                            "REGISTER_MEMBERSHIP_CARD",
                            ManageCacheObject.getCurrentUser().restaurant_id,
                            ManageCacheObject.getCurrentBrand().id,
                            ManageCacheObject.getCurrentUser().id)
        )
        
        PrinterUtils.shared.PrintReceipt(presenter: self, order: order, bankAccount:bankAccount,printer: printer)
    }
    
    
    private func printTestLabel(printer:Printer){
        var order = OrderDetail()
        order.created_at = TimeUtils.getCurrentDateTime().dateTimeNow
        order.id = 34567
   
        let printItems = (1...3).map{(i) in
            var childrenItems:[FoodAddition] = []
            var item = Food(id: i + 100, name: "Trà sữa trân châu \(i)", quantity: Float(i), price: 30000 + i*1000, note: "nhiều sữa",restaurant_kitchen_place_id:0)
            
            if i%2 == 1{
                item.note = ""
            }
            
            item.is_allow_print_stamp = ACTIVE
            for i in (1...7){
                var childrenItem = FoodAddition.init()
                childrenItem.name = String(format: "Thạch trái cây", i)
                childrenItem.price = 1000
                childrenItem.quantity = i
                childrenItems.append(childrenItem)
            }
            item.addition_foods = i%2 == 1 ? childrenItems : []
            return item
        }
        
        PrinterUtils.shared.PrintItems(
            presenter:self,
            order:order,
            printItem:printItems,
            printers:[printer],
            printType:.print_test
        )
        
        
    }

    private func printTestChefBar(printer:Printer){
        var order = OrderDetail()
        order.created_at = TimeUtils.getCurrentDateTime().dateTimeNow
        order.id = 34567
        order.table_name = "Bàn A1"
        order.employee_name = "Phục vụ 001"
        
        let printItems = (1...5).map{(i) in
            return Food(id: i + 100, name: "Cơm sườn \(i)", quantity: Float(i), price: 12000000, note: "không hành, không tiêu",restaurant_kitchen_place_id:printer.id)
        }
        
        PrinterUtils.shared.PrintItems(
            presenter:self,
            order:order,
            printItem:printItems,
            printers:[printer],
            printType:.print_test
        )
    }
}



//MARK: print test data for app food
extension DetailedPrinterViewController{
    
    func printTestForFoodApp(printer:Printer){
   
        if printer.type == .cashier_of_food_app{
            printTestReceiptForFoodApp(printer:printer)
        }else if printer.type == .stamp_of_food_app{
            printTestLabelForFoodApp(printer: printer)
        }
        
    }

    private func printTestReceiptForFoodApp(printer:Printer){
        
        var printItems:[OrderItemOfFoodApp] = []
        printItems.append(OrderItemOfFoodApp.init(name: "Đậu phộng rang", price: 10000, quantity: 3, total_price: 30000))
        printItems.append(OrderItemOfFoodApp.init(name: "Mì xào hải sản", price: 50000, quantity: 2, total_price: 100000))
      
     
        var order = FoodAppOrder()
        order.created_at = TimeUtils.getCurrentDateTime().dateTimeNow
        order.channel_order_id = "4959893"
        order.id = 233
        order.channel_order_food_name = "Beefood"
        order.channel_order_food_code = "PKH"
        order.customer_name = "Phạm khánh huy"
        order.phone = "0941695140"
        order.total_amount = 1000000
        order.details = printItems
        PrinterUtils.shared.PrintFoodAppItems(presenter: self, printers: Constants.printers.filter{$0.type == .cashier_of_food_app},orders:[order])
    }
    
    
    private func printTestLabelForFoodApp(printer:Printer){
        var order = FoodAppOrder()
        order.created_at = TimeUtils.getCurrentDateTime().dateTimeNow
        order.channel_order_id = "4959893"
        order.id = 233
        order.channel_order_food_name = "Beefood"
        order.channel_order_food_code = "PKH"
        order.customer_name = "Phạm khánh huy"
        order.phone = "0941695140"
        order.total_amount = 1000000
   
        let children = (1...3).map{(i) in

            let price = Double(30000 + i*1000)
            let quantity = Float(i)
            var food_options:[OrderItemChildrenOfFoodApp] = []
            
            for i in (1...10){
                food_options.append(
                    OrderItemChildrenOfFoodApp(
                        name: String(format: "Món thêm %d", i),
                        quantity: i,
                        price: i * 1000
                ))
            }
            
            
            return OrderItemOfFoodApp(name: "Trà sữa trân châu \(i)",price:price, quantity:quantity,total_price: price * Double(quantity),food_options: food_options)
        }
        order.details = children
    
        PrinterUtils.shared.PrintFoodAppItems(presenter: self, printers: Constants.printers.filter{$0.type == .stamp_of_food_app},orders: [order])
        
    }

}







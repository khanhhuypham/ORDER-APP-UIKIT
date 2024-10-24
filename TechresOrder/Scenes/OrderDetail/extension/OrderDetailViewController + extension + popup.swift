//
//  OrderDetailRebuildViewController + extension + popup.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 01/09/2023.
//

import UIKit
import JonAlert

extension OrderDetailViewController:CaculatorInputQuantityDelegate{
    func presentModalInputQuantityViewController(currentQuantity:Float,is_sell_by_weight:Int,position:Int) {
        let inputQuantityViewController = QuantityInputViewController()
        inputQuantityViewController.max_quantity = 999
        inputQuantityViewController.current_quantity = currentQuantity
        inputQuantityViewController.is_sell_by_weight = is_sell_by_weight
        inputQuantityViewController.view.backgroundColor = ColorUtils.blackTransparent()
        let nav = UINavigationController(rootViewController: inputQuantityViewController)
        // 1
        nav.modalPresentationStyle = .overCurrentContext
        // 2
        if #available(iOS 15.0, *) {
            if let sheet = nav.sheetPresentationController {
                // 3
                sheet.detents = [.large()]
            }
        } else {
            // Fallback on earlier versions
        }
        // 4
        inputQuantityViewController.delegate_quantity = self
        inputQuantityViewController.position = position
        present(nav, animated: true, completion: nil)
    }
      
    func callbackCaculatorInputQuantity(number: Float, position: Int,id:Int) {
        var order = viewModel.order.value
        order.order_details[position].quantity = number
        order.order_details[position].isChange = ACTIVE
        viewModel.order.accept(order)
    }
    
}

extension OrderDetailViewController: NotFoodDelegate{
    func callBackNoteFood(pos: Int, id:Int ,note: String) {
        addNoteToFood(orderDetailId:viewModel.order.value.order_details[pos].id,note: note)
    }

    func presentModalNoteViewController(pos:Int, note:String = "", order_detail_id:Int) {
        let vc = NoteViewController()
        vc.delegate = self
        vc.food_id = order_detail_id
        vc.pos = pos
        vc.food_note = note
        vc.view.backgroundColor = ColorUtils.blackTransparent()
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overCurrentContext
        present(vc, animated: true, completion: nil)
    }
      
    
   
    
}

extension OrderDetailViewController: ReasonCancelFoodDelegate {
    func cancel(item: OrderItem) {
        var order = viewModel.order.value
        
        if let position = order.order_details.firstIndex(where:{$0.id == item.id}){
            if order.order_details[position].quantity == 0{
                order.order_details[position].quantity = order.order_details[position].is_sell_by_weight == ACTIVE
                ? 0.01
                : 1
            }
        }
        viewModel.order.accept(order)
    }
    

    func removeItem(item: OrderItem) {
        switch item.category_type {
            case .buffet_ticket:
                cancelBuffetTicket(item: item)
            default:
                item.is_extra_Charge == ACTIVE
                ? cancelExtraCharge(item:item)
                : cancelFood(item: item)
                
        }
        
      
    }

    
    func presentModalCancelFoodViewController(orderItem:OrderItem) {
        let vc = ReasonCancelFoodViewController()
        vc.orderItem = orderItem
        vc.delegate = self
        vc.view.backgroundColor = ColorUtils.blackTransparent()
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overCurrentContext
        present(vc, animated: true, completion: nil)
    }
}



extension  OrderDetailViewController: OrderMoveFoodDelegate {
    func callBackToSplitItem(destination_order: Order, target_order: Order,only_one:Int,isTargetActive:Int) {
        presentModalSlitFoodViewController(destination_order: destination_order, target_order: target_order,only_one: only_one,isTargetActive:isTargetActive)
    }
    
    func presentModalSeparateFoodViewController(order:OrderDetail, only_one:Int = 0) {
        let vc = DialogChooseTableViewController()
        vc.order = Order(orderDetail: order)
        vc.option = .splitFood
        vc.isSplittingSingleItem = only_one
        vc.delegate = self
        vc.moveTableDelegate = self
        vc.delegate = self
        vc.modalPresentationStyle = .pageSheet
        present(vc, animated: true, completion: nil)
    }
}


extension OrderDetailViewController: TechresDelegate{
    func callBackReload() {
        self.getOrder()
    }
    
    func presentModalSlitFoodViewController(destination_order: Order, target_order: Order,only_one:Int = 0,isTargetActive:Int) {
        let vc = SplitFoodViewController()
        vc.delegate = self
        vc.only_one = only_one
        if only_one == ACTIVE{
            vc.order_details = self.viewModel.foodsNeedToSplit.value
        }
        vc.order_id = destination_order.id
        vc.destination_table_id = destination_order.table_id
        vc.destination_table_name = destination_order.table_name
        vc.isTargetActive = isTargetActive
        vc.target_table_id = target_order.table_id
        vc.target_table_name = target_order.table_name
        vc.target_order_id = target_order.id
        vc.modalPresentationStyle = .pageSheet
        present(vc, animated: true, completion: nil)

    }
    
    
    func presentModalReviewFoodViewController(order_id:Int) {
        let vc = ReviewFoodViewController()
        vc.view.backgroundColor = ColorUtils.blackTransparent()
        vc.order_id = order_id
        vc.delegate = self
        let nav = UINavigationController(rootViewController: vc)
        // 1
        nav.modalPresentationStyle = .overCurrentContext

        // 2
        if #available(iOS 15.0, *) {
            if let sheet = nav.sheetPresentationController {
                
                // 3
                sheet.detents = [.large()]
                
            }
        } else {
            // Fallback on earlier versions
        }
        // 4
       
        present(nav, animated: true, completion: nil)

    }


}
//MARK: return drink
extension  OrderDetailViewController: ReturnBeerDelegate {
    func callBackReturnBeer(note: String, order_detail_id:Int) {
                
        permissionUtils.GPBH_2_o_1
        ? self.getOrderNeedToPrintFor2o1()
        : self.getFoodsNeedPrint()
    }
    
    
    func presentModalReturnBeerViewController(order_id:Int, order_detail_id:Int, quantity:Int) {
        let returnFoodViewController = ReturnFoodViewController()
        returnFoodViewController.order_id = order_id
        returnFoodViewController.order_detail_id = order_detail_id

        returnFoodViewController.total = Float(quantity)
        returnFoodViewController.type = 1
        returnFoodViewController.delegateReturnBeer = self
        returnFoodViewController.view.backgroundColor = ColorUtils.blackTransparent()
            let nav = UINavigationController(rootViewController: returnFoodViewController)
            // 1
            nav.modalPresentationStyle = .overCurrentContext

            // 2
            if #available(iOS 15.0, *) {
                if let sheet = nav.sheetPresentationController {
                    
                    // 3
                    sheet.detents = [.large()]
                    
                }
            } else {
                // Fallback on earlier versions
            }

            present(nav, animated: true, completion: nil)

        }
    
}




extension OrderDetailViewController {
    
    
    func presentModalDialogConfirmViewController(content:String,confirmClosure:(()-> Void)? = nil,cancelClosure:(()-> Void)? = nil) {
        let vc = PopupConfirmViewController()
        vc.confirmClosure = confirmClosure
        vc.cancelClosure = cancelClosure
        vc.content = content
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overCurrentContext
        present(vc, animated: true, completion: nil)
    }
    
    
   
    //MARK: service popup
    func presentServicePopupViewController(orderItem:OrderItem) {
        let vc = ServicePopupViewController()
        vc.view.backgroundColor = ColorUtils.blackTransparent()
        vc.completion = getOrder
        vc.orderItem = orderItem
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overCurrentContext
        present(vc, animated: true, completion: nil)
    }
    
    //MARK: popup to edit children food
    func presentEditChildrenFoodViewController(orderItem:OrderItem? = nil) {
        let vc = EditChildrenFoodViewController()
        vc.view.backgroundColor = ColorUtils.blackTransparent()
        vc.orderItem = orderItem
        vc.orderId = viewModel.order.value.id
        vc.completetion = getOrder
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overCurrentContext
        present(vc, animated: true, completion: nil)
    }
    
    //MARK: popup to edit children food
    func presentEditBuffetTicketViewController(buffet:Buffet? = nil) {
        let vc = EditBuffetTicketViewController()
        vc.view.backgroundColor = ColorUtils.blackTransparent()
        vc.buffet = buffet
        vc.order = viewModel.order.value
        vc.completetion = getOrder
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overCurrentContext
        present(vc, animated: true, completion: nil)
    }
}

//MARK: discount food
extension OrderDetailViewController:EnterPercentDelegate{
    func callbackToGetPercent(id:Int,percent: Int) {
        let order = viewModel.order.value
 
        if let position = order.order_details.firstIndex(where: {$0.id == id}){
            var item = order.order_details[position]
            item.discount_percent = percent
            discountOrderItem(item:item)
        }
    }

    func presentPopupDiscountViewController(itemId:Int,percent:Int? = nil) {
        let vc = PopupEnterPercentViewController()
        vc.header = "GIẢM GIÁ MÓN"
        vc.placeHolder = "Vui lòng nhập % bạn muốn giảm giá"
        vc.percent = percent
        vc.itemId = itemId
        vc.delegate = self
        vc.view.backgroundColor = ColorUtils.blackTransparent()
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overCurrentContext
        present(vc, animated: true, completion: nil)
    }

}




//MARK: chọn phương thức thanh toán (dành cho bàn mang về)
extension OrderDetailViewController:PopupPaymentMethodDelegate{
    func presentPaymentPopupViewController(totalPayment:Double) {
        let vc = PopupPaymentMethodViewController()
        vc.delegate = self
        vc.totalPayment = totalPayment
        vc.modalPresentationStyle = .pageSheet
        present(vc, animated: true, completion: nil)
    }
    func callBackToGetPaymentMethod(paymentMethod: Int) {

        var payment = viewModel.payment.value
        payment.payment_method = paymentMethod
        payment.cash_amount = 0
        payment.bank_amount = 0
        payment.transfer_amount = 0
  
        /*
         Constants.PAYMENT_METHOD.CASH = 1
         Constants.PAYMENT_METHOD.TRANSFER = 6 //Chuyển khoản
         Constants.PAYMENT_METHOD.ATM_CARD = 2 //sử dụng thẻ
         */
        switch paymentMethod{
            case Constants.PAYMENT_METHOD.CASH:
                payment.cash_amount = viewModel.order.value.total_amount
            case Constants.PAYMENT_METHOD.TRANSFER:
                payment.transfer_amount = viewModel.order.value.total_amount
            case Constants.PAYMENT_METHOD.ATM_CARD:
                payment.bank_amount = viewModel.order.value.total_amount
            default:
                break
        }
        
        viewModel.payment.accept(payment)
        
        completePayment()
        
        /*
            sau khi chọn Phương thức thanh toán xong thì
            ta thực hiện bước thanh toán và yêu cầu thành toán
         */
    }
}

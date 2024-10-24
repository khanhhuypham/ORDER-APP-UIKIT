//
//  PaymentRebuildViewController + extension +popup.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 23/10/2023.
//

import UIKit
import JonAlert


//MARK: -- show review food contrloller
extension PaymentRebuildViewController{
  
    func presentExtraChargePopup(order_id:Int) {
        let vc = ExtraChargeViewController()
        vc.order_id = order_id
        vc.completion = self.getOrderDetail
        vc.view.backgroundColor = ColorUtils.blackTransparent()
        vc.modalPresentationStyle = .overCurrentContext
        present(vc, animated: true, completion: nil)
    }

    func presentModalDiscountViewController(order_id:Int) {
        let vc = DiscountViewController()
        vc.order_id = order_id
        vc.completion = getOrderDetail
        vc.view.backgroundColor = ColorUtils.blackTransparent()
        vc.modalPresentationStyle = .overCurrentContext
        present(vc, animated: true, completion: nil)
    }
        
    func presentModalDetailVATViewController(order_id:Int) {
        let vc = DetailVATViewController()
        vc.order_id = order_id
        vc.modalPresentationStyle = .pageSheet
        present(vc, animated: true, completion: nil)
    }
    
    
    func presentModalDialogConfirmViewController(content:String,confirmClosure:(()-> Void)? = nil,cancelClosure:(()-> Void)? = nil) {
        let vc = PopupConfirmViewController()
        vc.content = content
        vc.confirmClosure = confirmClosure
        vc.cancelClosure = cancelClosure
        vc.modalPresentationStyle = .overCurrentContext
        present(vc, animated: true, completion: nil)
    }

}


//MARK: -- show update customer slot contrloller    
extension PaymentRebuildViewController: UpdateCustomerSloteDelegate{
    func presentModalUpdateCustomerSlotViewController() {
        let updateCustomerSlotViewController = UpdateCustomerSlotViewController()
        updateCustomerSlotViewController.delegate = self
        updateCustomerSlotViewController.view.backgroundColor = ColorUtils.blackTransparent()
        let nav = UINavigationController(rootViewController: updateCustomerSlotViewController)
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
    func callbackPeopleQuantity(number_slot: Int) {
        if(number_slot > 0){
            var order = viewModel.order.value
            order.customer_slot_number = number_slot
            viewModel.order.accept(order)
            updateCustomerNumberSlot()
        }else{
            JonAlert.showError(message:"Vui lòng nhật số người trên bàn phải lớn hơn 0", duration: 3.0)
        }
       
    }
}

//MARK: -- show review food contrloller
extension PaymentRebuildViewController: TechresDelegate{
    
    func presentModalReviewFoodViewController(order_id:Int) {
        let vc = ReviewFoodViewController()
        vc.view.backgroundColor = ColorUtils.blackTransparent()
        vc.order_id = order_id
        vc.delegate = self
        vc.modalPresentationStyle = .overCurrentContext
        present(vc, animated: true, completion: nil)

    }
    
    func callBackReload() {
        /*sau khi đánh giá món thành công ta thực hiện bước thanh toán tiếp theo (step3: kiểm tra các món chưa được in)
            ở bước này ta cứ kết thúc quy trình thanh toán để tránh trường hợp người dùng chưa đánh giá hết món tất cả các món cần đánh,
         */
        getOrderDetail()
    }
}


extension PaymentRebuildViewController:PopupPaymentMethodDelegate{
    func presentPaymentPopupViewController(totalPayment:Double) {
        let vc = PopupPaymentMethodViewController()
        vc.delegate = self
        vc.totalPayment = totalPayment
        vc.modalPresentationStyle = .overCurrentContext
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
        
        /*
            sau khi chọn Phương thức thanh toán xong thì
            ta thực hiện bước thanh toán và yêu cầu thành toán
         */
        executePaymentProcedure(step: 5)

    }
}

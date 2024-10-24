//
//  PaymentQRCodeViewController.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 26/06/2024.
//

import UIKit
import RxSwift
import ObjectMapper
import JonAlert
class PaymentQRCodeViewController: BaseViewController {
    
    
    @IBOutlet weak var qr_code_view: UIImageView!
    
    @IBOutlet weak var lbl_total_amount: UILabel!
    
    @IBOutlet weak var lbl_account_holder: UILabel!
    @IBOutlet weak var lbl_account_number: UILabel!
    @IBOutlet weak var lbl_bank: UILabel!
    
    var order = Order()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        qr_code_view?.image = generateQRCode(from: "")
        
        let bankAccount = Constants.bankAccount
        lbl_account_number.text = String(bankAccount.bank_number)
        lbl_bank.text = String(bankAccount.bank_name)
        lbl_account_holder.text = String(bankAccount.bank_account_name)
        getBrandBankAccount(order: self.order ?? Order()!, completeHandler: {})
        

        if let order = self.order{
            

            if(ManageCacheObject.getSetting().is_hide_total_amount_before_complete_bill == ACTIVE && !Utils.checkRoleOwnerAndGeneralManager(permission: ManageCacheObject.getCurrentUser().permissions)){
                lbl_total_amount.text = order.total_amount > 1000
                ? Utils.hideTotalAmount(amount: Float(order.total_amount))
                : Utils.stringVietnameseMoneyFormatWithNumberDouble(amount: order.total_amount)
                
            }else{
                lbl_total_amount.text = Utils.stringVietnameseMoneyFormatWithNumberDouble(amount: order.total_amount)
            }
            
        }
        
        
    }
    
    
    func generateQRCode(from string: String) -> UIImage? {
        let data = string.data(using: String.Encoding.ascii)

        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            let transform = CGAffineTransform(scaleX: 10, y: 10)

            if let output = filter.outputImage?.transformed(by: transform) {
                return UIImage(ciImage: output)
            }
        }

        return nil
    }

}

extension PaymentQRCodeViewController {
    
    func getBrandBankAccount(order:Order,completeHandler:@escaping (()->Void)){
        appServiceProvider.rx.request(.getBrandBankAccount(order_id: order.id,brand_id: Constants.brand.id))
        .filterSuccessfulStatusCodes()
        .mapJSON().asObservable()
        .showAPIErrorToast()
        .mapObject(type: APIResponse.self).subscribe(onNext: { [self] (response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){
                if let bankAccount = Mapper<BankAccount>().map(JSONObject: response.data) {
                                        
                    if !bankAccount.bank_number.isEmpty && !bankAccount.bank_name.isEmpty && !bankAccount.bank_account_name.isEmpty{
                
                        qr_code_view?.image = generateQRCode(from:bankAccount.qr_code)
                        lbl_account_number.text = String(bankAccount.bank_number)
                        lbl_bank.text = String(bankAccount.bank_name)
                        lbl_account_holder.text = String(bankAccount.bank_account_name)
                        ManageCacheObject.setBankAccount(bankAccount)
                        
                    }else{
                        dismiss(animated: true)
                    }

                }
            }else{
                
                dismiss(animated: true, completion:{
                    JonAlert.showError(message: response.message ?? "", duration: 2.0)
                })
            }
        }).disposed(by: rxbag)
    }
    
//    func completePayment() {
//        //CALL API COMPLETED ORDER
//        appServiceProvider.rx.request(.completedPayment(
//            branch_id: branch_id.value,
//            order_id: order.value.id,
//            cash_amount: payment.value.cash_amount,
//            bank_amount: payment.value.bank_amount,
//            transfer_amount:payment.value.transfer_amount,
//            payment_method_id:payment.value.payment_method,
//            tip_amount:payment.value.tip_amount))
//               .filterSuccessfulStatusCodes()
//               .mapJSON().asObservable()
//               .showAPIErrorToast()
//               .mapObject(type: APIResponse.self).subscribe(onNext: { [self] (response) in
//            if(response.code == RRHTTPStatusCode.ok.rawValue){
//
//                
//                let completeHandler:()->Void = {
//                    JonAlert.showSuccess(message:"Đã hoàn tất đơn hàng và in bill cho khách.", duration: 2.0)
//                    self.navigationController?.viewControllers.removeAll(where: { (vc) -> Bool in
//                        return vc.isKind(of: OrderDetailViewController.self) ? true : false
//                    })
//                    self.viewModel.makePopViewController()
//                }
//                
//                if permissionUtils.BillPrinter {
//                    getBrandBankAccount(completeHandler: completeHandler)
//                }else{
//                    completeHandler()
//                }
//                
//            }else{
//                JonAlert.showError(message: response.message ?? "", duration: 2.0)
//            }
//        }).disposed(by: rxbag)
//    }
}


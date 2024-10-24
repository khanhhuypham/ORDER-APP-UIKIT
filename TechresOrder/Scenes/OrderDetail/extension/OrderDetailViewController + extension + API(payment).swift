//
//  OrderDetailViewController + extension + API(payment).swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 09/05/2024.
//

import UIKit
import ObjectMapper
import RxSwift
import JonAlert
extension OrderDetailViewController {
    
    func getBrandBankAccount(completeHandler:@escaping (()->Void)){
        viewModel.getBrandBankAccount().subscribe(onNext: { [self] (response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){
                if let bankAccount = Mapper<BankAccount>().map(JSONObject: response.data) {
                    
                    PrinterUtils.shared.PrintReceipt(
                        presenter: self,
                        order: viewModel.order.value,
                        bankAccount: bankAccount,
                        printer: Constants.printers.filter{$0.type == .cashier}.first ?? Printer(),
                        completetHandler: completeHandler
                    )
                    
                    
                }
            }else{
                JonAlert.showError(message: response.message ?? "", duration: 2.0)
            }
        }).disposed(by: rxbag)
    }
    
    func completePayment() {
        //CALL API COMPLETED ORDER
        viewModel.completedPayment().subscribe(onNext: { [self] (response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){

                
                let completeHandler:()->Void = {
                    JonAlert.showSuccess(message:"Đã hoàn tất đơn hàng và in bill cho khách.", duration: 2.0)
                    self.navigationController?.viewControllers.removeAll(where: { (vc) -> Bool in
                        return vc.isKind(of: OrderDetailViewController.self) ? true : false
                    })
                    self.viewModel.makePopViewController()
                }
                
                if permissionUtils.BillPrinter {
                    getBrandBankAccount(completeHandler: completeHandler)
                }else{
                    completeHandler()
                }
                
            }else{
                JonAlert.showError(message: response.message ?? "", duration: 2.0)
            }
        }).disposed(by: rxbag)
    }
    
    
    
    
    
    
}

//
//  BankAccountSetting+extension+api.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 16/04/2024.
//

import UIKit
import RxSwift
import JonAlert
import ObjectMapper
extension BankAccountSettingViewController {

    func getBankAccount(){
        viewModel.getBankAccount().subscribe(onNext: { (response) in
        
            if(response.code == RRHTTPStatusCode.ok.rawValue){
                if let res = Mapper<BankAccountResponse>().map(JSONObject: response.data){
                    self.viewModel.bankAccounts.accept(res.list ?? [])
                    self.view_btn.isHidden = self.viewModel.bankAccounts.value.count > 0 ? true : false
                }
            }else{
                JonAlert.showError(message: response.message ?? "Có lỗi xảy ra trong quá trình kết nối tới máy chủ. Vui lòng thử lại", duration: 2.0)
                dLog(response.message ?? "")

            }
        }).disposed(by: rxbag)
    }
    
    
    func presentasd(account:BankAccount? = nil){
       
        let vc = BankAccountCreateViewController()
        vc.bankAccount = account
        vc.completion = getBankAccount
        vc.view.backgroundColor = ColorUtils.blackTransparent()
        vc.modalPresentationStyle = .overFullScreen
        if #available(iOS 15.0, *) {
            if let sheet = vc.sheetPresentationController {
                // 3
                sheet.detents = [.medium()]
                
            }

        }
        present(vc, animated: true, completion: nil)
    }
    
}

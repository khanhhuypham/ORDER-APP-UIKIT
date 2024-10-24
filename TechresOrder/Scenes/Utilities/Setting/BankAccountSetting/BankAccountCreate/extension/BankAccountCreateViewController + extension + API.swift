//
//  BankAccountCreateViewController + extension + API.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 03/05/2024.
//

import UIKit
import JonAlert
import ObjectMapper
import RxSwift

extension BankAccountCreateViewController {
    
    func getBankList(){
        viewModel.getBankList().subscribe(onNext: { (response) in
        
            if(response.code == RRHTTPStatusCode.ok.rawValue){
                if let list = Mapper<Bank>().mapArray(JSONObject: response.data){
                 
                    self.viewModel.bankList.accept(list)
                    
                    if let account = self.bankAccount{
                       
                        if let position = list.firstIndex(where: {$0.bin == account.bank_identify_id}){
                            self.selectUnitAt(pos: position)
                        }
                        
                    }else if list.count > 0 {
                        self.selectUnitAt(pos: 0)
                    }

                }
            }else{
                JonAlert.showError(message: response.message ?? "", duration: 2.0)
                dLog(response.message ?? "")

            }
        }).disposed(by: rxbag)
    }
    
    func createBankAccount(bankAccount:BankAccount){
        viewModel.createBankAccount(bankAccount: bankAccount).subscribe(onNext: { (response) in

            if(response.code == RRHTTPStatusCode.ok.rawValue){
          
                self.showSuccessMessage(content: "Tạo tài khoản thành công")
                self.dismiss(animated: true, completion: {
                    (self.completion ?? {})()
                })
            }else{
                JonAlert.showError(message: response.message ?? "", duration: 2.0)
                dLog(response.message ?? "")

            }
        }).disposed(by: rxbag)
    }
    
    func updateBankAccount(bankAccount:BankAccount){
        viewModel.updateBankAccount(bankAccount: bankAccount).subscribe(onNext: { (response) in
        
            if(response.code == RRHTTPStatusCode.ok.rawValue){
                self.showSuccessMessage(content: "Cập nhật thành công")
               
                self.dismiss(animated: true, completion: {
                    (self.completion ?? {})()
                })
            }else{
                JonAlert.showError(message: response.message ?? "", duration: 2.0)
                dLog(response.message ?? "")
            }
        }).disposed(by: rxbag)
    }
    
    
    
    
    
    
    
    
}

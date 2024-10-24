//
//  AppLoginViewController + extension.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 29/07/2024.
//

import UIKit
import RxSwift

extension AppFoodLoginViewController{
    
    func mapDataAndValidate(){
        mappData()
        isValid()
    }
    

    private func mappData(){
        
        
        _ = text_field_phone.rx.text.map{[self] phone in
            var cre = viewModel.credential.value
            cre.phoneNumber = phone ?? ""
            text_field_phone.text = cre.phoneNumber
            return cre
        }.bind(to: viewModel.credential).disposed(by: rxbag)
        
        
        _ = text_field_token.rx.text.map{[self] token in
            var cre = viewModel.credential.value
            cre.access_token = token ?? ""
            
            if cre.partnerType == .shoppee{
                cre.x_merchant_token = token ?? ""
            }
            
            return cre
        }.bind(to: viewModel.credential).disposed(by: rxbag)
        
    
        _ = text_field_username.rx.text.map{[self] username in
            var cre = viewModel.credential.value
            cre.username = username ?? ""
            return cre
        }.bind(to: viewModel.credential).disposed(by: rxbag)
        
        _ = text_field_password.rx.text.map{[self] pwd in
            var cre = viewModel.credential.value
            cre.password = pwd ?? ""
            return cre
        }.bind(to: viewModel.credential).disposed(by: rxbag)
        
        
        
        
    
        
    }
        
    private func isValid(){
        Observable.combineLatest(isPhoneValid,isTokenValid,isUserNameValid,isPasswordValid).map{ (a,b,c,d) in
            
            switch self.viewModel.credential.value.partnerType{
                case .shoppee:
                    return b
                case .gofood:
                    return a
                default:
                    return c && d
            }
            
        }.subscribe(onNext: {[weak self](valid) in
            guard let self = self else { return }
        

            self.btn_login.isEnabled = valid
     
            if self.viewModel.credential.value.is_connection == ACTIVE{
                self.btn_login.tintColor = valid ? ColorUtils.red_600() :ColorUtils.gray_400()
            }else{
                self.btn_login.tintColor = valid ? ColorUtils.orange_brand_900() :ColorUtils.gray_400()
            }
            
           
        }).disposed(by: rxbag)
    }
    
    
    private var isPhoneValid: Observable<Bool>{
        return viewModel.credential.asObservable().map(){[self](credential) in
            return credential.phoneNumber?.count ?? 0 >= 7 && credential.phoneNumber?.count ?? 0 < 15
        }
    }
    

    private var isTokenValid: Observable<Bool>{
        return viewModel.credential.asObservable().map(){[self](credential) in
            return credential.access_token.count >= 1
        }
        
    }
    
   
    private var isUserNameValid: Observable<Bool>{
        return viewModel.credential.asObservable().map(){[self](cre) in
            return cre.username.count >= 1 && cre.username.count <= 128
        }
    }
    
   
    private var isPasswordValid: Observable<Bool>{
        return viewModel.credential.asObservable().map(){[self](cre) in
            return cre.password.count >= 1 && cre.password.count <= 128
        }
    }
    
}

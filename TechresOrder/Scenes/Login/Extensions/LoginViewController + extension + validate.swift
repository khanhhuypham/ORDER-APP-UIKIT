//
//  LoginViewController + extension + validate.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 16/03/2024.
//

import UIKit
import RxSwift

extension LoginViewController {
    
    func mapDataAndValidate(){
        mappData()
        isValid()
        
//        text_field_restaurant.accessibilityIdentifier = ""
//        text_field_account.accessibilityIdentifier = ""
//        text_field_password.accessibilityIdentifier = ""
//        btn_login.accessibilityIdentifier = ""
//        text_field_restaurant.accessibilityIdentifier = Identifiers.LoginScreen.restaurantNameTextField
//        text_field_account.accessibilityIdentifier = Identifiers.LoginScreen.accountTextField
//        text_field_password.accessibilityIdentifier = Identifiers.LoginScreen.passwordTextField
//        btn_login.accessibilityIdentifier = Identifiers.LoginScreen.loginBtn
        
    }
    

    private func mappData(){

        
        _ = text_field_restaurant.rx.text.map{[self](str) in
            
            var name = str ?? ""
            name = name.replacingOccurrences(of: " ", with: "")
            
            if text_field_restaurant.isFirstResponder && name.count > 0{
                lbl_noti_restaurant.isHidden = name.count >= 2 && name.count <= 50
            }
           
            name = String(name.prefix(50))
            text_field_restaurant.text = name
            
            return name
        }.bind(to:viewModel.restaurantName).disposed(by: rxbag)
        
        
        
        _ = text_field_account.rx.text.map{[self](str) in
            
            var username = str ?? ""
            username = username.replacingOccurrences(of: " ", with: "")
            

            if text_field_account.isFirstResponder && username.count > 0{
                lbl_account_error.text = "* Tên đăng nhập từ 8 đến 10 kí tự"
                lbl_account_error.isHidden = username.count >= 8 && username.count <= 10
            }
          
            text_field_account.text = username
            
            return username
        }.bind(to: viewModel.username).disposed(by: rxbag)
        
        
        _ = text_field_password.rx.text.map{[self](str) in
            
//            var pwd = Utils.blockCharacterVN(string: str ?? "")
//            
//            if text_field_password.isFirstResponder && pwd.count > 0{
//               
//                if !(pwd.count >= 6 && pwd.count <= 20){
//                    lbl_error_pwd.text = "* Mật khẩu từ 6 đến 20 ký tự"
//                    lbl_error_pwd.isHidden = false
//                }else if !Utils.textContainsAtLeastThreeCharacter(pwd){
//                    lbl_error_pwd.text = "* Mật khẩu từ 6 đến 20 ký tự!, có ít 3 kí tự chữ cái"
//                    lbl_error_pwd.isHidden = false
//                }else{
//                    lbl_error_pwd.text = ""
//                    lbl_error_pwd.isHidden = true
//                }
//                
//            }
//            
//            pwd = String(pwd.prefix(20))
//            text_field_password.text = pwd
//            return pwd
            
            
            let pwd = str ?? ""
                        
                        
            if text_field_password.isFirstResponder && pwd.count > 0{
                lbl_error_pwd.isHidden = pwd.count >= 4 && pwd.count <= 20
            }
            
          
            return pwd
        }.bind(to: viewModel.password).disposed(by: rxbag)
    }
        
    private func isValid(){
        Observable.combineLatest(isRestaurantNameValid,isUserNameValid,isPasswordValid){$0 && $1 && $2}.subscribe(onNext: {[self](valid) in
            btn_login.isEnabled = valid
            btn_login.backgroundColor = valid ? ColorUtils.orange_brand_900() :ColorUtils.gray_300()
        }).disposed(by: rxbag)
    }
    
    private var isRestaurantNameValid: Observable<Bool>{
        return viewModel.restaurantName.asObservable().map(){[self](name) in
            return name.count >= 2 && name.count <= 50
        }
    }
    
    private var isUserNameValid: Observable<Bool>{
        return viewModel.username.asObservable().map(){[self](name) in
            return name.count >= 8 && name.count <= 10
        }
    }
    
   
    private var isPasswordValid: Observable<Bool>{
        return viewModel.password.asObservable().map(){[self](pwd) in
            return pwd.count >= 4 && pwd.count <= 20
        }
    }
    
}

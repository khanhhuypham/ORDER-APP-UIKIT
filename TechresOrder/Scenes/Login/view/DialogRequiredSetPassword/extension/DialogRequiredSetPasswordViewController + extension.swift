//
//  DialogRequiredSetPasswordViewController + extension.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 24/06/2024.
//

import Foundation
import RxSwift
import RxRelay

extension DialogRequiredSetPasswordViewController{
    
    
    func firstSetup(){
        btn_confirm.isEnabled = false
        btn_confirm.backgroundColor = ColorUtils.gray_300()
        
        text_field_password.addTarget(self, action: #selector(newPasswordtextFieldEditing(_:)), for: .allEditingEvents)
        text_field_confirm_password.addTarget(self, action: #selector(confirmPWDTextFieldEditing(_:)), for: .allEditingEvents)
    }
    
    
    @objc private func newPasswordtextFieldEditing(_ textField: UITextField) {
        let pwd = textField.text ?? ""
        let confirmedPwd = text_field_confirm_password.text ?? ""
        var valid:Bool = true
        var errorMsg = ""
        
        if pwd.count >= 6 && pwd.count <= 20{
            
            if !textContainsAtLeastThreeCharacter(pwd){
                errorMsg = "* Mật khẩu từ 6 đến 20 ký tự, có ít 3 kí tự chữ cái!"
                valid = false
            }else if pwd == self.oldPassword{
                errorMsg = "* Mật khẩu mới không được trùng với mật khẩu cũ!"
                valid = false
            }else{
              
                if confirmedPwd.isEmpty{
                    errorMsg = ""
                    valid = false
                } else if !confirmedPwd.isEmpty && pwd != confirmedPwd {
                    errorMsg = "* Mật khẩu không trùng khớp! với mật khẩu nhập lại"
                    valid = false
                }else{
                    errorMsg = ""
                    lbl_error_of_confirm_pwd.text = ""
                    valid = true
                }
            }
            
        }else{
            errorMsg = "* Mật khẩu từ 6 đến 20 ký tự!"
            
            if pwd.count > 20{
                textField.text = String(pwd.prefix(20))
            }
            
            valid = false
        }
        
        lbl_error_of_newPwd.text = errorMsg
        if !pwd.isEmpty{
            lbl_error_of_newPwd.isHidden = valid ? true : false
        }else{
            lbl_error_of_newPwd.isHidden = true
        }
        btn_confirm.isEnabled = valid
        btn_confirm.backgroundColor = valid ? ColorUtils.orange_brand_900() :ColorUtils.gray_300()
        
    }
    
    
    @objc private func confirmPWDTextFieldEditing(_ textField: UITextField) {
        let confirmedPwd = textField.text ?? ""
        let pwd = text_field_password.text ?? ""
        var valid:Bool = true
        var errorMsg = ""
        
        if confirmedPwd.count >= 6 && confirmedPwd.count <= 20{
            if !textContainsAtLeastThreeCharacter(confirmedPwd){
                errorMsg = "* Mật khẩu nhập lại từ 6 đến 20 ký tự!, có ít 3 kí tự chữ cái"
                valid = false
            }else{
                if !pwd.isEmpty && confirmedPwd != text_field_password.text{
                    valid = false
                    errorMsg = "* Mật khẩu không trùng khớp!"
                }else{
                    errorMsg = ""
                    valid = true
                    lbl_error_of_newPwd.text = ""
                }
            }
              
        }else{
            errorMsg = "* Mật khẩu xác thực lại từ 6 đến 20 ký tự!"
            valid = false
        }
        
        
        lbl_error_of_confirm_pwd.text = errorMsg
        if !confirmedPwd.isEmpty{
            lbl_error_of_confirm_pwd.isHidden = valid ? true : false
        }else{
            lbl_error_of_confirm_pwd.isHidden = true
        }
        
        btn_confirm.isEnabled = valid
        btn_confirm.backgroundColor = valid ? ColorUtils.orange_brand_900() :ColorUtils.gray_300()
        
    }
    
    
    
    
    private func textContainsAtLeastThreeCharacter(_ s: String) -> Bool {
        var alphabeticCount = 0
        for character in s {
            if character.isLetter {
                alphabeticCount += 1
            }
        }
        return alphabeticCount >= 3 ? true : false
    }
    
}

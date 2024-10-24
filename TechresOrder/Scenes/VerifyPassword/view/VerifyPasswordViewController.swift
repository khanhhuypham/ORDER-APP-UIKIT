//
//  VerifyPasswordViewController.swift
//  TechresOrder
//
//  Created by Kelvin on 30/01/2023.
//

import UIKit
import JonAlert
import RxSwift

class VerifyPasswordViewController: BaseViewController, UITextFieldDelegate{
    var viewModel = VerifyPasswordViewModel()
    var router = VerifyPasswordRouter()
    
    @IBOutlet weak var text_field_password: UITextField!
    
    @IBOutlet weak var lbl_new_pass: UILabel!
    @IBOutlet weak var text_field_confirm_password: UITextField!
    @IBOutlet weak var lbl_confirm_pass: UILabel!
    
    @IBOutlet weak var btnUpdatePassword: UIButton!
    
    @IBOutlet weak var btnShowPassword: UIButton!
    @IBOutlet weak var btnConfirmShowPassword: UIButton!
    
    var username = ""
    var otp_code = ""
    
    var iconPassClick = false
    var iconConfirmPassClick = false
    var isValidCheck = false
    var checkVN = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        viewModel.bind(view: self, router: router)
        text_field_password.delegate = self
        text_field_confirm_password.delegate = self
        viewModel.otp_code.accept(otp_code)
        viewModel.usernameText.accept(username)
        
        self.btnUpdatePassword.backgroundColor = ColorUtils.grayColor()
        self.btnUpdatePassword.isEnabled = false
        
        //bind value of textfield to variable of viewmodel
        _ = text_field_password.rx.text.map { $0 ?? "" }.bind(to: viewModel.new_password)
        _ = text_field_confirm_password.rx.text.map { $0 ?? "" }.bind(to: viewModel.confirm_new_password)
        
        viewModel.isValid.subscribe(onNext: { (enable) in
            self.isValidCheck = enable
        }).disposed(by: rxbag)
    
        text_field_confirm_password.addTarget(self, action: #selector(textFieldDidEndEditingAgainNewPassword(_:)), for: .editingChanged)
        text_field_password.addTarget(self, action: #selector(textFieldDidBeginEditing(_:)), for: .editingChanged)

    }

    // Hàm này được gọi khi người dùng bắt đầu tập trung vào UITextField
    @objc func textFieldDidBeginEditing(_ textField: UITextField) {
        // Xử lý các hành động khi người dùng tập trung vào TextField ở đây
        if self.text_field_password.text! == self.text_field_confirm_password.text!{
            lbl_new_pass.isHidden = true
            lbl_confirm_pass.isHidden = true
            self.checkVN = true
            
            self.btnUpdatePassword.backgroundColor = self.isValidCheck && true ? ColorUtils.orange_brand_900() : ColorUtils.grayColor()
            self.btnUpdatePassword.isEnabled =  self.isValidCheck && true ? true : false
        }else{
            self.checkVN = false
            self.btnUpdatePassword.backgroundColor = ColorUtils.grayColor()
            self.btnUpdatePassword.isEnabled = false
        }
    }
    // Hàm này được gọi khi người dùng bắt đầu tập trung vào UITextField
    @objc func textFieldDidEndEditingAgainNewPassword(_ textField: UITextField) {
        // Xử lý các hành động khi người dùng tập trung vào TextField ở đây
        if self.text_field_password.text! == self.text_field_confirm_password.text!{
            lbl_confirm_pass.isHidden = true
            self.btnUpdatePassword.backgroundColor = self.isValidCheck && true ? ColorUtils.orange_brand_900() : ColorUtils.grayColor()
            self.btnUpdatePassword.isEnabled =  self.isValidCheck && true ? true : false
        }else{
            lbl_confirm_pass.isHidden = false
            lbl_confirm_pass.text = "* Mật khẩu không khớp"
            
            self.btnUpdatePassword.backgroundColor = ColorUtils.grayColor()
            self.btnUpdatePassword.isEnabled = false
        }
    }
    
    @IBAction func actionUpdatePassword(_ sender: Any) {
        if(text_field_password.text == text_field_confirm_password.text){
            self.verifyPassword()
        }else{
            JonAlert.show(message: "Xác nhận mật khẩu không đúng", andIcon: UIImage(named: "icon-warning"), duration: 2.0)
        }
        
    }
    
    @IBAction func actionBackToLogin(_ sender: Any) {
        self.logout()
    }
    @IBAction func btnShowConfirmPass(_ sender: Any) {
        if(iconConfirmPassClick == true) {
            text_field_confirm_password.isSecureTextEntry = false
            btnConfirmShowPassword.setImage(UIImage(named: "eye"), for: .normal)
        } else {
            btnConfirmShowPassword.setImage(UIImage(named: "icon_eye_pass"), for: .normal)
            text_field_confirm_password.isSecureTextEntry = true
        }
       
        iconConfirmPassClick = !iconConfirmPassClick
    }
    
    @IBAction func btnShowPass(_ sender: Any) {
        
        if(iconPassClick == true) {
            text_field_password.isSecureTextEntry = false
            btnShowPassword.setImage(UIImage(named: "eye"), for: .normal)
        } else {
            btnShowPassword.setImage(UIImage(named: "icon_eye_pass"), for: .normal)
            text_field_password.isSecureTextEntry = true
        }
       
        iconPassClick = !iconPassClick
        
    }
}
extension VerifyPasswordViewController{
    func verifyPassword(){
        viewModel.verifyPassword().subscribe(onNext: { (response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){
                // Verify password Success.
                self.logout()
            }else{
                dLog(response.message ?? "")
                JonAlert.showError(message: response.message ?? "Có lỗi xảy ra trong quá trình kết nối tới máy chủ.", duration: 2.0)
            }
            
        }).disposed(by: rxbag)
    }
}

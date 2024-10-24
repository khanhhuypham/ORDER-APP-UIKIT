//
//  ChangePasswordViewController.swift
//  TechresOrder
//
//  Created by Kelvin on 12/02/2023.
//

import UIKit

class ChangePasswordViewController: BaseViewController {
    var viewModel = ChangePasswordViewModel()
    var router = ChangePasswordRouter()
    
    @IBOutlet weak var img_background: UIImageView!
    @IBOutlet weak var textfield_new_pass: UITextField!
    @IBOutlet weak var textfield_current_pass: UITextField!
    
    @IBOutlet weak var textfield_confirm_new_pass: UITextField!
    
    @IBOutlet weak var btnChangePassword: UIButton!
    
    @IBOutlet weak var btn_hide_password: UIButton!
    @IBOutlet weak var btn_hide_new_password: UIButton!
    @IBOutlet weak var btn_hide_confirm_password: UIButton!
    // MARK: - Variable  -
    var iconClick = true
    var iconNewPassClick = true
    var iconConfirmPassClick = true
    var isCheckSpam = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        viewModel.bind(view: self, router: router)
        //bind value of textfield to variable of viewmodel
        _ = textfield_current_pass.rx.text.map { $0 ?? "" }.bind(to: viewModel.currentPassword)
        _ = textfield_new_pass.rx.text.map { $0 ?? "" }.bind(to: viewModel.newPassword)
        _ = textfield_confirm_new_pass.rx.text.map { $0 ?? "" }.bind(to: viewModel.confirmNewPassword)
        
        
        //  subscribe result of variable isValid in LoginViewModel then handle button login is enable or not?
        _ = viewModel.isValid.subscribe({ [weak self] isValid in
            dLog(isValid)
            guard let strongSelf = self, let isValid = isValid.element else { return }
            strongSelf.btnChangePassword.isEnabled = isValid
            strongSelf.btnChangePassword.backgroundColor = isValid ? ColorUtils.orange_brand_900() :ColorUtils.buttonGrayColor()
            
        })
    }
    
    override func viewDidLayoutSubviews() {
        img_background.layer.zPosition = 0
    }
    
    @IBAction func actionShowPassword(_ sender: Any) {
        textfield_current_pass.becomeFirstResponder()
        
        if(iconClick == true) {
            textfield_current_pass.isSecureTextEntry = false
            btn_hide_password.setImage(UIImage(named: "eye"), for: .normal)
        } else {
            btn_hide_password.setImage(UIImage(named: "icon_eye_pass"), for: .normal)
            textfield_current_pass.isSecureTextEntry = true
        }
       
        iconClick = !iconClick
    }
    
    @IBAction func actionShowNewPassword(_ sender: Any) {
        textfield_new_pass.becomeFirstResponder()
        
        if(iconNewPassClick == true) {
            textfield_new_pass.isSecureTextEntry = false
            btn_hide_new_password.setImage(UIImage(named: "eye"), for: .normal)
        } else {
            btn_hide_new_password.setImage(UIImage(named: "icon_eye_pass"), for: .normal)
            textfield_new_pass.isSecureTextEntry = true
        }
       
        iconNewPassClick = !iconNewPassClick
    }
    
    @IBAction func actionShowConfirmPassword(_ sender: Any) {
        textfield_confirm_new_pass.becomeFirstResponder()
        
        if(iconConfirmPassClick == true) {
            textfield_confirm_new_pass.isSecureTextEntry = false
            btn_hide_confirm_password.setImage(UIImage(named: "eye"), for: .normal)
        } else {
            btn_hide_confirm_password.setImage(UIImage(named: "icon_eye_pass"), for: .normal)
            textfield_confirm_new_pass.isSecureTextEntry = true
        }
       
        iconConfirmPassClick = !iconConfirmPassClick
    }
    
    
    @IBAction func actionChangePassword(_ sender: Any) {
        if(self.isCheckSpam == false){
            changePassword()
            self.isCheckSpam = true
        }
        
    }
    
    @IBAction func actionBack(_ sender: Any) {
        viewModel.makePopViewController()
    }
    

}

//
//  DialogRequiredSetPasswordViewController.swift
//  TECHRES-ORDER
//
//  Created by Nguyen Van Hien on 24/4/24.
//

import UIKit
import RxSwift
import RxCocoa
import JonAlert
class DialogRequiredSetPasswordViewController: BaseViewController, UITextFieldDelegate {

    @IBOutlet weak var text_field_password: UITextField!
    @IBOutlet weak var lbl_error_of_newPwd: UILabel!
    
    @IBOutlet weak var text_field_confirm_password: UITextField!
    @IBOutlet weak var lbl_error_of_confirm_pwd: UILabel!
    
    
    @IBOutlet weak var root_view: UIView!
    @IBOutlet weak var btn_confirm: UIButton!
    
    var oldPassword = ""


    override func viewDidLoad() {
        super.viewDidLoad()
        firstSetup()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillChangeFrameNotification , object:nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification , object:nil)

    }
    
    override func viewDidDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func keyboardWillShow(notification: NSNotification ) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue{
            if text_field_password.isFirstResponder || text_field_confirm_password.isFirstResponder{
                root_view.transform = CGAffineTransform(translationX: 0, y: -keyboardSize.height/2.1)
            }
        }
    }
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        if text_field_password.isFirstResponder || text_field_confirm_password.isFirstResponder{
            root_view.transform = .identity
        }
    }
    
    @IBAction func actionDismiss(_ sender: Any) {
        dismiss(animated: true, completion: {
            self.clearCache()
        })
    }
    
    
    
    func togglePasswordVisibility(_ textField: UITextField, button: UIButton){
        textField.isSecureTextEntry.toggle()
        button.setImage(UIImage(named: textField.isSecureTextEntry ? "icon_eye_pass" : "eye"), for: .normal)
    }
    
    @IBAction func togglePasswordVisibility(_ sender: UIButton) {
        togglePasswordVisibility(text_field_password, button: sender)
    }
    
    @IBAction func toggleConfirmPasswordVisibility(_ sender: UIButton) {
        togglePasswordVisibility(text_field_confirm_password, button: sender)
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        self.dismiss(animated: true,completion: {
            self.clearCache()
        })
    }
    
    @IBAction func confirmAction(_ sender: Any) {
        if self.text_field_password.text != self.oldPassword{
            self.changePassword(oldPwd: oldPassword, newPwd: text_field_password.text ?? "")
        }else{
            JonAlert.showError(message: "Mật khẩu mới không được trừng với mật khẩu cũ!")
        }
    }
    
    
}
extension DialogRequiredSetPasswordViewController{
    func changePassword(oldPwd:String,newPwd:String){
        appServiceProvider.rx.request(.changePassword(
                employee_id: ManageCacheObject.getCurrentUser().id,
                old_password: oldPwd,
                new_password: newPwd,
                node_access_token: ManageCacheObject.getCurrentUser().jwt_token
        ))
        .filterSuccessfulStatusCodes()
        .mapJSON().asObservable()
        .showAPIErrorToast()
        .mapObject(type: APIResponse.self).subscribe(onNext: { (response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){
                self.dismiss(animated: true,completion: {
                    var account = ManageCacheObject.getCurrentUser()
                    //new password
                    account.password = self.text_field_password.text ?? ""
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "changedPassword"), object: account)
                    JonAlert.showSuccess(message: "Thay đổi mật khẩu thành công!", duration: 2)
                })
               
            }else{
                JonAlert.showError(message: response.message ?? "Thay đổi mật khẩu thất bại!", duration: 2)
            }
         
        }).disposed(by: rxbag)
    }
}


//
//  VerifyPasswordViewModel.swift
//  TechresOrder
//
//  Created by Kelvin on 24/02/2023.
//

import UIKit
import RxRelay
import RxSwift

class VerifyPasswordViewModel: BaseViewModel {
    private(set) weak var view: VerifyPasswordViewController?
    private var router: VerifyPasswordRouter?
    
   // Khai báo biến để hứng dữ liệu từ VC
    var usernameText = BehaviorRelay<String>(value: "")
    var otp_code = BehaviorRelay<String>(value: "")
    var new_password = BehaviorRelay<String>(value: "")
    var confirm_new_password = BehaviorRelay<String>(value: "")
           
   // Khai báo viến Bool để lắng nghe sự kiện và trả về kết quả thoả mãn điều kiện
   var isValidConfirmPassword: Observable<Bool> {
       return self.confirm_new_password.asObservable().map { confirm_new_password in
           confirm_new_password.count >= Constants.LOGIN_FORM_REQUIRED.requiredPasswordLengthMin &&
           confirm_new_password.count <= Constants.LOGIN_FORM_REQUIRED.requiredPasswordLengthMax
       }
   }
    

    var isValidPassword: Observable<Bool> {
        return self.new_password.asObservable().map { new_password in
            if(new_password.count == 0){
                self.view?.lbl_new_pass.isHidden = true
                return true
            }else if new_password.count < 4 || new_password.count > 20{
                self.view?.lbl_new_pass.isHidden = false
                return false
            }else{
                self.view?.lbl_new_pass.isHidden = true
                return new_password.count >= Constants.UPDATE_INFO_FORM_REQUIRED.requiredPasswordMin && new_password.count <= Constants.UPDATE_INFO_FORM_REQUIRED.requiredPasswordMax
            }
        }
    }
   // Khai báo biến để lắng nghe kết quả của cả 3 sự kiện trên
   var isValid: Observable<Bool> {
       return Observable.combineLatest(isValidPassword,  isValidConfirmPassword) {$0 && $1}
   }
    
   
    
    func bind(view: VerifyPasswordViewController, router: VerifyPasswordRouter){
        self.view = view
        self.router = router
        self.router?.setSourceView(self.view)
    }
    
    func makePopViewController(){
        router?.navigateToPopViewController()
    }
    
   
}
extension VerifyPasswordViewModel{
    func verifyPassword() -> Observable<APIResponse> {
        return appServiceProvider.rx.request(.verifyPassword(username: usernameText.value, verify_code: otp_code.value, new_password: new_password.value))
               .filterSuccessfulStatusCodes()
               .mapJSON().asObservable()
               .showAPIErrorToast()
               .mapObject(type: APIResponse.self)
       }
}

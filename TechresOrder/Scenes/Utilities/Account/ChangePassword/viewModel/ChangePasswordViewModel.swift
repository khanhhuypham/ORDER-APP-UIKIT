//
//  ChangePasswordViewModel.swift
//  TechresOrder
//
//  Created by Kelvin on 12/02/2023.
//

import UIKit
import RxSwift
import RxRelay

class ChangePasswordViewModel: BaseViewModel {
    private(set) weak var view: ChangePasswordViewController?
    private var router: ChangePasswordRouter?
    
    // Khai báo biến để hứng dữ liệu từ VC
     var currentPassword = BehaviorRelay<String>(value: "")
     var newPassword = BehaviorRelay<String>(value: "")
     var confirmNewPassword = BehaviorRelay<String>(value: "")
    
    // Khai báo biến Bool để lắng nghe sự kiện và trả về kết quả thoả mãn điều kiện
    var isValidCurrentPassword: Observable<Bool> {
        dLog(currentPassword)
        return self.currentPassword.asObservable().map { currentPassword in
            currentPassword.count <= Constants.UPDATE_INFO_FORM_REQUIRED.requiredPasswordMax && currentPassword.count >= Constants.UPDATE_INFO_FORM_REQUIRED.requiredPasswordMin
        }
    }
    
    var isValidNewPassword: Observable<Bool> {
        dLog(newPassword)
        return self.newPassword.asObservable().map { [self] newPassword in
            newPassword.count <= Constants.UPDATE_INFO_FORM_REQUIRED.requiredPasswordMax
            && newPassword.count >= Constants.UPDATE_INFO_FORM_REQUIRED.requiredPasswordMin
        }
    }
    
    var isValidConfirmNewPassword: Observable<Bool> {
        dLog(newPassword)
        return self.confirmNewPassword.asObservable().map { [self] confirmNewPassword in
            confirmNewPassword.count <= Constants.UPDATE_INFO_FORM_REQUIRED.requiredPasswordMax && confirmNewPassword.count >= Constants.UPDATE_INFO_FORM_REQUIRED.requiredPasswordMin &&
            confirmNewPassword == newPassword.value
        }
    }
    
    // Khai báo biến để lắng nghe kết quả của cả 3 sự kiện trên
    
    var isValid: Observable<Bool> {
        return Observable.combineLatest(isValidCurrentPassword, isValidNewPassword, isValidConfirmNewPassword) {$0 && $1 && $2}
    }
  
    
    func bind(view: ChangePasswordViewController, router: ChangePasswordRouter){
        self.view = view
        self.router = router
        self.router?.setSourceView(self.view)
    }
    
    func makePopViewController(){
        router?.navigateToPopViewController()
    }
    
}
extension ChangePasswordViewModel{
    func changePassword() -> Observable<APIResponse> {
        return appServiceProvider.rx.request(.changePassword(employee_id: ManageCacheObject.getCurrentUser().id, old_password:currentPassword.value, new_password:newPassword.value, node_access_token:ManageCacheObject.getCurrentUser().jwt_token))
               .filterSuccessfulStatusCodes()
               .mapJSON().asObservable()
               .showAPIErrorToast()
               .mapObject(type: APIResponse.self)
       }
}

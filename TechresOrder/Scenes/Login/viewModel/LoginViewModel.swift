//
//  LoginViewModel.swift
//  TechresOrder
//
//  Created by macmini_techres_03 on 12/01/2023.
//

import UIKit
import RxSwift
import RxRelay
import RxCocoa
class LoginViewModel : BaseViewModel{

    private(set) weak var view: LoginViewController?
    private var router: LoginRouter?

    var username = BehaviorRelay<String>(value: "")
    var password = BehaviorRelay<String>(value: "")
    var restaurantName = BehaviorRelay<String>(value: "")
    
    var deviceRequest = BehaviorRelay<DeviceRequest>(value: DeviceRequest.init()!)
    
    var isLoginFace = BehaviorRelay<Bool>(value: false)
    public var branch_id : BehaviorRelay<Int> = BehaviorRelay(value: 0)
    
//    var newPassword = BehaviorRelay<String>(value: "")

    func bind(view: LoginViewController, router: LoginRouter){
        self.view = view
        self.router = router
        self.router?.setSourceView(self.view)
    }
    
    func makeResetPasswordViewController(){
        router?.navigateToResetPasswordViewController()
    }
}
extension LoginViewModel{
    // get data from server by rxswift with alamofire
    func getSessions() -> Observable<APIResponse> {
        return appServiceProvider.rx.request(.sessions)
               .filterSuccessfulStatusCodes()
               .mapJSON().asObservable()
               .showAPIErrorToast()
               .mapObject(type: APIResponse.self)
       }
    
    func registerDeviceUDID() -> Observable<APIResponse> {
        return appServiceProvider.rx.request(.regisDevice(deviceRequest: deviceRequest.value))
            .filterSuccessfulStatusCodes()
            .mapJSON().asObservable()
            .showAPIErrorToast()
            .mapObject(type: APIResponse.self)
       }
    
    func getConfig() -> Observable<APIResponse> {
        return appServiceProvider.rx.request(.config(restaurant_name: restaurantName.value))
               .filterSuccessfulStatusCodes()
               .mapJSON().asObservable()
               .showAPIErrorToast()
               .mapObject(type: APIResponse.self)
    }
    
    func login() -> Observable<APIResponse> {
        return appServiceProvider.rx.request(.login(username: username.value, password: password.value))
            .filterSuccessfulStatusCodes()
            .mapJSON().asObservable()
            .showAPIErrorToast()
            .mapObject(type: APIResponse.self)
    }
    
//    func changePassword() -> Observable<APIResponse>{
//        return appServiceProvider.rx.request(.changePassword(employee_id: ManageCacheObject.getCurrentUser().id, old_password: password.value, new_password: newPassword.value, node_access_token: ManageCacheObject.getCurrentUser().jwt_token))
//            .filterSuccessfulStatusCodes()
//            .mapJSON().asObservable()
//            .showAPIErrorToast()
//            .mapObject(type: APIResponse.self)
//    }
}

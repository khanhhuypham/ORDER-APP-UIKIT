//
//  VerifyOTPViewModel.swift
//  TechresOrder
//
//  Created by Kelvin on 24/02/2023.
//

import UIKit
import RxSwift
import RxRelay

class VerifyOTPViewModel: BaseViewModel {
    private(set) weak var view: VerifyOTPViewController?
    private var router: VerifyOTPRouter?
    
   // Khai báo biến để hứng dữ liệu từ VC
    var OTPCode = BehaviorRelay<String>(value: "")
    var restaurant_brand_name = BehaviorRelay<String>(value: "")
    var username = BehaviorRelay<String>(value: "")
    var sessionString = BehaviorRelay<String>(value: "")
    var timeToLockOPTEnterView = BehaviorRelay<Int>(value: 0)
           
   
    
    func bind(view: VerifyOTPViewController, router: VerifyOTPRouter){
        self.view = view
        self.router = router
        self.router?.setSourceView(self.view)
    }
    
    func makePopViewController(){
        router?.navigateToPopViewController()
    }
    func makeVerifyPasswordViewController(){
        router?.navigateToVerifyPasswordViewController(username: username.value, otp_code: OTPCode.value)
    }
    func makeLoginViewController(){
        router?.navigateToLoginViewController()
    }
    
}
extension VerifyOTPViewModel{
    func verifyOTP() -> Observable<APIResponse> {
        return appServiceProvider.rx.request(.verifyOTP(restaurant_name: restaurant_brand_name.value, username: username.value, verify_code: OTPCode.value))
            .filterSuccessfulStatusCodes()
            .mapJSON().asObservable()
            .showAPIErrorToast()
            .mapObject(type: APIResponse.self)
    }
    // get data from server by rxswift with alamofire
    func getSessions() -> Observable<APIResponse> {
        return appServiceProvider.rx.request(.sessions)
            .filterSuccessfulStatusCodes()
            .mapJSON().asObservable()
            .showAPIErrorToast()
            .mapObject(type: APIResponse.self)
    }
    func forgotPassword() -> Observable<APIResponse> {
        return appServiceProvider.rx.request(.forgotPassword(username: username.value))
            .filterSuccessfulStatusCodes()
            .mapJSON().asObservable()
            .showAPIErrorToast()
            .mapObject(type: APIResponse.self)
    }
    func getConfig() -> Observable<APIResponse> {
        
        return appServiceProvider.rx.request(.config(restaurant_name: restaurant_brand_name.value))
            .filterSuccessfulStatusCodes()
            .mapJSON().asObservable()
            .showAPIErrorToast()
            .mapObject(type: APIResponse.self)
    }
}

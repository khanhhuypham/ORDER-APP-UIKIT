//
//  ResetPasswordViewModel.swift
//  TechresOrder
//
//  Created by Kelvin on 21/02/2023.
//

import UIKit
import RxSwift
import RxRelay

class ResetPasswordViewModel: BaseViewModel {
    private(set) weak var view: ResetPasswordViewController?
    private var router: ResetPasswordRouter?
    
   // Khai báo biến để hứng dữ liệu từ VC
    var usernameText = BehaviorRelay<String>(value: "")
    var restaurantNameText = BehaviorRelay<String>(value: "")
   
           
   // Khai báo viến Bool để lắng nghe sự kiện và trả về kết quả thoả mãn điều kiện
   var isValidUsername: Observable<Bool> {
       return self.usernameText.asObservable().map { username in
           username.count >= Constants.LOGIN_FORM_REQUIRED.requiredUserIDMinLength &&
           username.count <= Constants.LOGIN_FORM_REQUIRED.requiredUserIDMaxLength
       }
   }
    

    var isValidRestaurantName: Observable<Bool> {
        return    self.restaurantNameText.asObservable().map { restaurant_name in
            restaurant_name.count >= Constants.LOGIN_FORM_REQUIRED.requiredRestaurantMinLength &&
            restaurant_name.count <= Constants.LOGIN_FORM_REQUIRED.requiredRestaurantMaxLength
        }
    }
    
   
   // Khai báo biến để lắng nghe kết quả của cả 3 sự kiện trên
   
   var isValid: Observable<Bool> {
       return Observable.combineLatest(isValidUsername,  isValidRestaurantName) {$0 && $1}
     
//       return Observable.combineLatest(isValidUsername, isValidPassword) {$0 && $1}

   }
    
   
    
    func bind(view: ResetPasswordViewController, router: ResetPasswordRouter){
        self.view = view
        self.router = router
        self.router?.setSourceView(self.view)
    }
    
    func makePopViewController(){
        router?.navigateToPopViewController()
    }
    
    func makeNavigatorVerifyOTPViewController(){
        router?.navigateToPopViewController(username: usernameText.value, restaurant_name_identify: restaurantNameText.value)
    }
    
    
}
extension ResetPasswordViewModel{
    
    // get data from server by rxswift with alamofire
    func getSessions() -> Observable<APIResponse> {
        return appServiceProvider.rx.request(.sessions)
               .filterSuccessfulStatusCodes()
               .mapJSON().asObservable()
               .showAPIErrorToast()
               .mapObject(type: APIResponse.self)
       }
    
    func getConfig() -> Observable<APIResponse> {
        
        return appServiceProvider.rx.request(.config(restaurant_name: restaurantNameText.value))
               .filterSuccessfulStatusCodes()
               .mapJSON().asObservable()
               .showAPIErrorToast()
               .mapObject(type: APIResponse.self)
       }
    
    func forgotPassword() -> Observable<APIResponse> {
        return appServiceProvider.rx.request(.forgotPassword(username: usernameText.value))
               .filterSuccessfulStatusCodes()
               .mapJSON().asObservable()
               .showAPIErrorToast()
               .mapObject(type: APIResponse.self)
       }
    
}

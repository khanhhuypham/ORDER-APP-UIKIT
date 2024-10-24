//
//  FeedbackDeveloperViewModel.swift
//  TechresOrder
//
//  Created by Kelvin on 12/02/2023.
//

import UIKit
import RxSwift
import RxRelay
class FeedbackDeveloperViewModel: BaseViewModel {
    private(set) weak var view: FeedbackDeveloperViewController?
    private var router: FeedbackDeveloperRouter?
    
    
    // Khai báo biến để hứng dữ liệu từ VC
     var emailText = BehaviorRelay<String>(value: "")
     var descriptionText = BehaviorRelay<String>(value: "")
    var name = BehaviorRelay<String>(value: "")
    var phone = BehaviorRelay<String>(value: "")
    var type = BehaviorRelay<Int>(value: 0)
    
    // Khai báo viến Bool để lắng nghe sự kiện và trả về kết quả thoả mãn điều kiện
    //a Tuan
//    var isValidEmail: Observable<Bool> {
//        return self.emailText.asObservable().map { email in
//            email.count >= 3 &&
//            email.count <= 30
//        }
//    }
//
//
//
//    //a Tuan
//    var isValidDescription: Observable<Bool> {
//        return self.descriptionText.asObservable().map {
//            description in
//            description.count >= 3
//            &&  description.count <= 255
//        }
//    }
     
    //hien
    var isValidEmail: Observable<Bool> {
        return self.emailText.asObservable().map { email in

            email.count >= Constants.UPDATE_INFO_FORM_REQUIRED.requireEmailLengthMin &&
            email.count <= Constants.UPDATE_INFO_FORM_REQUIRED.requireEmailLength
        }
    }
    //hien
    var isValidDescription: Observable<Bool> {
        return self.descriptionText.asObservable().map {
            description in
            description.count >= Constants.UPDATE_INFO_FORM_REQUIRED.requireDescriptionMin
            &&  description.count <= Constants.UPDATE_INFO_FORM_REQUIRED.requireDescriptionMax
        }
    }
    
    // Khai báo biến để lắng nghe kết quả của cả 3 sự kiện trên
    
    var isValid: Observable<Bool> {
        return Observable.combineLatest(isValidEmail, isValidDescription) {$0 && $1}
    }
     
    
     
    func bind(view: FeedbackDeveloperViewController, router: FeedbackDeveloperRouter){
        self.view = view
        self.router = router
        self.router?.setSourceView(self.view)
    }
    
    func makePopViewController(){
        router?.navigateToPopViewController()
    }
    
}
extension FeedbackDeveloperViewModel{
    func feedbackDeveloper() -> Observable<APIResponse> {
        return appServiceProvider.rx.request(.feedbackDeveloper(email: emailText.value, name:name.value, phone:phone.value, type: type.value, describe: descriptionText.value))
               .filterSuccessfulStatusCodes()
               .mapJSON().asObservable()
               .showAPIErrorToast()
               .mapObject(type: APIResponse.self)
       }
}

//
//  UpdateProfileViewModel.swift
//  TechresOrder
//
//  Created by Kelvin on 04/02/2023.
//

import UIKit
import RxSwift
import RxRelay

class UpdateProfileViewModel: BaseViewModel {
    
    private(set) weak var view: UpdateProfileViewController?
    private var router: UpdateProfileRouter?
    
    var profile = BehaviorRelay<Account>(value: Account())

    var branch_id = BehaviorRelay<Int>(value: 0)
    var employee_id = BehaviorRelay<Int>(value: 0)


    var avatar = BehaviorRelay<String>(value: "")
    

    var selectedArea = BehaviorRelay<[String:Area]>(value:[String:Area]())
        
    
    

    
    func bind(view: UpdateProfileViewController, router: UpdateProfileRouter){
        self.view = view
        self.router = router
        self.router?.setSourceView(self.view)
    }
    
    func makePopViewController(){
        router?.navigateToPopViewController()
    }
}
// MARK: -- CALL API HERE...
extension UpdateProfileViewModel{
    func getProfile() -> Observable<APIResponse> {
        return appServiceProvider.rx.request(.profile(branch_id: branch_id.value, employee_id: employee_id.value))
               .filterSuccessfulStatusCodes()
               .mapJSON().asObservable()
               .showAPIErrorToast()
               .mapObject(type: APIResponse.self)
       }
        
    func updateProfile() -> Observable<APIResponse> {
        var profileRequest = ProfileRequest()
        profileRequest.avatar = avatar.value
        profileRequest.id = ManageCacheObject.getCurrentUser().id
        profileRequest.name = profile.value.name
        profileRequest.phone_number = profile.value.phone_number
        profileRequest.email = profile.value.email
        profileRequest.birthday = profile.value.birthday
        profileRequest.address = profile.value.address
        profileRequest.gender = profile.value.gender.rawValue// new
        profileRequest.city_id = profile.value.city_id
        profileRequest.district_id = profile.value.district_id
        profileRequest.ward_id = profile.value.ward_id
        

        return appServiceProvider.rx.request(.updateProfile(profileRequest: profileRequest))
               .filterSuccessfulStatusCodes()
               .mapJSON().asObservable()
               .showAPIErrorToast()
               .mapObject(type: APIResponse.self)
       }
    

}

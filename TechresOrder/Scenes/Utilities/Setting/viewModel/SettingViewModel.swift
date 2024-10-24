//
//  SettingViewModel.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 29/12/2023.
//

import UIKit
import RxSwift
class SettingViewModel: BaseViewModel {
    private(set) weak var view: SettingViewController?
    private var router:SettingRouter?


    func bind(view: SettingViewController, router: SettingRouter){
        self.view = view
        self.router = router
        self.router?.setSourceView(self.view)
    }
    
    
    func makePopViewController(){
        router?.navigateToPopViewController()
    }
    
    
    func makeBankAccountSettingViewController(){
        router?.navigateToBankAccountSettingViewController()
    }
  
}


extension SettingViewModel {
    func applyOnlyCashAmount() -> Observable<APIResponse> {
        return appServiceProvider.rx.request(.postApplyOnlyCashAmount(branchId: Constants.branch.id))
               .filterSuccessfulStatusCodes()
               .mapJSON().asObservable()
               .showAPIErrorToast()
               .mapObject(type: APIResponse.self)
    }
    
    
    func getCashAmountApplication() -> Observable<APIResponse> {
        return appServiceProvider.rx.request(.getApplyOnlyCashAmount(branchId: Constants.branch.id))
               .filterSuccessfulStatusCodes()
               .mapJSON().asObservable()
               .showAPIErrorToast()
               .mapObject(type: APIResponse.self)
    }
    
    func applyTakeAwayTable() -> Observable<APIResponse> {
        return appServiceProvider.rx.request(.postApplyTakeAwayTable(branch_id: Constants.branch.id))
               .filterSuccessfulStatusCodes()
               .mapJSON().asObservable()
               .showAPIErrorToast()
               .mapObject(type: APIResponse.self)
    }
    
    
}


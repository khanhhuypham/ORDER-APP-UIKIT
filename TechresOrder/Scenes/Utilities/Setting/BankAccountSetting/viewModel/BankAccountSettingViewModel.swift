//
//  BankAccountSettingViewModel.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 16/04/2024.
//

import UIKit
import RxSwift
import RxRelay
class BankAccountSettingViewModel: NSObject {
    private(set) weak var view: BankAccountSettingViewController?
    private var router:BankAccountSettingRouter?
    
    public var bankAccounts = BehaviorRelay<[BankAccount]> (value: [])
    
    func bind(view: BankAccountSettingViewController, router: BankAccountSettingRouter){
        self.view = view
        self.router = router
        self.router?.setSourceView(self.view)
    }
    
    
    func makePopViewController(){
        router?.navigateToPopViewController()
    }
}

extension BankAccountSettingViewModel {
    func getBankAccount() -> Observable<APIResponse> {
        return appServiceProvider.rx.request(.getBankAccount(brand_id: Constants.brand.id, type: -1, status: ACTIVE))
               .filterSuccessfulStatusCodes()
               .mapJSON().asObservable()
               .showAPIErrorToast()
               .mapObject(type: APIResponse.self)
    }
    

}


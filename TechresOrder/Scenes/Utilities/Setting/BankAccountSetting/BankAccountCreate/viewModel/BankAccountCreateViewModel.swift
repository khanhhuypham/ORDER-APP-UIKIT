//
//  BankAccountCreateViewModel.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 16/04/2024.
//

import UIKit
import RxSwift
import RxRelay
class BankAccountCreateViewModel: NSObject {
    private(set) weak var view: BankAccountCreateViewController?

    
    public var bankAccount = BehaviorRelay<BankAccount>(value: BankAccount())
    
    public var bankList = BehaviorRelay<[Bank]>(value: [])
    
    func bind(view: BankAccountCreateViewController){
        self.view = view
    }
    
    func getBankList() -> Observable<APIResponse> {
        return appServiceProvider.rx.request(.getBankList)
               .filterSuccessfulStatusCodes()
               .mapJSON().asObservable()
               .showAPIErrorToast()
               .mapObject(type: APIResponse.self)
    }
    
    
    func updateBankAccount(bankAccount:BankAccount) -> Observable<APIResponse> {
        return appServiceProvider.rx.request(.postUpdateteBrandBankAccount(brand_id: Constants.brand.id, bankAccount: bankAccount))
               .filterSuccessfulStatusCodes()
               .mapJSON().asObservable()
               .showAPIErrorToast()
               .mapObject(type: APIResponse.self)
    }
    
    func createBankAccount(bankAccount:BankAccount) -> Observable<APIResponse> {
        return appServiceProvider.rx.request(.postCreateBrandBankAccount(brand_id: Constants.brand.id, bankAccount: bankAccount))
               .filterSuccessfulStatusCodes()
               .mapJSON().asObservable()
               .showAPIErrorToast()
               .mapObject(type: APIResponse.self)
    }
    

    
}

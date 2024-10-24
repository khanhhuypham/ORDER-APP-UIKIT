//
//  BrandViewModel.swift
//  TechresOrder
//
//  Created by macmini_techres_03 on 16/01/2023.
//

import UIKit
import RxSwift
import RxRelay

class BrandViewModel: BaseViewModel {
    private(set) weak var view: BrandViewController?
   
    public var key_word : BehaviorRelay<String> = BehaviorRelay(value: "")
    public var status : BehaviorRelay<Int> = BehaviorRelay(value: -1)
    
    // MARK: - Variable -
    // listing data array observe by rxswift
    public var dataArray : BehaviorRelay<[Brand]> = BehaviorRelay(value: [])
    
    
    func bind(view: BrandViewController){
        self.view = view
    }
    
}
extension BrandViewModel{
    func getBrands() -> Observable<APIResponse> {
        return appServiceProvider.rx.request(.brands(key_search: key_word.value, status: status.value))
               .filterSuccessfulStatusCodes()
               .mapJSON().asObservable()
               .showAPIErrorToast()
               .mapObject(type: APIResponse.self)
       }
    
    
}

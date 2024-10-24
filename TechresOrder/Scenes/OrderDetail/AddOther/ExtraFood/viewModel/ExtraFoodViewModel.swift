//
//  ExtraFoodViewModel.swift
//  TechresOrder
//
//  Created by Kelvin on 21/01/2023.
//

import UIKit
import RxSwift
import RxRelay

class ExtraFoodViewModel: BaseViewModel {
   
    private(set) weak var view: ExtraFoodViewController?
    public var order_id : BehaviorRelay<Int> = BehaviorRelay(value: 0)
    var charge = BehaviorRelay<ExtraCharge>(value: ExtraCharge.init())
    
    func bind(view: ExtraFoodViewController){
        self.view = view
    }
}
// MARK: -- CALL API GET DATA FROM SERVER
extension ExtraFoodViewModel{
    func getExtraCharges() -> Observable<APIResponse> {
        return appServiceProvider.rx.request(.extra_charges(
            restaurant_brand_id:Constants.brand.id,
            branch_id:Constants.branch.id,
            status: ACTIVE))
               .filterSuccessfulStatusCodes()
               .mapJSON().asObservable()
               .showAPIErrorToast()
               .mapObject(type: APIResponse.self)
       }
    
    func addExtraCharge() -> Observable<APIResponse> {
        
        return appServiceProvider.rx.request(.addExtraCharge(
            branch_id:Constants.branch.id,
            order_id:view?.order_id ?? 0,
            extra_charge_id:charge.value.id,
            name:charge.value.name,
            price:Int(charge.value.price),
            quantity:charge.value.quantity,
            note:charge.value.description))
               .filterSuccessfulStatusCodes()
               .mapJSON().asObservable()
               .showAPIErrorToast()
               .mapObject(type: APIResponse.self)
       }
    
    
}

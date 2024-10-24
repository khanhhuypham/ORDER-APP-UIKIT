//
//  UpdateFeedViewModel.swift
//  ORDER
//
//  Created by Macbook Pro M1 Techres - BE65F182D41C on 16/06/2023.
//

import UIKit
import RxSwift
import RxRelay
class UpdateMaterialFeeViewModel: BaseViewModel{

    private(set) weak var view: UpdateMaterialFeeViewController?
    private var router: UpdateMaterialFeeRouter?
    var materialFeeId = BehaviorRelay<Int>(value: 0)
    var dateTime = BehaviorRelay<String>(value: "")
    var amount = BehaviorRelay<Int>(value: 0)
    var note = BehaviorRelay<String>(value: "")
    public var branch_id : BehaviorRelay<Int> = BehaviorRelay(value: 0)
    var type = BehaviorRelay<Int>(value: 0)
    var object_type = BehaviorRelay<Int>(value: 0)
    var is_count_to_revenue = BehaviorRelay<Int>(value: 0)
    var object_name = BehaviorRelay<String>(value: "")
    var payment_method_id = BehaviorRelay<Int>(value: 0)
    var addition_fee_status = BehaviorRelay<Int>(value: 0)
    var addition_fee_reason_type_id = BehaviorRelay<Int>(value: 0)
    var cancel_reason = BehaviorRelay<String>(value: "")
    
    func bind(view: UpdateMaterialFeeViewController, router: UpdateMaterialFeeRouter){
        self.view = view
        self.router = router
        self.router?.setSourceView(self.view)
    }
    
    func makePopViewController(){
        router?.navigateToPopViewController()
    }
}




extension UpdateMaterialFeeViewModel{
    func getMaterialFee() -> Observable<APIResponse> {
        return appServiceProvider.rx.request(.getAdditionFee(id: materialFeeId.value))
               .filterSuccessfulStatusCodes()
               .mapJSON().asObservable()
               .showAPIErrorToast()
               .mapObject(type: APIResponse.self)
    }
    func cancelMaterialFee() -> Observable<APIResponse> {
        return appServiceProvider.rx.request(.cancelAdditionFee(id: materialFeeId.value, cancel_reason: cancel_reason.value, branch_id: branch_id.value, addition_fee_status: addition_fee_status.value))
               .filterSuccessfulStatusCodes()
               .mapJSON().asObservable()
               .showAPIErrorToast()
               .mapObject(type: APIResponse.self)
    }
    
    func updateMaterialFee() -> Observable<APIResponse> {
        return appServiceProvider.rx.request(.updateAdditionFee(id: materialFeeId.value, date: dateTime.value, note: note.value, amount: amount.value, is_count_to_revenue: is_count_to_revenue.value, object_type: object_type.value, type: type.value, payment_method_id: payment_method_id.value, cancel_reason: cancel_reason.value, branch_id: branch_id.value, object_name: object_name.value, addition_fee_status: addition_fee_status.value, addition_fee_reason_type_id: addition_fee_reason_type_id.value))
               .filterSuccessfulStatusCodes()
               .mapJSON().asObservable()
               .showAPIErrorToast()
               .mapObject(type: APIResponse.self)
       }
}

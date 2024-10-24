//
//  UpdateOtherFeedViewModel.swift
//  ORDER
//
//  Created by Macbook Pro M1 Techres - BE65F182D41C on 17/06/2023.
//

import UIKit
import RxSwift
import RxRelay

class UpdateOtherFeedViewModel: BaseViewModel {
    private(set) weak var view: UpdateOtherFeedViewController?
    private var router: UpdateOtherFeedRouter?
    var amount = BehaviorRelay<Int>(value: 0)
    var dateText = BehaviorRelay<String>(value: "")
    var note = BehaviorRelay<String>(value: "")
    public var id : BehaviorRelay<Int> = BehaviorRelay(value: 0)
    public var branch_id : BehaviorRelay<Int> = BehaviorRelay(value: 0)
    public var brand_id : BehaviorRelay<Int> = BehaviorRelay(value: 0)
    public var status : BehaviorRelay<Int> = BehaviorRelay(value: 1)
    public var dataArray : BehaviorRelay<[UpdateOtherFeedList]> = BehaviorRelay(value: [])
    var other_fees = BehaviorRelay<[Fee]>(value: [])
    var is_count_to_revenue = BehaviorRelay<Int>(value: 0)
    var object_name = BehaviorRelay<String>(value: "")
    var payment_method_id = BehaviorRelay<Int>(value: 0)
    var addition_fee_status = BehaviorRelay<Int>(value: 0)
    var addition_fee_reason_type_id = BehaviorRelay<Int>(value: 0)
    var cancel_reason = BehaviorRelay<String>(value: "")
    
    func bind(view: UpdateOtherFeedViewController, router: UpdateOtherFeedRouter){
        self.view = view
        self.router = router
        self.router?.setSourceView(self.view)
    }
    
    func makePopViewController(){
        router?.navigateToPopViewController()
    }
}

extension UpdateOtherFeedViewModel{
    func getUpdateOtherFeed() -> Observable<APIResponse> {
        return appServiceProvider.rx.request(.updateOtherFeed(id: id.value, branch_id: branch_id.value, brand_id: brand_id.value, status: status.value))
               .filterSuccessfulStatusCodes()
               .mapJSON().asObservable()
               .showAPIErrorToast()
               .mapObject(type: APIResponse.self)
       }
    func cancelOtherFee() -> Observable<APIResponse> {
        return appServiceProvider.rx.request(.cancelAdditionFee(id: id.value, cancel_reason: cancel_reason.value, branch_id: branch_id.value, addition_fee_status: addition_fee_status.value))
               .filterSuccessfulStatusCodes()
               .mapJSON().asObservable()
               .showAPIErrorToast()
               .mapObject(type: APIResponse.self)
    }
    func updateOtherlFee() -> Observable<APIResponse> {
        return appServiceProvider.rx.request(.updateOtherFee(id: id.value, date: dateText.value, note: note.value, amount: amount.value, is_count_to_revenue: is_count_to_revenue.value, payment_method_id: payment_method_id.value, branch_id: branch_id.value, object_name: object_name.value,addition_fee_status: addition_fee_status.value, addition_fee_reason_type_id: addition_fee_reason_type_id.value))
               .filterSuccessfulStatusCodes()
               .mapJSON().asObservable()
               .showAPIErrorToast()
               .mapObject(type: APIResponse.self)
       }
}

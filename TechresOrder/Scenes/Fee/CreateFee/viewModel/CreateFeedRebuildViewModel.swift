//
//  CreateFeedRebuildViewModel.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 02/02/2024.
//

import UIKit
import RxSwift
import RxRelay

class CreateFeedRebuildViewModel: BaseViewModel {
    private(set) weak var view: CreateFeedRebuildViewController?
    private var router: CreateFeedRebuildRouter?
    
    
    
    var array = BehaviorRelay<[Fee]>(value: [])

    var fee = BehaviorRelay<Fee>(value: Fee())

    func bind(view: CreateFeedRebuildViewController, router: CreateFeedRebuildRouter){
        self.view = view
        self.router = router
        self.router?.setSourceView(self.view)
    }
    
    func makePopViewController(){
        router?.navigateToPopViewController()
    }
}

// CALL API HERE...
extension CreateFeedRebuildViewModel{
    func createFee() -> Observable<APIResponse> {
        return appServiceProvider.rx.request(.createFee(
            branch_id: ManageCacheObject.getCurrentBranch().id,
            type: 1,
            amount: Int(fee.value.amount),
            title: fee.value.object_name,
            note: fee.value.note,
            date: fee.value.date,
            addition_fee_reason_type_id:fee.value.addition_fee_reason_type_id
        ))
               .filterSuccessfulStatusCodes()
               .mapJSON().asObservable()
               .showAPIErrorToast()
               .mapObject(type: APIResponse.self)
       }
}

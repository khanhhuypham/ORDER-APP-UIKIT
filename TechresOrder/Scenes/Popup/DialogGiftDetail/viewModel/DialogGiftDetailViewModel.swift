//
//  DialogGiftDetailViewModel.swift
//  TechresOrder
//
//  Created by Kelvin on 09/03/2023.
//

import UIKit
import RxSwift
import RxRelay

class DialogGiftDetailViewModel: BaseViewModel {
    private(set) weak var view: DialogGiftDetailViewController?
    private var router: DialogGiftDetailRouter?
    
    var branch_id = BehaviorRelay<Int>(value: 0)
    var order_id = BehaviorRelay<Int>(value: 0)
    var customer_gift_id = BehaviorRelay<Int>(value: 0)
    var customer_id = BehaviorRelay<Int>(value: 0)
    var qr_code_gift = BehaviorRelay<String>(value: "")
    
    
    func bind(view: DialogGiftDetailViewController, router: DialogGiftDetailRouter){
        self.view = view
        self.router = router
        self.router?.setSourceView(self.view)
    }
    
    func makePopViewController(){
        router?.navigateToPopViewController()
    }
}
extension DialogGiftDetailViewModel{
    func getGift() -> Observable<APIResponse> {
        return appServiceProvider.rx.request(.gift(qr_code_gift: qr_code_gift.value, branch_id: branch_id.value))
               .filterSuccessfulStatusCodes()
               .mapJSON().asObservable()
               .showAPIErrorToast()
               .mapObject(type: APIResponse.self)
       }
    func useGift() -> Observable<APIResponse> {
        return appServiceProvider.rx.request(.useGift(branch_id: branch_id.value, order_id:order_id.value, customer_gift_id:customer_gift_id.value, customer_id:customer_id.value))
               .filterSuccessfulStatusCodes()
               .mapJSON().asObservable()
               .showAPIErrorToast()
               .mapObject(type: APIResponse.self)
       }
    
}

//
//  AppFoodViewModel.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 29/07/2024.
//

import UIKit
import RxSwift
import RxRelay

class AssignAppFoodViewModel: BaseViewModel {
    private(set) weak var view: AssignAppFoodViewController?
    private var router: AssignAppFoodRouter?
    
    public var partners : BehaviorRelay<[FoodAppAPartner]> = BehaviorRelay(value: [])
    
    func bind(view: AssignAppFoodViewController, router: AssignAppFoodRouter) {
        self.view = view
        self.router = router
        self.router?.setSourceView(self.view)
    }
    
    
    func makeFoodAppLoginViewController(partner:FoodAppAPartner){
        router?.navigateToFoodAppLoginViewController(partner: partner)
    }
    
    func makePopViewController(){
        router?.navigateToPopViewController()
    }
    
    
    func getChannelFoodOrder() -> Observable<APIResponse> {
        return appServiceProvider.rx.request(.getChannelFoodOrder(restaurant_id: Constants.restaurant_id, brand_id: Constants.brand.id, channel_order_food_id: -1, is_connect: -1, key_search: ""))
            .filterSuccessfulStatusCodes()
            .mapJSON().asObservable()
            .showAPIErrorToast()
            .mapObject(type: APIResponse.self)
    }
}

//
//  TokenListOfFoodAppViewModel.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 30/09/2024.
//

import UIKit
import RxSwift
import RxRelay
class TokenListOfFoodAppViewModel: NSObject {
    private(set) weak var view: TokenListOfFoodAppViewController?
    private var router: TokenListOfFoodAppRouter?

    public var partner = BehaviorRelay<FoodAppAPartner>(value: FoodAppAPartner())
    
    
    public var credentials: BehaviorRelay<[PartnerCredential]> = BehaviorRelay(value: [])
    
    
    
    
    func bind(view: TokenListOfFoodAppViewController, router: TokenListOfFoodAppRouter) {
        self.view = view
        self.router = router
        self.router?.setSourceView(self.view)
    }
    
    
    func makeFoodAppLoginViewController(cre:PartnerCredential){
        router?.navigateToFoodAppLoginViewController(cre: cre)
    }
    
    func makePopViewController(){
        router?.navigateToPopViewController()
    }

    
    func getChannelOrderFoodInforList(){
//        return appServiceProvider.rx.request(
//            .getChannelOrderFoodInforList(
//                restaurant_id: Constants.restaurant_id,
//                brand_id: Constants.brand.id,
//                branch_ids: <#T##Int#>,
//                food_channel_id: <#T##Int#>,
//                date_string: <#T##String#>,
//                from_date: <#T##String#>,
//                to_date: <#T##String#>,
//                report_date: <#T##Int#>,
//                key_search: <#T##String#>,
//                limit: <#T##Int#>,
//                page: <#T##Int#>)
//        )
//            .filterSuccessfulStatusCodes()
//            .mapJSON().asObservable()
//            .showAPIErrorToast()
//            .mapObject(type: APIResponse.self)
    }
    
   
}

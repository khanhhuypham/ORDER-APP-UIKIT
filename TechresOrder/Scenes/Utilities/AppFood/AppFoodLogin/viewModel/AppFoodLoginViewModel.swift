//
//  AppFoodLoginViewModel.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 29/07/2024.
//

import UIKit
import RxSwift
import RxRelay

class AppFoodLoginViewModel: BaseViewModel {
    private(set) weak var view: AppFoodLoginViewController?
    private var router: AppFoodLoginRouter?
    
    public var partner: BehaviorRelay<FoodAppAPartner> = BehaviorRelay(value: FoodAppAPartner())
    
    
    public var credential: BehaviorRelay<PartnerCredential> = BehaviorRelay(value: PartnerCredential())
    
    public var phoneNumber: BehaviorRelay<String?> = BehaviorRelay(value:nil)
    

    func bind(view: AppFoodLoginViewController, router: AppFoodLoginRouter){
        self.view = view
        self.router = router
        self.router?.setSourceView(self.view)
    }
    
    

    
    func makePopViewController(){
        router?.navigateToPopViewController()
    }
    

    func getDetailOfChannelOrderFoodToken(id:Int) -> Observable<APIResponse> {
        return  appServiceProvider.rx.request(.getDetailOfChannelOrderFoodToken(id: id))
            .filterSuccessfulStatusCodes()
            .mapJSON().asObservable()
            .showAPIErrorToast()
            .mapObject(type: APIResponse.self)
    }
    
    
    

    
    
    
    func createTokenOfChannelFoodOrder(infor:PartnerCredential) -> Observable<APIResponse> {
        return  appServiceProvider.rx.request(.postCreateTokenOfChannelFoodOrder(
            restaurant_id: infor.restaurant_id,
            restaurant_brand_id: infor.restaurant_brand_id,
            channel_order_food_id: infor.id,
            access_token: infor.access_token,
            username: infor.username,
            password: infor.password,
            x_merchant_token: infor.x_merchant_token ?? ""
        ))
            .filterSuccessfulStatusCodes()
            .mapJSON().asObservable()
            .showAPIErrorToast()
            .mapObject(type: APIResponse.self)
    }
    
    
    func updateTokenOfChannelFoodOrder(infor:PartnerCredential) -> Observable<APIResponse> {

        return appServiceProvider.rx.request(.postUpdateTokenOfChannelFoodOrder(
            id: infor.id,
            access_token: infor.access_token,
            username: infor.username,
            password: infor.password,
            x_merchant_token: infor.x_merchant_token ?? ""
        ))
        .filterSuccessfulStatusCodes()
        .mapJSON().asObservable()
        .showAPIErrorToast()
        .mapObject(type: APIResponse.self)
    }
    
    func changeConnect(infor:PartnerCredential) -> Observable<APIResponse> {
        return  appServiceProvider.rx.request(.postChangeConnectOfRestaurantBrandChannelOrderFoodMap(
            restaurant_brand_channel_order_food_map_id: partner.value.restaurant_brand_channel_order_food_map_id,
            restaurant_id: infor.restaurant_id,
            restaurant_brand_id: infor.restaurant_brand_id,
            channel_order_food_id: infor.channel_order_food_id
        ))
        .filterSuccessfulStatusCodes()
        .mapJSON().asObservable()
        .showAPIErrorToast()
        .mapObject(type: APIResponse.self)
    }
    
    
}
 

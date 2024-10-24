//
//  ReviewFoodViewModel.swift
//  TechresOrder
//
//  Created by Kelvin on 22/01/2023.
//

import UIKit
import RxSwift
import RxRelay
import ObjectMapper

class ReviewFoodViewModel: BaseViewModel {
    private(set) weak var view: ReviewFoodViewController?
       
    // MARK: - Variable -
    // listing data array observe by rxswift
    public var dataArray : BehaviorRelay<[OrderItem]> = BehaviorRelay(value: [])
    public var order_id : BehaviorRelay<Int> = BehaviorRelay(value: 0)
 
    
    func bind(view: ReviewFoodViewController){
        self.view = view
    }

}
extension ReviewFoodViewModel{
    func reviewFood(reviewData:[Review]) -> Observable<APIResponse> {
        return appServiceProvider.rx.request(.reviewFood(order_id: order_id.value, review_data: reviewData))
               .filterSuccessfulStatusCodes()
               .mapJSON().asObservable()
               .showAPIErrorToast()
               .mapObject(type: APIResponse.self)
    }
    
    func getFoodsNeedReview() -> Observable<APIResponse> {
        return appServiceProvider.rx.request(.getFoodsNeedReview(branch_id:Constants.branch.id,order_id: order_id.value))
               .filterSuccessfulStatusCodes()
               .mapJSON().asObservable()
               .showAPIErrorToast()
               .mapObject(type: APIResponse.self)
    }
}

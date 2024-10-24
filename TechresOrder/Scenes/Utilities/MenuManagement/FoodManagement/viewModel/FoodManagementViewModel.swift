//
//  FoodManagementViewModel.swift
//  TechresOrder
//
//  Created by Kelvin on 24/01/2023.
//

import UIKit
import RxSwift
import RxRelay

class FoodManagementViewModel: BaseViewModel {
    private(set) weak var view: FoodManagementViewController?
    private var router: FoodManagementRouter?
    var is_addition = BehaviorRelay<Int>(value: DEACTIVE)
    public var dataArray : BehaviorRelay<[Food]> = BehaviorRelay(value: [])
    public var fullDataArray : BehaviorRelay<[Food]> = BehaviorRelay(value: [])
    
    public var food : BehaviorRelay<Food> = BehaviorRelay(value: Food.init())// Only for update food

    
    
    func bind(view: FoodManagementViewController, router: FoodManagementRouter){
        self.view = view
        self.router = router
        self.router?.setSourceView(self.view)
    }
    
    
    func makePopViewController(){
        router?.navigateToPopViewController()
    }
    func makeUpdateFoodViewController(food:Food){
        router?.navigateToUpdateFoodViewController(food:food)
    }
    
    
    func makeCreateFoodViewController(){
        var createFood = CreateFood()
        createFood.is_addition = is_addition.value
        router?.navigateToCreateFoodViewController(createFood:createFood)
    }
}
extension FoodManagementViewModel{

    func getFoodsManagement() -> Observable<APIResponse> {
        return appServiceProvider.rx.request(.foodsManagement(branch_id:ManageCacheObject.getCurrentBranch().id, is_addition: is_addition.value,status: -1))
               .filterSuccessfulStatusCodes()
               .mapJSON().asObservable()
               .showAPIErrorToast()
               .mapObject(type: APIResponse.self)
       }
    
}

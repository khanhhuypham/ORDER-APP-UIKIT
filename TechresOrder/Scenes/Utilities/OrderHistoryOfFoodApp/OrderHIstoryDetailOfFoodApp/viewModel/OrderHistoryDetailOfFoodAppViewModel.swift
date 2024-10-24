//
//  OrderHistoryDetailOfFoodAppViewModel.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 30/08/2024.
//

import UIKit
import RxSwift
import RxRelay

class OrderHistoryDetailOfFoodAppViewModel: BaseViewModel {
    
    private(set) weak var view: OrderHistoryDetailOfFoodAppViewController?
    private var router: OrderHistoryDetailOfFoodAppRouter?
    public var order : BehaviorRelay<FoodAppOrder> = BehaviorRelay(value: FoodAppOrder())
    
    
  
    func bind(view: OrderHistoryDetailOfFoodAppViewController, router: OrderHistoryDetailOfFoodAppRouter){
        self.view = view
        self.router = router
        self.router?.setSourceView(self.view)
    }
    
    

    func makePopViewController(){
        router?.navigateToPopViewController()
    }
    
    
}

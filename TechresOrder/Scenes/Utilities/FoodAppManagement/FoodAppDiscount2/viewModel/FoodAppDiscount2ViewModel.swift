//
//  FoodAppDiscount2ViewModel.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 28/08/2024.
//

import UIKit
import RxSwift
import RxRelay


class FoodAppDiscount2ViewModel: BaseViewModel {
    private(set) weak var view: FoodAppDiscount2ViewController?
    private var router: FoodAppDiscount2Router?
    
    public var partners : BehaviorRelay<[DiscountOfFoodAppPartner]> = BehaviorRelay(value: [])
    
    func bind(view: FoodAppDiscount2ViewController, router: FoodAppDiscount2Router) {
        self.view = view
        self.router = router
        self.router?.setSourceView(self.view)
    }
    
    

    func makePopViewController(){
        router?.navigateToPopViewController()
    }
    
    
   
}

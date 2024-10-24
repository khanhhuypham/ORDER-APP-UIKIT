//
//  ReportBusinessFoodViewModel.swift
//  TechresOrder
//
//  Created by Kelvin on 07/03/2023.
//

import UIKit
import RxSwift
import RxRelay

class ReportBusinessFoodViewModel: BaseViewModel {
    private(set) weak var view: ReportBusinessFoodViewController?
    private var router: ReportBusinessFoodRouter?
    
    var branch_id = BehaviorRelay<Int>(value: 0)
    var status = BehaviorRelay<Int>(value: -1)
    
    public var restaurant_brand_id : BehaviorRelay<Int> = BehaviorRelay(value: 0)
    public var report_type : BehaviorRelay<Int> = BehaviorRelay(value: 0)
    public var date_string : BehaviorRelay<String> = BehaviorRelay(value: "")
    public var from_date : BehaviorRelay<String> = BehaviorRelay(value: "")
    public var to_date : BehaviorRelay<String> = BehaviorRelay(value: "")
    var category_id = BehaviorRelay<Int>(value: 0)
    var category_types = BehaviorRelay<String>(value: "0")
    var is_cancelled_food = BehaviorRelay<Int>(value: 0)
    var is_combo = BehaviorRelay<Int>(value: 0)
    var is_gift = BehaviorRelay<Int>(value: 0)
    var is_goods = BehaviorRelay<Int>(value: 0)
    var is_take_away_food = BehaviorRelay<Int>(value: 0)
    
    func bind(view: ReportBusinessFoodViewController, router: ReportBusinessFoodRouter){
        self.view = view
        self.router = router
        self.router?.setSourceView(self.view)
    }
    
    func makePopViewController(){
        router?.navigateToPopViewController()
    }
}

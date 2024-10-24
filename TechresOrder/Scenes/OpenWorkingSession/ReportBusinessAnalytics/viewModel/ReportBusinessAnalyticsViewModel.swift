//
//  ReportBusinessAnalyticsViewModel.swift
//  TechresOrder
//
//  Created by Kelvin on 25/02/2023.
//

import UIKit
import RxRelay
import RxSwift

class ReportBusinessAnalyticsViewModel: BaseViewModel {
    
    private(set) weak var view: ReportBusinessAnalyticsViewController?
    private var router: ReportBusinessAnalyticsRouter?
    
    var branch_id = BehaviorRelay<Int>(value: 0)
    var status = BehaviorRelay<Int>(value: -1)
    var cate_id = BehaviorRelay<Int>(value: 0)
    
    public var restaurant_brand_id : BehaviorRelay<Int> = BehaviorRelay(value: 0)
    public var report_type : BehaviorRelay<Int> = BehaviorRelay(value: 0)
    public var date_string : BehaviorRelay<String> = BehaviorRelay(value: "")
    public var from_date : BehaviorRelay<String> = BehaviorRelay(value: "")
    public var to_date : BehaviorRelay<String> = BehaviorRelay(value: "")
//    var category_id = BehaviorRelay<Int>(value: 0)
    var category_types = BehaviorRelay<Int>(value: ACTIVE)
    var is_cancelled_food = BehaviorRelay<Int>(value: ALL)
    var is_combo = BehaviorRelay<Int>(value: ALL)
    var is_gift = BehaviorRelay<Int>(value: ALL)
    var is_goods = BehaviorRelay<Int>(value: ALL)
    var is_take_away_food = BehaviorRelay<Int>(value: ALL)

    
    public var dataArray : BehaviorRelay<[FoodReport]> = BehaviorRelay(value: [])
    
    func bind(view: ReportBusinessAnalyticsViewController, router: ReportBusinessAnalyticsRouter){
        self.view = view
        self.router = router
        self.router?.setSourceView(self.view)
    }
    
    func makePopViewController(){
        router?.navigateToPopViewController()
    }
    
}
extension ReportBusinessAnalyticsViewModel{
    func getCategories() -> Observable<APIResponse> {
        return appServiceProvider.rx.request(.categoriesManagement(branch_id:branch_id.value,status: status.value))
               .filterSuccessfulStatusCodes()
               .mapJSON().asObservable()
               .showAPIErrorToast()
               .mapObject(type: APIResponse.self)
       }
    
    func getReportFood() -> Observable<APIResponse> {
        return appServiceProvider.rx.request(.report_business_analytics(restaurant_brand_id: restaurant_brand_id.value, branch_id: branch_id.value, category_id: cate_id.value, category_types: category_types.value, report_type: report_type.value, date_string: date_string.value, from_date: from_date.value, to_date: to_date.value, is_cancelled_food: is_cancelled_food.value, is_combo: is_combo.value, is_gift: is_gift.value, is_goods: is_goods.value, is_take_away_food: is_take_away_food.value))
               .filterSuccessfulStatusCodes()
               .mapJSON().asObservable()
               .showAPIErrorToast()
               .mapObject(type: APIResponse.self)
       }
}

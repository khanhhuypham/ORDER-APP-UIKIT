//
//  ReportTakeAwayFoodViewModel.swift
//  Techres-Seemt
//
//   Created by Huynh Quang Huy on 13/07/2023.
//  Copyright © 2023 OVERATE-VNTECH. All rights reserved.
//

import UIKit
import RxRelay
import RxSwift

class ReportTakeAwayFoodViewModel: BaseViewModel {
    
    private(set) weak var view: ReportTakeAwayFoodViewController?
    private var router: ReportTakeAwayFoodRouter?
    

    public var is_gift : BehaviorRelay<Int> = BehaviorRelay(value: 0)
    public var food_id : BehaviorRelay<Int> = BehaviorRelay(value: 0)
    public var is_cancel_food : BehaviorRelay<Int> = BehaviorRelay(value: 0)


    public var restaurant_brand_id : BehaviorRelay<Int> = BehaviorRelay(value: ManageCacheObject.getCurrentUser().restaurant_brand_id)
    public var branch_id : BehaviorRelay<Int> = BehaviorRelay(value: ManageCacheObject.getCurrentUser().branch_id)
    public var from_date : BehaviorRelay<String> = BehaviorRelay(value: "")
    public var to_date : BehaviorRelay<String> = BehaviorRelay(value: "")
    
    public var report = BehaviorRelay<FoodReportData>(value: FoodReportData.init()!)

    func bind(view: ReportTakeAwayFoodViewController, router: ReportTakeAwayFoodRouter){
        self.view = view
        self.router = router
        self.router?.setSourceView(view)
    }
}

extension ReportTakeAwayFoodViewModel {
    // Báo cáo món mang về
    func getReportTakeAwayFood() -> Observable<APIResponse> {
        return appServiceProvider.rx.request(.getOrderReportTakeAwayFood(restaurant_brand_id: restaurant_brand_id.value, branch_id: branch_id.value, report_type: report.value.reportType, date_string: report.value.dateString, food_id: food_id.value, is_gift: is_gift.value, is_cancel_food: is_cancel_food.value, key_search: "", from_date: from_date.value, to_date: to_date.value, page: 1, limit: 500))
               .filterSuccessfulStatusCodes()
               .mapJSON().asObservable()
               .showAPIErrorToast()
               .mapObject(type: APIResponse.self)
   }
}

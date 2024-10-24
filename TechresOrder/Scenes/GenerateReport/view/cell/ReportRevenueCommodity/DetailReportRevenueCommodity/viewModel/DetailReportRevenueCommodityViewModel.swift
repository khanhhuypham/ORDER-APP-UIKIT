//
//  DetailReportRevenueCommodityViewModel.swift
//  SEEMT
//
//  Created by Huynh Quang Huy on 08/06/2023.
//  Copyright © 2023 OVERATE-VNTECH. All rights reserved.
//

import UIKit
import RxRelay
import RxSwift

class DetailReportRevenueCommodityViewModel: BaseViewModel {
    
    private(set) weak var view: DetaiRevenueCommodityViewController?
    private var router: DetailReportRevenueCommodityRouter?
        
    public var is_goods : BehaviorRelay<Int> = BehaviorRelay(value: 1)
    public var food_id : BehaviorRelay<Int> = BehaviorRelay(value: ALL)
    public var category_types_commodity : BehaviorRelay<String> = BehaviorRelay(value: "2,3")
    public var is_goods_commodity : BehaviorRelay<Int> = BehaviorRelay(value: 1)
    public var restaurant_brand_id : BehaviorRelay<Int> = BehaviorRelay(value: ManageCacheObject.getCurrentUser().restaurant_brand_id)
    public var branch_id : BehaviorRelay<Int> = BehaviorRelay(value: ManageCacheObject.getCurrentUser().branch_id)
    public var from_date : BehaviorRelay<String> = BehaviorRelay(value: "")
    public var to_date : BehaviorRelay<String> = BehaviorRelay(value: "")
    
    
    public var report = BehaviorRelay<FoodReportData>(value: FoodReportData.init()!)
    

    
    func bind(view: DetaiRevenueCommodityViewController, router: DetailReportRevenueCommodityRouter){
        self.view = view
        self.router = router
        self.router?.setSourceView(view)
    }
}

extension DetailReportRevenueCommodityViewModel {
    // Doanh thu theo hàng hoá
    func getRevenueReportCommodity() -> Observable<APIResponse>{
        return appServiceProvider.rx.request(.getReportRevenueProfitFood(restaurant_brand_id: restaurant_brand_id.value, branch_id: branch_id.value, category_types: category_types_commodity.value, food_id: food_id.value, is_goods: is_goods.value, report_type: report.value.reportType, date_string: report.value.dateString, from_date: from_date.value, to_date: to_date.value))
            .filterSuccessfulStatusCodes()
            .mapJSON().asObservable()
            .showAPIErrorToast()
            .mapObject(type: APIResponse.self)
    }
}


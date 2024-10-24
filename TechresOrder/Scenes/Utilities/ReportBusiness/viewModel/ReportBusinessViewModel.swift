//
//  ReportBusinessViewModel.swift
//  TechresOrder
//
//  Created by Kelvin on 07/03/2023.
//

import UIKit
import RxRelay
import RxSwift

class ReportBusinessViewModel: BaseViewModel {
    private(set) weak var view: ReportBusinessViewController?
    private var router: ReportBusinessRouter?
    
    var branch_id = BehaviorRelay<Int>(value: ManageCacheObject.getCurrentBranch().id)
    public var restaurant_brand_id : BehaviorRelay<Int> = BehaviorRelay(value: ManageCacheObject.getCurrentBrand().id)
    public var from_date : BehaviorRelay<String> = BehaviorRelay(value: "")
    public var to_date : BehaviorRelay<String> = BehaviorRelay(value: "")
    var category_id = BehaviorRelay<Int>(value: -1)
    var is_cancelled_food = BehaviorRelay<Int>(value: 0)
    var is_gift = BehaviorRelay<Int>(value: 0)

        
    public var categoryReport = BehaviorRelay<RevenueCategoryReport>(value: RevenueCategoryReport())
    
    public var foodReport = BehaviorRelay<FoodReportData>(value: FoodReportData()!)
    
    public var otherFoodReport = BehaviorRelay<FoodReportData>(value: FoodReportData()!)
    
    public var cancelFoodReport = BehaviorRelay<FoodReportData>(value: FoodReportData()!)
    
    public var giftedFoodReport = BehaviorRelay<FoodReportData>(value: FoodReportData()!)
    
    public var discountReport = BehaviorRelay<DiscountReport>(value: DiscountReport.init()!)
    
    public var vatReport = BehaviorRelay<VATReport>(value: VATReport.init()!)
    
    public var areaRevenueReport = BehaviorRelay<AreaRevenueReport>(value:AreaRevenueReport()!)
   
    public var tableRevenueReport = BehaviorRelay<TableRevenueReport>(value:TableRevenueReport()!)

    


    func bind(view: ReportBusinessViewController, router: ReportBusinessRouter){
        self.view = view
        self.router = router
        self.router?.setSourceView(self.view)
    }
    
    func makePopViewController(){
        router?.navigateToPopViewController()
    }
    
}
extension ReportBusinessViewModel{
    func reportRevenueByCategory() -> Observable<APIResponse> {
        return appServiceProvider.rx.request(.report_revenue_by_category(
                    restaurant_brand_id: restaurant_brand_id.value,
                    branch_id: branch_id.value,
                    report_type: categoryReport.value.reportType,
                    date_string: categoryReport.value.dateString,
                    from_date: from_date.value,
                    to_date: to_date.value
                ))
               .filterSuccessfulStatusCodes()
               .mapJSON().asObservable()
               .showAPIErrorToast()
               .mapObject(type: APIResponse.self)
       }
    
    func getReportFood() -> Observable<APIResponse> {
        is_cancelled_food.accept(0)
        is_gift.accept(0)
        return appServiceProvider.rx.request(.report_food(
                    restaurant_brand_id: restaurant_brand_id.value,
                    branch_id: branch_id.value,
                    report_type: foodReport.value.reportType,
                    date_string: foodReport.value.dateString,
                    from_date:from_date.value,
                    to_date:to_date.value,
                    category_id: category_id.value,
                    is_combo:-1,
                    is_goods:-1,
                    is_cancelled_food:is_cancelled_food.value,
                    is_gift:is_gift.value,
                    is_take_away_food:-1
                ))
               .filterSuccessfulStatusCodes()
               .mapJSON().asObservable()
               .showAPIErrorToast()
               .mapObject(type: APIResponse.self)
       }
    
    func getReportFoodOther() -> Observable<APIResponse>{
        return appServiceProvider.rx.request(.getRestaurantOtherFoodReport(
            restaurant_brand_id: restaurant_brand_id.value,
            branch_id: branch_id.value,
            category_types: "1",
            food_id: 0,
            is_goods: 0,
            report_type: otherFoodReport.value.reportType,
            date_string: otherFoodReport.value.dateString,
            from_date: from_date.value,
            to_date: to_date.value
        ))
            .filterSuccessfulStatusCodes()
            .mapJSON().asObservable()
            .showAPIErrorToast()
            .mapObject(type: APIResponse.self)
    }

    
    
    func getReportCancelFood() -> Observable<APIResponse> {
        is_cancelled_food.accept(1)
        is_gift.accept(-1)
        return appServiceProvider.rx.request(.report_cancel_food(
                    restaurant_brand_id: restaurant_brand_id.value,
                    branch_id: branch_id.value,
                    report_type: cancelFoodReport.value.reportType,
                    date_string: cancelFoodReport.value.dateString,
                    from_date:from_date.value,
                    to_date:to_date.value,
                    category_id: category_id.value,
                    is_combo:-1,
                    is_goods:-1,
                    is_cancelled_food:is_cancelled_food.value,
                    is_gift:is_gift.value,
                    is_take_away_food:-1
                ))
               .filterSuccessfulStatusCodes()
               .mapJSON().asObservable()
               .showAPIErrorToast()
               .mapObject(type: APIResponse.self)
       }
    
    func getReportGiftedFood() -> Observable<APIResponse> {
        is_cancelled_food.accept(0)
        is_gift.accept(1)
        return appServiceProvider.rx.request(.report_gifted_food(
                    restaurant_brand_id: restaurant_brand_id.value,
                    branch_id: branch_id.value,
                    report_type: giftedFoodReport.value.reportType,
                    date_string: giftedFoodReport.value.dateString,
                    from_date:from_date.value,
                    to_date:to_date.value,
                    category_id: category_id.value,
                    is_combo:-1,
                    is_goods:-1,
                    is_cancelled_food:is_cancelled_food.value,
                    is_gift:is_gift.value,
                    is_take_away_food:-1
                ))
               .filterSuccessfulStatusCodes()
               .mapJSON().asObservable()
               .showAPIErrorToast()
               .mapObject(type: APIResponse.self)
       }
    
    func getReportDiscountedFood() -> Observable<APIResponse> {
        is_cancelled_food.accept(1)
        is_gift.accept(-1)
        return appServiceProvider.rx.request(.report_discount(
                restaurant_brand_id: restaurant_brand_id.value,
                branch_id: branch_id.value,
                report_type: discountReport.value.reportType,
                date_string: discountReport.value.dateString,
                from_date:from_date.value,
                to_date:to_date.value
            ))
            .filterSuccessfulStatusCodes()
            .mapJSON().asObservable()
            .showAPIErrorToast()
            .mapObject(type: APIResponse.self)
       }
    
    func getReportVAT() -> Observable<APIResponse> {
        return appServiceProvider.rx.request(.report_VAT(
                    restaurant_brand_id: restaurant_brand_id.value,
                    branch_id: branch_id.value,
                    report_type: vatReport.value.reportType,
                    date_string: vatReport.value.dateString,
                    from_date:from_date.value,
                    to_date:to_date.value
                ))
               .filterSuccessfulStatusCodes()
               .mapJSON().asObservable()
               .showAPIErrorToast()
               .mapObject(type: APIResponse.self)
    }
    
    
    func getReportAreaRevenue() -> Observable<APIResponse> {
        return appServiceProvider.rx.request(.report_area_revenue(
                    restaurant_brand_id: restaurant_brand_id.value,
                    branch_id: branch_id.value,
                    report_type: areaRevenueReport.value.reportType,
                    date_string: areaRevenueReport.value.dateString,
                    from_date:from_date.value,
                    to_date:to_date.value
                ))
               .filterSuccessfulStatusCodes()
               .mapJSON().asObservable()
               .showAPIErrorToast()
               .mapObject(type: APIResponse.self)
    }
    
    
    func getReportTableRevenue() -> Observable<APIResponse> {
        return appServiceProvider.rx.request(.report_table_revenue(
                    restaurant_brand_id: restaurant_brand_id.value,
                    branch_id: branch_id.value,
                    area_id: -1,
                    report_type: tableRevenueReport.value.reportType,
                    date_string: tableRevenueReport.value.dateString,
                    from_date:from_date.value,
                    to_date:to_date.value
                ))
               .filterSuccessfulStatusCodes()
               .mapJSON().asObservable()
               .showAPIErrorToast()
               .mapObject(type: APIResponse.self)
    }
    
    
}

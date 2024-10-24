//
//  GenerateReportViewModel.swift
//  TechresOrder
//
//  Created by Pham Khánh Huy on 14/01/2023.
//

import UIKit
import RxRelay
import RxSwift

class GenerateReportViewModel: BaseViewModel {
    private(set) weak var view: GenerateReportViewController?
    private var router: GenerateReportRouter?
   
    public var dataSectionArray : BehaviorRelay<[Int]> = BehaviorRelay(value: [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17])
    public var restaurant_brand_id : BehaviorRelay<Int> = BehaviorRelay(value: ManageCacheObject.getCurrentUser().restaurant_brand_id)
    public var branch_id : BehaviorRelay<Int> = BehaviorRelay(value: ManageCacheObject.getCurrentUser().branch_id)
    public var from_date : BehaviorRelay<String> = BehaviorRelay(value: "")
    public var to_date : BehaviorRelay<String> = BehaviorRelay(value: "")
    public var category_types_commodity : BehaviorRelay<String> = BehaviorRelay(value: "2,3")
    public var category_types : BehaviorRelay<String> = BehaviorRelay(value: "1")
    public var food_id : BehaviorRelay<Int> = BehaviorRelay(value: -1)
    public var is_goods : BehaviorRelay<Int> = BehaviorRelay(value: 0)
    public var type : BehaviorRelay<Int> = BehaviorRelay(value: 0)
    public var is_cancel_food : BehaviorRelay<Int> = BehaviorRelay(value: 0)
    public var is_gift : BehaviorRelay<Int> = BehaviorRelay(value: 0)

    
    
    // ======== Define Data Report ===========
    
    public var dailyOrderReport = BehaviorRelay<DailyOrderReport>(value: DailyOrderReport.init(reportType: REPORT_TYPE_TODAY, dateString: TimeUtils.getCurrentDateTime().dateTimeNow))
   
    public var foodAppReport = BehaviorRelay<FoodAppReport>(value: FoodAppReport.init(reportType: REPORT_TYPE_TODAY, dateString: TimeUtils.getCurrentDateTime().dateTimeNow))
    
    public var toDayRenueReport = BehaviorRelay<RevenueReport>(value: RevenueReport.init(reportType: REPORT_TYPE_TODAY, dateString: TimeUtils.getCurrentDateTime().dateTimeNow))
    
    public var saleReport = BehaviorRelay<SaleReport>(value: SaleReport.init(reportType: REPORT_TYPE_THIS_MONTH, dateString: TimeUtils.getCurrentDateTime().thisMonth,fromDate: TimeUtils.getCurrentDateTime().thisMonth))
        
    public var revenueCostProfitReport = BehaviorRelay<RevenueFeeProfitReport>(value: RevenueFeeProfitReport.init(reportType: REPORT_TYPE_THIS_MONTH, dateString: TimeUtils.getCurrentDateTime().thisMonth))

    public var areaRevenueReport = BehaviorRelay<AreaRevenueReport>(value: AreaRevenueReport.init(reportType: REPORT_TYPE_THIS_MONTH, dateString: TimeUtils.getCurrentDateTime().thisMonth))
    
    public var tableRevenueReport = BehaviorRelay<TableRevenueReport>(value:TableRevenueReport.init(reportType: REPORT_TYPE_THIS_MONTH, dateString: TimeUtils.getCurrentDateTime().thisMonth))
    
    public var employeeRevenueReport = BehaviorRelay<EmployeeRevenueReport>(value: EmployeeRevenueReport.init(reportType: REPORT_TYPE_THIS_MONTH, dateString: TimeUtils.getCurrentDateTime().thisMonth))
    
    public var foodReport = BehaviorRelay<FoodReportData>(value: FoodReportData.init(reportType: REPORT_TYPE_THIS_MONTH, dateString: TimeUtils.getCurrentDateTime().thisMonth))
    
    public var commodityReport = BehaviorRelay<FoodReportData>(value: FoodReportData.init(reportType: REPORT_TYPE_THIS_MONTH, dateString: TimeUtils.getCurrentDateTime().thisMonth))
    
    public var categoryRevenueReport = BehaviorRelay<RevenueCategoryReport>(value: RevenueCategoryReport.init(reportType: REPORT_TYPE_THIS_MONTH, dateString: TimeUtils.getCurrentDateTime().thisMonth))
    
    public var giftedFoodReport = BehaviorRelay<FoodReportData>(value: FoodReportData.init(reportType: REPORT_TYPE_THIS_MONTH, dateString: TimeUtils.getCurrentDateTime().thisMonth))
    
    public var otherFoodReport = BehaviorRelay<FoodReportData>(value: FoodReportData.init(reportType: REPORT_TYPE_THIS_MONTH, dateString: TimeUtils.getCurrentDateTime().thisMonth))
    
    public var cancelFoodReport = BehaviorRelay<FoodReportData>(value: FoodReportData.init(reportType: REPORT_TYPE_THIS_MONTH, dateString: TimeUtils.getCurrentDateTime().thisMonth))
    
    public var takeAwayFoodReport = BehaviorRelay<FoodReportData>(value: FoodReportData.init(reportType: REPORT_TYPE_THIS_MONTH, dateString: TimeUtils.getCurrentDateTime().thisMonth))
    
    public var vatReport = BehaviorRelay<VATReport>(value: VATReport.init(reportType: REPORT_TYPE_THIS_MONTH, dateString: TimeUtils.getCurrentDateTime().thisMonth))
    
    public var discountReport = BehaviorRelay<DiscountReport>(value: DiscountReport.init(reportType: REPORT_TYPE_THIS_MONTH, dateString: TimeUtils.getCurrentDateTime().thisMonth))
    
    public var surchargeReport = BehaviorRelay<SurchargeReport>(value: SurchargeReport.init(reportType: REPORT_TYPE_THIS_MONTH, dateString: TimeUtils.getCurrentDateTime().thisMonth))

    //======================

    func bind(view: GenerateReportViewController, router: GenerateReportRouter){
        self.view = view
        self.router = router
        self.router?.setSourceView(self.view)
    }

    //MARK: Báo cáo danh thu tạm tính hôm này
    func ReportRevenueTempTodayViewController(){
        router?.navigateToRevenueDetailViewController(report:SaleReport.init(reportType: REPORT_TYPE_TODAY, dateString: TimeUtils.getCurrentDateTime().dateTimeNow))
    }
    
    
    //MARK: Báo cáo danh thu bán hàng
    func makeRevenueDetailViewController(){
        router?.navigateToRevenueDetailViewController(report:saleReport.value)
    }
    
    
    //MARK: Báo cáo danh thu khu vực
    func makeToAreaReportViewController(){
        router?.navigateToDetailReportRevenueAreaViewController(report:areaRevenueReport.value)
    }
    
    
    //MARK: Báo cáo danh thu bàn
    func makeToTableReportViewController(){
        router?.navigateToDetailReportRevenueTableViewController(report:tableRevenueReport.value)
    }
    
    
    //MARK: Báo cáo doanh thu nhân viên
    func makeToDetailReportRevenueEmployeeViewController(){
        router?.navigateToDetailReportRevenueEmployeeViewController()
    }
    
    // MARK: Báo cáo món ăn
     func makeToDetailRevenueByFoodViewController(){
         router?.navigateToDetailRevenueByFoodViewController(report:foodReport.value)
     }
    
    //MARK: Doanh thu theo hàng hóa
    func makeToDetailReportRevenueCommodityViewController(){
        router?.navigateToDetailReportRevenueCommodityViewController(report: commodityReport.value)
    }
    
    //MARK: Báo cáo danh mục
    func makeToDetailRevenueByFoodCategoryViewController(){
        router?.navigateToDetailRevenueByFoodCategoryViewController(report:categoryRevenueReport.value)
    }
    
    //MARK: Báo cáo món tặng
    func makeToDetailReportGiftFoodViewController(){
        router?.navigateToDetailReportGiftFoodViewController(report: giftedFoodReport.value)
    }
    
    //MARK: Báo cáo món khác
    func makeToDetailReportOtherFoodViewController(){
        router?.navigateToDetailReportOtherFoodViewController(report:otherFoodReport.value)
    }
    
    //MARK: Báo cáo món hủy
    func makeToDetailReportCancelFoodViewController(){
        router?.navigateToDetailReportCancelFoodViewController(report: cancelFoodReport.value)
    }
    
    
    //MARK: Báo cáo món mang về
    func makeToDetailReportTakeAwayFoodViewController(){
        router?.navigateToDetailReportTakeAwayFoodViewController(report:takeAwayFoodReport.value)
    }
    
    // Báo cáo VAT
    func makeToDetailReportVATViewController(){
        router?.navigateToDetailReportVATViewController(report: vatReport.value)
    }
    
    
    // Báo cáo giảm giá 
    func makeToDetailReportDiscountViewController(){
        router?.navigateToDetailReportDiscountViewController(report: discountReport.value)
    }

    
}
extension GenerateReportViewModel{
    
    func reportRevenueActivities() -> Observable<APIResponse> {
        return appServiceProvider.rx.request(.report_revenue_activities_in_day_by_branch(restaurant_brand_id: restaurant_brand_id.value, branch_id: branch_id.value, report_type: dailyOrderReport.value.reportType, date_string: dailyOrderReport.value.dateString, from_date: from_date.value, to_date: to_date.value))
               .filterSuccessfulStatusCodes()
               .mapJSON().asObservable()
               .showAPIErrorToast()
               .mapObject(type: APIResponse.self)
    }
    
    
    
    func reportOfFoodApp() -> Observable<APIResponse> {
        return appServiceProvider.rx.request(.getRevenueSumaryReportOfFoodApp(
            restaurant_id: Constants.restaurant_id,
            restaurant_brand_id: restaurant_brand_id.value,
            branch_id: branch_id.value,
            food_channel_id: -1,
            date_string: foodAppReport.value.dateString,
            report_type: foodAppReport.value.reportType,
            hour_to_take_report: ManageCacheObject.getSetting().hour_to_take_report
        ))
       .filterSuccessfulStatusCodes()
       .mapJSON().asObservable()
       .showAPIErrorToast()
       .mapObject(type: APIResponse.self)
    }
    
    
    func reportRevenueByTime() -> Observable<APIResponse> {
        return appServiceProvider.rx.request(.report_revenue_by_time(restaurant_brand_id: restaurant_brand_id.value, branch_id: branch_id.value, report_type: toDayRenueReport.value.reportType, date_string: toDayRenueReport.value.dateString, from_date: from_date.value, to_date: to_date.value))
               .filterSuccessfulStatusCodes()
               .mapJSON().asObservable()
               .showAPIErrorToast()
               .mapObject(type: APIResponse.self)
       }
    
    
    func reportRevenueCostProfit() -> Observable<APIResponse> {
        return appServiceProvider.rx.request(.report_revenue_fee_profit(restaurant_brand_id: restaurant_brand_id.value, branch_id: branch_id.value, report_type: revenueCostProfitReport.value.reportType, date_string: revenueCostProfitReport.value.dateString, from_date: from_date.value, to_date: to_date.value))
               .filterSuccessfulStatusCodes()
               .mapJSON().asObservable()
               .showAPIErrorToast()
               .mapObject(type: APIResponse.self)
       }
    

    func reportRevenueByCategory() -> Observable<APIResponse> {
        return appServiceProvider.rx.request(.report_revenue_by_category(restaurant_brand_id: restaurant_brand_id.value, branch_id: branch_id.value, report_type: categoryRevenueReport.value.reportType, date_string: categoryRevenueReport.value.dateString, from_date: from_date.value, to_date: to_date.value))
               .filterSuccessfulStatusCodes()
               .mapJSON().asObservable()
               .showAPIErrorToast()
               .mapObject(type: APIResponse.self)
    }
    

}

extension GenerateReportViewModel {
    // Báo cáo doanh thu tổng quan
    func getReportRevenueGenral() -> Observable<APIResponse> {
        return appServiceProvider.rx.request(.getReportRevenueGenral(restaurant_brand_id: restaurant_brand_id.value, branch_id: branch_id.value, report_type: saleReport.value.reportType, date_string: saleReport.value.dateString, from_date: "", to_date: to_date.value))
               .filterSuccessfulStatusCodes()
               .mapJSON().asObservable()
               .showAPIErrorToast()
               .mapObject(type: APIResponse.self)
       }
    
    //Doanh thu theo khu vực
    func getReportRevenueArea() -> Observable<APIResponse> {
        return appServiceProvider.rx.request(.getReportRevenueArea(restaurant_brand_id: restaurant_brand_id.value, branch_id: branch_id.value, report_type: areaRevenueReport.value.reportType, date_string: areaRevenueReport.value.dateString, from_date: from_date.value, to_date: to_date.value))
               .filterSuccessfulStatusCodes()
               .mapJSON().asObservable()
               .showAPIErrorToast()
               .mapObject(type: APIResponse.self)
    }
    
    //Doanh thu theo BÀN
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
    



    // Báo cáo nhân viên
    func getReportEmployee() -> Observable<APIResponse> {
        return appServiceProvider.rx.request(.getRenueByEmployeeReport(restaurant_brand_id: restaurant_brand_id.value, branch_id: branch_id.value, report_type: employeeRevenueReport.value.reportType, date_string: employeeRevenueReport.value.dateString, from_date: from_date.value, to_date: to_date.value))
               .filterSuccessfulStatusCodes()
               .mapJSON().asObservable()
               .showAPIErrorToast()
               .mapObject(type: APIResponse.self)
       }
    // Danh thu theo món ăn
    func getRevenueReportByFood() -> Observable<APIResponse>{
        return appServiceProvider.rx.request(.getReportRevenueProfitFood(restaurant_brand_id: restaurant_brand_id.value, branch_id: branch_id.value, category_types: "", food_id: food_id.value, is_goods: -1, report_type: foodReport.value.reportType, date_string: foodReport.value.dateString, from_date: from_date.value, to_date: to_date.value))
            .filterSuccessfulStatusCodes()
            .mapJSON().asObservable()
            .showAPIErrorToast()
            .mapObject(type: APIResponse.self)
        
    }
    
    // Doanh thu theo hàng hoá
    func getRevenueReportCommodity() -> Observable<APIResponse>{
        return appServiceProvider.rx.request(.getReportRevenueProfitFood(restaurant_brand_id: restaurant_brand_id.value, branch_id: branch_id.value, category_types: category_types_commodity.value, food_id: food_id.value, is_goods: is_goods.value, report_type: commodityReport.value.reportType, date_string: commodityReport.value.dateString, from_date: from_date.value, to_date: to_date.value))
            .filterSuccessfulStatusCodes()
            .mapJSON().asObservable()
            .showAPIErrorToast()
            .mapObject(type: APIResponse.self)
    }
    
    // Báo cáo món tặng
    func getGiftedFoodReport() -> Observable<APIResponse> {
        return appServiceProvider.rx.request(.getOrderReportFoodGift(restaurant_brand_id: restaurant_brand_id.value, branch_id: branch_id.value, type_sort: type.value, is_group: 1, report_type: giftedFoodReport.value.reportType, date_string: giftedFoodReport.value.dateString, from_date: from_date.value, to_date: to_date.value))
               .filterSuccessfulStatusCodes()
               .mapJSON().asObservable()
               .showAPIErrorToast()
               .mapObject(type: APIResponse.self)
    }
    
    
    // Báo cáo món ngoài menu
    func getReportFoodOther() -> Observable<APIResponse>{
        return appServiceProvider.rx.request(.getRestaurantOtherFoodReport(restaurant_brand_id: restaurant_brand_id.value, branch_id: branch_id.value, category_types: category_types.value, food_id: food_id.value, is_goods: is_goods.value, report_type: otherFoodReport.value.reportType, date_string: otherFoodReport.value.dateString, from_date: from_date.value, to_date: to_date.value))
            .filterSuccessfulStatusCodes()
            .mapJSON().asObservable()
            .showAPIErrorToast()
            .mapObject(type: APIResponse.self)
        
    }
    
   
    
    
    // Báo cáo món hủy
    func getReportFoodCancel() -> Observable<APIResponse> {
        return appServiceProvider.rx.request(.getOrderReportFoodCancel(restaurant_brand_id: restaurant_brand_id.value, branch_id: branch_id.value, type: type.value, report_type: cancelFoodReport.value.reportType, date_string: cancelFoodReport.value.dateString, from_date: from_date.value, to_date: to_date.value))
               .filterSuccessfulStatusCodes()
               .mapJSON().asObservable()
               .showAPIErrorToast()
               .mapObject(type: APIResponse.self)
    }
    
    
    // Báo cáo món mang về
    func getReportTakeAwayFood() -> Observable<APIResponse> {
        return appServiceProvider.rx.request(.getOrderReportTakeAwayFood(restaurant_brand_id: restaurant_brand_id.value, branch_id: branch_id.value, report_type: takeAwayFoodReport.value.reportType, date_string: takeAwayFoodReport.value.dateString, food_id: food_id.value, is_gift: is_gift.value, is_cancel_food: is_cancel_food.value, key_search: "", from_date: from_date.value, to_date: to_date.value, page: 1, limit: 500))
               .filterSuccessfulStatusCodes()
               .mapJSON().asObservable()
               .showAPIErrorToast()
               .mapObject(type: APIResponse.self)
       }
    
    
    // Báo cáo VAT
    func getReportVAT() -> Observable<APIResponse> {
        return appServiceProvider.rx.request(.getRestaurantVATReport(restaurant_brand_id: restaurant_brand_id.value, branch_id: branch_id.value, report_type: vatReport.value.reportType, date_string: vatReport.value.dateString, from_date: from_date.value, to_date: to_date.value))
               .filterSuccessfulStatusCodes()
               .mapJSON().asObservable()
               .showAPIErrorToast()
               .mapObject(type: APIResponse.self)
    }
    
    
    
    // Báo cáo giảm giá
    func getdiscountReport() -> Observable<APIResponse> {
        return appServiceProvider.rx.request(.getReportOrderRestaurantDiscountFromOrder(restaurant_brand_id: restaurant_brand_id.value, branch_id: branch_id.value, report_type: discountReport.value.reportType, date_string: discountReport.value.dateString, from_date: from_date.value, to_date: to_date.value))
               .filterSuccessfulStatusCodes()
               .mapJSON().asObservable()
               .showAPIErrorToast()
               .mapObject(type: APIResponse.self)
       }

    //Báo cáo Phụ thu
    func getReportSurcharge() -> Observable<APIResponse> {
        return appServiceProvider.rx.request(.getReportSurcharge(restaurant_brand_id: restaurant_brand_id.value, branch_id: branch_id.value, report_type: surchargeReport.value.reportType, date_string: surchargeReport.value.dateString, from_date: from_date.value, to_date: to_date.value))
               .filterSuccessfulStatusCodes()
               .mapJSON().asObservable()
               .showAPIErrorToast()
               .mapObject(type: APIResponse.self)
    }
    

}

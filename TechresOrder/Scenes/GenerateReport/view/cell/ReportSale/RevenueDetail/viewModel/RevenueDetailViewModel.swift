//
//  RevenueDetailViewModel.swift
//  TechresOrder
//
//  Created by Kelvin on 05/02/2023.
//

import UIKit
import RxSwift
import RxRelay

class RevenueDetailViewModel: BaseViewModel {
    private(set) weak var view: RevenueDetailViewController?
    private var router:RevenueDetailRouter?
    public var saleReport = BehaviorRelay<SaleReport>(value: SaleReport.init(reportType: REPORT_TYPE_THIS_MONTH, dateString: TimeUtils.getCurrentDateTime().thisMonth))
    public var restaurant_brand_id : BehaviorRelay<Int> = BehaviorRelay(value: ManageCacheObject.getCurrentUser().restaurant_brand_id)
    public var branch_id : BehaviorRelay<Int> = BehaviorRelay(value: ManageCacheObject.getCurrentUser().branch_id)
    public var from_date : BehaviorRelay<String> = BehaviorRelay(value: "")
    public var to_date : BehaviorRelay<String> = BehaviorRelay(value: "")
    

    func bind(view: RevenueDetailViewController, router: RevenueDetailRouter){
        self.view = view
        self.router = router
        self.router?.setSourceView(self.view)
    }
    
    
    func makePopViewController(){
        router?.navigateToPopViewController()
    }
}
extension RevenueDetailViewModel{
    func reportRevenueByTime() -> Observable<APIResponse> {
        return appServiceProvider.rx.request(.report_revenue_by_time(restaurant_brand_id: restaurant_brand_id.value, branch_id: branch_id.value, report_type: saleReport.value.reportType, date_string: saleReport.value.dateString, from_date: from_date.value, to_date: to_date.value))
               .filterSuccessfulStatusCodes()
               .mapJSON().asObservable()
               .showAPIErrorToast()
               .mapObject(type: APIResponse.self)
       }
}

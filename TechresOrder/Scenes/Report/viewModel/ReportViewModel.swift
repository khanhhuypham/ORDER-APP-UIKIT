//
//  ReportViewModel.swift
//  TechresOrder
//
//  Created by macmini_techres_03 on 30/01/2023.
//

import UIKit
import RxRelay
import RxSwift

class ReportViewModel: BaseViewModel {

    private(set) weak var view: ReportViewController?
    
    public var report = BehaviorRelay<RevenueReport>(value: RevenueReport.init(reportType: REPORT_TYPE_TODAY, dateString: TimeUtils.getCurrentDateTime().dateTimeNow))
    
    func bind(view: ReportViewController){
        self.view = view
    }
    

}
extension ReportViewModel{
    func reportRevenueByEmployee() -> Observable<APIResponse> {
        return appServiceProvider.rx.request(
            .report_revenue_by_employee(
                employee_id:ManageCacheObject.getCurrentUser().id,
                restaurant_brand_id: ManageCacheObject.getCurrentBrand().id,
                branch_id: ManageCacheObject.getCurrentBranch().id,
                report_type: report.value.reportType,
                date_string: report.value.dateString,
                from_date: "",
                to_date: ""))
               .filterSuccessfulStatusCodes()
               .mapJSON().asObservable()
               .showAPIErrorToast()
               .mapObject(type: APIResponse.self)
       }
}

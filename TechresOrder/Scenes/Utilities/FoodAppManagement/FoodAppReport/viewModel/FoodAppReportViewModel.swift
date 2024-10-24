//
//  FoodAppReportViewModel.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 23/08/2024.
//

import UIKit
import RxSwift
import RxRelay

class FoodAppReportViewModel: BaseViewModel {
    
    private(set) weak var view: FoodAppReportViewController?
    private var router: FoodAppReportRouter?
    

    
    public var report = BehaviorRelay<FoodAppReport>(value: FoodAppReport.init(reportType: REPORT_TYPE_TODAY, dateString: TimeUtils.getCurrentDateTime().dateTimeNow))
    
  
    func bind(view: FoodAppReportViewController, router: FoodAppReportRouter){
        self.view = view
        self.router = router
        self.router?.setSourceView(view)
    }
    
    func makePopViewController(){
        router?.navigatePopViewController()
    }
    
}

extension FoodAppReportViewModel {

    
    func getRevenueSumaryReportOfFoodApp() -> Observable<APIResponse> {
        return appServiceProvider.rx.request(.getRevenueSumaryReportOfFoodApp(
            restaurant_id: Constants.restaurant_id,
            restaurant_brand_id: Constants.brand.id,
            branch_id: Constants.branch.id,
            food_channel_id: -1,
            date_string: report.value.dateString,
            report_type: report.value.reportType,
            hour_to_take_report: ManageCacheObject.getSetting().hour_to_take_report
        ))
       .filterSuccessfulStatusCodes()
       .mapJSON().asObservable()
       .showAPIErrorToast()
       .mapObject(type: APIResponse.self)
    }
    
}



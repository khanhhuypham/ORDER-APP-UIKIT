//
//  FeeRebuildViewModel.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 31/01/2024.
//


import UIKit
import RxSwift
import RxRelay
class FeeRebuildViewModel: BaseViewModel {
    private(set) weak var view: FeeRebuildViewController?
    private var router:FeeRebuildRouter?
 

    public var feeReport = BehaviorRelay<FeeData>(value: FeeData.init(reportType: REPORT_TYPE_TODAY, dateString: TimeUtils.getCurrentDateTime().dateTimeNow))
    
   
    func bind(view: FeeRebuildViewController, router: FeeRebuildRouter){
        self.view = view
        self.router = router
        self.router?.setSourceView(self.view)
    }
    
    func makePopViewController(){
        router?.navigateToPopViewController()
    }
    func makeToCreateFeeViewController(){
        router?.navigateToCreateFeeViewController()
    }
    
    func makeToUpdateFeeMaterialViewController(materialFeeId:Int){
        router?.navigateToUpdateFeeMaterialViewController(materialFeeId: materialFeeId)
    }
    
    func makeToUpdateOtherFeedViewController(fee: Fee){
        router?.navigateToUpdateOtherFeedViewController(fee: fee)
    }
    
}
//MARK: CALL API
extension FeeRebuildViewModel{

    func fees() -> Observable<APIResponse> {
        return appServiceProvider.rx.request(.fees(
            branch_id: ManageCacheObject.getCurrentBranch().id,
            restaurant_budget_id: ALL,
            from: "",
            to: "",
            type:1,
            is_take_auto_generated:ALL,
            order_session_id:ALL,
            report_type:feeReport.value.reportType,
            addition_fee_statuses:"0,1,2,3,4,5",
            is_paid_debt: ALL))
               .filterSuccessfulStatusCodes()
               .mapJSON().asObservable()
               .showAPIErrorToast()
               .mapObject(type: APIResponse.self)
       }
}

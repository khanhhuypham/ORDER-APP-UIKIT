//
//  OrderManagementViewModel.swift
//  TechresOrder
//
//  Created by Kelvin on 25/01/2023.
//

import UIKit
import RxRelay
import RxSwift

class OrderManagementViewModel: BaseViewModel {
    private(set) weak var view: OrderManagementViewController?
    private var router: OrderManagementRouter?
    
    // MARK: - Variable -
    // listing data array observe by rxswift
    public var dataArray : BehaviorRelay<[Order]> = BehaviorRelay(value: [])

    public var employeeId : BehaviorRelay<Int> = BehaviorRelay(value: permissionUtils.isSaleReport ? -1 : ManageCacheObject.getCurrentUser().id)
    
    var APIParameter = BehaviorRelay<(
        report_type:Int,
        time:String,
        key_search:String,
        limit:Int,
        page:Int,
        isGetFullData:Bool
    )>(value: (report_type:REPORT_TYPE_TODAY,time:TimeUtils.dateToString(date: Date()),key_search:"",limit:20, page:1,isGetFullData:false))
    
    
    func bind(view: OrderManagementViewController, router: OrderManagementRouter){
        self.view = view
        self.router = router
        self.router?.setSourceView(self.view)
    }
    
    
    
      func clearDataAndCallAPI(){
          dataArray.accept([])
          var apiParameter = APIParameter.value
          apiParameter.page = 1
          apiParameter.isGetFullData = false
          APIParameter.accept(apiParameter)
          view?.ordersHistory()
          view?.getTotalAmountOfOrders()
      }
    
    
    func makePayMentViewController(order:Order){
        router?.navigateToPayMentViewController(order: OrderDetail(order: order))
    }
    
    func makePopViewController(){
        router?.navigateToPopViewController()
    }
    
}
extension OrderManagementViewModel {
    
    func orders() -> Observable<APIResponse> {
                
        return appServiceProvider.rx.request(.ordersHistory(
            brand_id:Constants.brand.id,
            branch_id:Constants.branch.id,
            id: employeeId.value,
            report_type: APIParameter.value.report_type,
            time: APIParameter.value.time,
            limit: APIParameter.value.limit,
            page: APIParameter.value.page,
            key_search: APIParameter.value.key_search,
            is_take_away_table: (permissionUtils.GPBH_1 || permissionUtils.GPBH_2_o_1) ? ALL : DEACTIVE,
            is_take_away:(permissionUtils.GPBH_1 || permissionUtils.GPBH_2_o_1) ? ALL : DEACTIVE))
               .filterSuccessfulStatusCodes()
               .mapJSON().asObservable()
               .showAPIErrorToast()
               .mapObject(type: APIResponse.self)
                                    
    }
    
    func getTotalAmountOfOrders() -> Observable<APIResponse> {
     
        return appServiceProvider.rx.request(.getTotalAmountOfOrders(
            restaurant_brand_id: ManageCacheObject.getCurrentBrand().id,
            branch_id: ManageCacheObject.getCurrentBranch().id,
            is_take_away_table: (permissionUtils.GPBH_1 || permissionUtils.GPBH_2_o_1) ? ALL : DEACTIVE,
            order_status: "2,5,8",
            key_search:APIParameter.value.key_search,
            employee_id:employeeId.value,
            is_take_away:(permissionUtils.GPBH_1 || permissionUtils.GPBH_2_o_1) ? ALL : DEACTIVE,
            report_type:APIParameter.value.report_type))
               .filterSuccessfulStatusCodes()
               .mapJSON().asObservable()
               .showAPIErrorToast()
               .mapObject(type: APIResponse.self)
                                    
    }
    
}

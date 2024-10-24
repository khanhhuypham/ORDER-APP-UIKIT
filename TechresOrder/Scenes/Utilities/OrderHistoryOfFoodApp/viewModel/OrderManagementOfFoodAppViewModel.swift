//
//  OrderManagementOfFoodAppViewModel.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 20/08/2024.
//

import UIKit
import RxRelay
class OrderManagementOfFoodAppViewModel: BaseViewModel {
    private(set) weak var view: OrderManagementOfFoodAppViewController?
    private var router: OrderManagementOfFoodAppRouter?
    
    
    public var history = BehaviorRelay<OrderHistoryOfFoodApp>(value:
        OrderHistoryOfFoodApp(partnerId: -1, reportType: REPORT_TYPE_TODAY, dateString: TimeUtils.getCurrentDateTime().dateTimeNow)
    )
    
    public var filterType = BehaviorRelay<Int>(value: 0)
    
    public var reportTypeFilter = BehaviorRelay<[Int:String]>(value: [
        REPORT_TYPE_TODAY:"Hôm nay",
        REPORT_TYPE_YESTERDAY:"Hôm qua",
        REPORT_TYPE_THIS_WEEK:"Tuần này",
        REPORT_TYPE_LAST_MONTH:"Tháng trước",
        REPORT_TYPE_THIS_MONTH:"Tháng này",
        REPORT_TYPE_THREE_MONTHS:"3 tháng gần nhất",
        REPORT_TYPE_LAST_YEAR:"Năm trước",
        REPORT_TYPE_THIS_YEAR:"Năm nay",
        REPORT_TYPE_THREE_YEAR:"3 Năm gần nhất",
        REPORT_TYPE_ALL_YEAR:"Tất các năm"
    ])
    
    
    public var partnerFilter = BehaviorRelay<[String:Int]>(value: [
        "Tất cả":-1,
        "Go":3,
        "BeFood":4,
        "Grab":2,
        "SPFood":1,
    ])
    
    
    func bind(view: OrderManagementOfFoodAppViewController, router: OrderManagementOfFoodAppRouter){
        self.view = view
        self.router = router
        self.router?.setSourceView(self.view)
    }
    
    

    func makePopViewController(){
        router?.navigateToPopViewController()
    }
    
    
    func makeOrderHistoryDetailOfFoodAppViewController(order:FoodAppOrder){
        router?.navigateToOrderHistoryDetailOfFoodAppViewController(order: order)
    }
    
    
}

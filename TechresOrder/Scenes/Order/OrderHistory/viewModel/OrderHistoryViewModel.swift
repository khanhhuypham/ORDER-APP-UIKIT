//
//  OrderHistoryViewModel.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 13/12/2023.
//

import UIKit
import RxSwift
import RxRelay
class OrderHistoryViewModel: NSObject {
    private(set) weak var view: OrderHistoryViewController?


    public var order:BehaviorRelay<Order> = BehaviorRelay(value: Order.init()!)
    public var dataArray:BehaviorRelay<[ActivityLog]> = BehaviorRelay(value: [])
    
    var keySearch = BehaviorRelay<String>(value: "")
    var pagination = BehaviorRelay<(limit: Int,
                                page:Int,
                                isGetFullData:Bool,
                                isAPICalling:Bool
    )>(value: (limit:30, page:1,isGetFullData:false,isAPICalling:false))

    
    func bind(view: OrderHistoryViewController){
        self.view = view
    }
    
    func clearDataAndCallAPI(){
        dataArray.accept([])
        var p = pagination.value
        p.page = 1
        p.isGetFullData = false
        p.isAPICalling = true
        pagination.accept(p)
        view?.getOrderHistory()
    }

}

extension OrderHistoryViewModel{
    
    //MARK: API lấy danh sách món ăn
    func getActivityLog() -> Observable<APIResponse> {
        return appServiceProvider.rx.request(.getActivityLog(
            object_id: order.value.id,
            type: 2,
            key_search: keySearch.value,
            object_type: "",
            from: "",
            to: "",
            page: pagination.value.page,
            limit: pagination.value.limit))
               .filterSuccessfulStatusCodes()
               .mapJSON().asObservable()
               .showAPIErrorToast()
               .mapObject(type: APIResponse.self)
    }
  
}

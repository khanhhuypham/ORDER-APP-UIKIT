//
//  DialogChooseTableViewModel.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 17/01/2024.
//

import UIKit



import UIKit
import RxSwift
import RxRelay

class DialogChooseTableViewModel {
    private(set) weak var view: DialogChooseTableViewController?

    public var table_array = BehaviorRelay<[Table]>(value: [])
    public var area_array = BehaviorRelay<[Area]>(value: [])
    var order = BehaviorRelay<Order>(value: Order()!)
    var status = BehaviorRelay<String>(value: "")
//    
    var isAPICalling = BehaviorRelay<Bool>(value: false)
    
    func bind(view: DialogChooseTableViewController){
        self.view = view

    }
    
}

extension DialogChooseTableViewModel{
    func getAreas() -> Observable<APIResponse> {
        return appServiceProvider.rx.request(
            .areas(
                branch_id:ManageCacheObject.getCurrentBranch().id,
                status: ACTIVE
            ))
               .filterSuccessfulStatusCodes()
               .mapJSON().asObservable()
               .showAPIErrorToast()
               .mapObject(type: APIResponse.self)
       }
                                             
    func getTables(areaId:Int) -> Observable<APIResponse> {
         return appServiceProvider.rx.request(
            .tables(
                branchId:ManageCacheObject.getCurrentBranch().id,
                area_id:areaId,
                status:status.value,
                exclude_table_id: order.value.table_id,
                order_statuses:"",
                buffet_ticket_id: view?.option == .mergeTable ? order.value.buffet_ticket_id : 0
            ))
                .filterSuccessfulStatusCodes()
                .mapJSON().asObservable()
                .showAPIErrorToast()
                .mapObject(type: APIResponse.self)
        }
    
    func mergeTable(target_table_ids:[Int]) -> Observable<APIResponse> {
        return appServiceProvider.rx.request(.mergeTable(
                branch_id: ManageCacheObject.getCurrentBranch().id,
                destination_table_id: order.value.table_id,
                target_table_ids: target_table_ids
            ))
               .filterSuccessfulStatusCodes()
               .mapJSON().asObservable()
               .showAPIErrorToast()
               .mapObject(type: APIResponse.self)
       }
    
    func moveTable(target_table_id:Int) -> Observable<APIResponse> {
        return appServiceProvider.rx.request(.moveTable(
            branch_id: ManageCacheObject.getCurrentBranch().id,
            destination_table_id: order.value.table_id,
            target_table_id: target_table_id))
               .filterSuccessfulStatusCodes()
               .mapJSON().asObservable()
               .showAPIErrorToast()
               .mapObject(type: APIResponse.self)
       }
                           
    
                                                                                      
}

//
//  AreaViewModel.swift
//  TechresOrder
//
//  Created by macmini_techres_03 on 14/01/2023.
//

import UIKit
import RxSwift
import RxRelay

class AreaViewModel {
    private(set) weak var view: AreaViewController?
    private var router: AreaRouter?
      
    public var table_array : BehaviorRelay<[Table]> = BehaviorRelay(value: [])
    public var area_array : BehaviorRelay<[Area]> = BehaviorRelay(value: [])

    var exclude_table_id = BehaviorRelay<Int>(value: 0)
    
    var table_id = BehaviorRelay<Int>(value: 0)

    
    func bind(view: AreaViewController, router: AreaRouter){
        self.view = view
        self.router = router
        self.router?.setSourceView(view)
    }
    
    
    func makeOrderDetailViewController(table:Table){
        router?.navigateToOrderDetailViewController(order:OrderDetail(table: table))
    }
    func makeNavigatorAddFoodViewController(table:Table){
        router?.navigateToAddFoodViewController(table: table) // Thêm biến area_id cho router gọi về AddFoodViewController
    }
    
 
}
extension AreaViewModel{
    func getAreas() -> Observable<APIResponse> {
        return appServiceProvider.rx.request(.areas(
            branch_id: ManageCacheObject.getCurrentBranch().id,
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
                    status:"",
                    exclude_table_id: exclude_table_id.value
                ))
                .filterSuccessfulStatusCodes()
                .mapJSON().asObservable()
                .showAPIErrorToast()
                .mapObject(type: APIResponse.self)
    }
    
    func closeTable() -> Observable<APIResponse> {
        return appServiceProvider.rx.request(.closeTable(table_id: table_id.value))
               .filterSuccessfulStatusCodes()
               .mapJSON().asObservable()
               .showAPIErrorToast()
               .mapObject(type: APIResponse.self)
    }
    
                                                                                      
}

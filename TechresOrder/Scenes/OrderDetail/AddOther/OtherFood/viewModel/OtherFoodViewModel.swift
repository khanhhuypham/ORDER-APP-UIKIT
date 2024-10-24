//
//  OtherFoodRebuildViewModel.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 06/12/2023.
//

import UIKit
import RxSwift
import RxRelay
class OtherFoodViewModel:BaseViewModel{

    private(set) weak var view: OtherFoodViewController?

    
    public var branch_id = BehaviorRelay<Int>(value: ManageCacheObject.getCurrentBranch().id)
    public var brand_id = BehaviorRelay<Int>(value: ManageCacheObject.getCurrentBrand().id)
    public var order = BehaviorRelay<OrderDetail>(value: OrderDetail())
    
    public var printers = BehaviorRelay<[Printer]>(value:[])
    public var otherFood = BehaviorRelay<OtherFoodRequest>(value: OtherFoodRequest())
    

    func bind(view: OtherFoodViewController){
        self.view = view

    }
}
extension OtherFoodViewModel{
    func getPrinterList() -> Observable<APIResponse> {
        return appServiceProvider.rx.request(.kitchenes(branch_id: branch_id.value, brand_id: brand_id.value, status:ACTIVE))
               .filterSuccessfulStatusCodes()
               .mapJSON().asObservable()
               .showAPIErrorToast()
               .mapObject(type: APIResponse.self)
    }
    

    
    func addOtherFoods() -> Observable<APIResponse> {
        return appServiceProvider.rx.request(.addOtherFoods(
                branch_id: branch_id.value,
                order_id: order.value.id,
                foods: otherFood.value))
               .filterSuccessfulStatusCodes()
               .mapJSON().asObservable()
               .showAPIErrorToast()
               .mapObject(type: APIResponse.self)
    }
}

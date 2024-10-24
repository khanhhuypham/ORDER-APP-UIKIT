//
//  OrderRebuildViewModel.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 16/01/2024.
//

import UIKit
import RxSwift
import RxRelay
class OrderRebuildViewModel: BaseViewModel {
    private(set) weak var view: OrderRebuildViewController?
    private var router: OrderRebuildRouter?

    public var dataArray : BehaviorRelay<[Order]> = BehaviorRelay(value: [])
    public var fullDataArray : BehaviorRelay<[Order]> = BehaviorRelay(value: [])
    public var selectedOrder = BehaviorRelay<Order?>(value: nil)
    
   
    
    public var APIParameter : BehaviorRelay<(
        branch_id:Int,
        userId: Int,
        order_status: String,
        key_word:String,
        is_take_away:Int
    )> = BehaviorRelay(value: (
        branch_id:ManageCacheObject.getCurrentBranch().id,
        userId: 0,
        order_status: "",
        key_word:"",
        is_take_away:(permissionUtils.GPBH_1 || permissionUtils.GPBH_2_o_1) ? ALL : DEACTIVE))

    
    func bind(view: OrderRebuildViewController, router: OrderRebuildRouter){
        self.view = view
        self.router = router
        self.router?.setSourceView(self.view)
    }
    
    func makeOrderDetailViewController(order:Order){
        router?.navigateToOrderDetailViewController(order: OrderDetail(order: order))
    }
    
    func makePayMentViewController(order:Order){
        router?.navigateToPayMentViewController(orderDetail:OrderDetail(order: order))
    }
    
    func makeScanBillViewController(order:Order){
        router?.navigateToQRCodeCashbackViewController(order_id: order.id, table_name: order.table_name)
    }
   
    func makeNavigatorAddFoodViewController(order:Order){
        router?.navigateToAddFoodViewController(order: OrderDetail(order: order), is_gift: ADD_GIFT)
    }
    func makeChooseEmployeeSharePointViewController(order:Order){
        router?.navigateToEmployeeSharePointViewController(order_id: order.id, table_name: order.table_name)
    }
    
    func makeGiftDetailViewController(){

    }
    
}

extension OrderRebuildViewModel{
    
    func updateCustomerNumberSlot(order:Order) -> Observable<APIResponse> {
        return appServiceProvider.rx.request(.updateCustomerNumberSlot(
            branch_id: APIParameter.value.branch_id,
            order_id:order.id,
            customer_slot_number:order.using_slot
        ))
           .filterSuccessfulStatusCodes()
           .mapJSON().asObservable()
           .showAPIErrorToast()
           .mapObject(type: APIResponse.self)
    }
    
    
    func getOrders() -> Observable<APIResponse> {
        return appServiceProvider.rx.request(.orders(
            userId: APIParameter.value.userId,
            order_status: APIParameter.value.order_status,
            key_word:APIParameter.value.key_word,
            branch_id:ManageCacheObject.getCurrentBranch().id,
            is_take_away:APIParameter.value.is_take_away
        ))
           .filterSuccessfulStatusCodes()
           .mapJSON().asObservable()
           .showAPIErrorToast()
           .mapObject(type: APIResponse.self)
    }
    
    func assignCustomerToBill(orderId:Int,qrValue:String) -> Observable<APIResponse> {
        return appServiceProvider.rx.request(.assignCustomerToBill(
            order_id: orderId,
            qr_code: qrValue
        ))
               .filterSuccessfulStatusCodes()
               .mapJSON().asObservable()
               .showAPIErrorToast()
               .mapObject(type: APIResponse.self)
    }
    
    func closeTable(order:Order) -> Observable<APIResponse> {
        return appServiceProvider.rx.request(.closeTable(table_id: order.table_id))
               .filterSuccessfulStatusCodes()
               .mapJSON().asObservable()
               .showAPIErrorToast()
               .mapObject(type: APIResponse.self)
    }
    
    func checkVersion() -> Observable<APIResponse> {
        return appServiceProvider.rx.request(.checkVersion)
               .filterSuccessfulStatusCodes()
               .mapJSON().asObservable()
               .showAPIErrorToast()
               .mapObject(type: APIResponse.self)
       }
    
}

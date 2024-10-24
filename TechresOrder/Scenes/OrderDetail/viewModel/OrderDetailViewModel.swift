//
//  OrderDetailRebuildViewModel.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 31/08/2023.
//

import UIKit
import RxSwift
import RxRelay
import ObjectMapper

class OrderDetailViewModel: BaseViewModel {
    private(set) weak var view: OrderDetailViewController?
    private var router: OrderDetailRouter?

    var branch_id = BehaviorRelay<Int>(value: Constants.branch.id)
    var is_gift = BehaviorRelay<Int>(value: 0)
    var order = BehaviorRelay<OrderDetail>(value: OrderDetail.init())
    public var foodsNeedToUpdate : BehaviorRelay<[FoodUpdate]> = BehaviorRelay(value: [])
    public var foodsNeedToSplit : BehaviorRelay<[OrderItem]> = BehaviorRelay(value: [])
    public var foodsNeedToPrint : BehaviorRelay<[Food]> = BehaviorRelay(value: [])
    

    public var payment = BehaviorRelay<Payment>(value: Payment())
    
    func bind(view: OrderDetailViewController, router: OrderDetailRouter){
        self.view = view
        self.router = router
        self.router?.setSourceView(view)
    }
    
    
    func makePopViewController(){
        router?.navigateToPopViewController()
        
    }
            
    func makeNavigatorAddFoodViewController(){    
        router?.navigateToAddFoodViewController(order: order.value,is_gift:is_gift.value)
    }
    
  
    func makeAddOtherViewController(){
        router?.navigateToAddOtherViewController(orderDetail: order.value)
    }
    
    
    func makePayMentViewController(is_take_away:Int){
        router?.navigateToPayMentViewController(order: order.value)
    }
    
        
}
extension OrderDetailViewModel{
    func getOrder() -> Observable<APIResponse> {
        return appServiceProvider.rx.request(.order(order_id: order.value.id, branch_id: branch_id.value))
               .filterSuccessfulStatusCodes()
               .mapJSON().asObservable()
               .showAPIErrorToast()
               .mapObject(type: APIResponse.self)
    }
    func getFoodBookingStatus() -> Observable<APIResponse> {
        return appServiceProvider.rx.request(.getFoodsBookingStatus(order_id: order.value.id))
               .filterSuccessfulStatusCodes()
               .mapJSON().asObservable()
               .showAPIErrorToast()
               .mapObject(type: APIResponse.self)
    }
    
    func addNoteToOrderDetail(orderDetailId:Int,note:String) -> Observable<APIResponse> {
        return appServiceProvider.rx.request(.addNoteToOrderDetail(branch_id: branch_id.value, order_detail_id:orderDetailId, note:note))
               .filterSuccessfulStatusCodes()
               .mapJSON().asObservable()
               .showAPIErrorToast()
               .mapObject(type: APIResponse.self)
    }
    
    func cancelFood(orderItem:OrderItem) -> Observable<APIResponse> {
        return appServiceProvider.rx.request(
            .cancelFood(branch_id: branch_id.value,
                        order_id: order.value.id,
                        reason: orderItem.cancel_reason,
                        order_detail_id: orderItem.id,
                        quantity: Int(orderItem.quantity)))
               .filterSuccessfulStatusCodes()
               .mapJSON().asObservable()
               .showAPIErrorToast()
               .mapObject(type: APIResponse.self)
    }
    
    func cancelExtraCharge(orderItem:OrderItem) -> Observable<APIResponse> {
        return appServiceProvider.rx.request(.cancelExtraCharge(
            branch_id: branch_id.value,
            order_id: order.value.id,
            reason: orderItem.cancel_reason,
            order_extra_charge: orderItem.id,
            quantity: Int(orderItem.quantity)))
               .filterSuccessfulStatusCodes()
               .mapJSON().asObservable()
               .showAPIErrorToast()
               .mapObject(type: APIResponse.self)
    }
    
    
    func cancelBuffetTicket(orderItem:OrderItem) -> Observable<APIResponse> {
        return appServiceProvider.rx.request(.postCancelBuffetTicket(id: orderItem.id))
               .filterSuccessfulStatusCodes()
               .mapJSON().asObservable()
               .showAPIErrorToast()
               .mapObject(type: APIResponse.self)
    }
    
    func updateFoods() -> Observable<APIResponse> {
        return appServiceProvider.rx.request(.updateFoods(
                branch_id: branch_id.value,
                order_id: order.value.id,
                foods: foodsNeedToUpdate.value))
               .filterSuccessfulStatusCodes()
               .mapJSON().asObservable()
               .showAPIErrorToast()
               .mapObject(type: APIResponse.self)
    }
    
 
    func getFoodsNeedPrint() -> Observable<APIResponse> {
        return appServiceProvider.rx.request(.foodsNeedPrint(order_id: order.value.id))
               .filterSuccessfulStatusCodes()
               .mapJSON().asObservable()
               .showAPIErrorToast()
               .mapObject(type: APIResponse.self)
    }
    
    func requestPrintChefBar(printType:Constants.printType) -> Observable<APIResponse> {
        return appServiceProvider.rx.request(.requestPrintChefBar(order_id: order.value.id, branch_id: branch_id.value, print_type: printType.value))
               .filterSuccessfulStatusCodes()
               .mapJSON().asObservable()
               .showAPIErrorToast()
               .mapObject(type: APIResponse.self)
    }
    
    func updateReadyPrinted(order_detail_ids:[Int]) -> Observable<APIResponse> {
        return appServiceProvider.rx.request(.updateReadyPrinted(order_id: order.value.id, order_detail_ids: order_detail_ids))
               .filterSuccessfulStatusCodes()
               .mapJSON().asObservable()
               .showAPIErrorToast()
               .mapObject(type: APIResponse.self)
    }
        
    func pauseService(orderDetailId:Int) -> Observable<APIResponse> {
        return appServiceProvider.rx.request(.postPauseService(order_id: order.value.id, branch_id: branch_id.value,order_detail_id: orderDetailId))
               .filterSuccessfulStatusCodes()
               .mapJSON().asObservable()
               .showAPIErrorToast()
               .mapObject(type: APIResponse.self)
    }
 
    

    func getSendToKitchen() -> Observable<APIResponse> {
        return appServiceProvider.rx.request(.getSendToKitchen(
            branch_id: branch_id.value,
            order_id: order.value.id
        ))
               .filterSuccessfulStatusCodes()
               .mapJSON().asObservable()
               .showAPIErrorToast()
               .mapObject(type: APIResponse.self)
    }
    
    
    func sendToKitchen(itemIds:[Int]) -> Observable<APIResponse> {
        return appServiceProvider.rx.request(.postSendToKitchen(
            branch_id: branch_id.value,
            order_id: order.value.id,
            item_ids: itemIds
        ))
               .filterSuccessfulStatusCodes()
               .mapJSON().asObservable()
               .showAPIErrorToast()
               .mapObject(type: APIResponse.self)
    }
    
    
    func discountOrderItem(item:OrderItem) -> Observable<APIResponse> {
        return appServiceProvider.rx.request(.postDiscountOrderItem(
            branch_id: branch_id.value,
            orderId: order.value.id,
            orderItem: item
        ))
           .filterSuccessfulStatusCodes()
           .mapJSON().asObservable()
           .showAPIErrorToast()
           .mapObject(type: APIResponse.self)
    }
    
    

}



//MARK: api get printItem for only GPBH2o1
extension OrderDetailViewModel{
    
    func getOrderNeedToPrintForGPBH_2o1() -> Observable<APIResponse> {
        return appServiceProvider.rx.request(.getPrintItem(
            type_print: 2,
            restaurant_id: Constants.restaurant_id,
            branch_id: Constants.branch.id))
               .filterSuccessfulStatusCodes()
               .mapJSON().asObservable()
               .showAPIErrorToast()
               .mapObject(type: APIResponse.self)
        
    }

}


//MARK: api payment and get bankAccount
extension OrderDetailViewModel{
    func completedPayment() -> Observable<APIResponse> {
        return appServiceProvider.rx.request(.completedPayment(
            branch_id: branch_id.value,
            order_id: order.value.id,
            cash_amount: payment.value.cash_amount,
            bank_amount: payment.value.bank_amount,
            transfer_amount:payment.value.transfer_amount,
            payment_method_id:payment.value.payment_method,
            tip_amount:payment.value.tip_amount))
               .filterSuccessfulStatusCodes()
               .mapJSON().asObservable()
               .showAPIErrorToast()
               .mapObject(type: APIResponse.self)
    }
    
    
    func getBrandBankAccount() -> Observable<APIResponse> {
        return appServiceProvider.rx.request(.getBrandBankAccount(
            order_id: order.value.id,
            brand_id: Constants.brand.id
        ))
        .filterSuccessfulStatusCodes()
        .mapJSON().asObservable()
        .showAPIErrorToast()
        .mapObject(type: APIResponse.self)
    }
    
}

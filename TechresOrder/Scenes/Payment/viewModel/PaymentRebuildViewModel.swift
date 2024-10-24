//
//  PaymentRebuildViewModel.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 23/10/2023.
//


import UIKit
import RxSwift
import RxRelay
class PaymentRebuildViewModel: NSObject {
    private(set) weak var view: PaymentRebuildViewController?
    private var router: PaymentRebuildRouter?

    
    var order = BehaviorRelay<OrderDetail>(value: OrderDetail.init())
    var branch_id = BehaviorRelay<Int>(value: ManageCacheObject.getCurrentBranch().id)
    
    var paymentMethod = BehaviorRelay<Int>(value: Constants.PAYMENT_METHOD.CASH)
    var payment = BehaviorRelay<Payment>(value: Payment())
    var itemsNeedToPrint = BehaviorRelay<[Food]>(value: [])
    
    

    func bind(view: PaymentRebuildViewController, router: PaymentRebuildRouter){
        self.view = view
        self.router = router
        self.router?.setSourceView(self.view)
    }
     
     func makePopViewController(){
         router?.navigateToPopViewController()
         
     }
     
    func makeOrderHistoryViewController(){
        var order = Order()!
        order.id = self.order.value.id
        router?.navigateToOrderHistoryViewController(order: order)
    }
}

extension PaymentRebuildViewModel{
    
    
    func applyExtraChargeOnTotalBill() -> Observable<APIResponse> {
        return appServiceProvider.rx.request(.postApplyExtraChargeOnTotalBill(order_id: order.value.id, branch_id: branch_id.value, total_amount_extra_charge_percent: order.value.total_amount_extra_charge_percent))
               .filterSuccessfulStatusCodes()
               .mapJSON().asObservable()
               .showAPIErrorToast()
               .mapObject(type: APIResponse.self)
    }
    
    
    func applyDiscount() -> Observable<APIResponse> {
        return appServiceProvider.rx.request(.discount(
                                        order_id:order.value.id,
                                        branch_id:branch_id.value,
                                        food_discount_percent:0,
                                        drink_discount_percent:0,
                                        total_amount_discount_percent:0,
                                        note:""))
               .filterSuccessfulStatusCodes()
               .mapJSON().asObservable()
               .showAPIErrorToast()
               .mapObject(type: APIResponse.self)
    }
    
    func getOrderDetail() -> Observable<APIResponse> {
        let is_print_bill = ACTIVE
        let food_status = String(format: "%d,%d,%d",FOOD_STATUS.pending.rawValue, FOOD_STATUS.cooking.rawValue, FOOD_STATUS.done.rawValue)
        return appServiceProvider.rx.request(.getOrderDetail(order_id: order.value.id, branch_id: branch_id.value, is_print_bill:is_print_bill, food_status:food_status))
               .filterSuccessfulStatusCodes()
               .mapJSON().asObservable()
               .showAPIErrorToast()
               .mapObject(type: APIResponse.self)
    }
    
    func updateCustomerNumberSlot() -> Observable<APIResponse> {
        return appServiceProvider.rx.request(.updateCustomerNumberSlot( branch_id: branch_id.value, order_id: order.value.id, customer_slot_number:order.value.customer_slot_number))
               .filterSuccessfulStatusCodes()
               .mapJSON().asObservable()
               .showAPIErrorToast()
               .mapObject(type: APIResponse.self)
       }
    
    func requestPayment(paymentMethod:Int) -> Observable<APIResponse> {
        return appServiceProvider.rx.request(.requestPayment(branch_id: branch_id.value, order_id: order.value.id, payment_method:paymentMethod, is_include_vat:order.value.is_apply_vat))
               .filterSuccessfulStatusCodes()
               .mapJSON().asObservable()
               .showAPIErrorToast()
               .mapObject(type: APIResponse.self)
    }
    
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
    
    func applyVAT(applyVAT:Int) -> Observable<APIResponse> {
        return appServiceProvider.rx.request(.applyVAT(branch_id: branch_id.value, order_id: order.value.id, is_apply_vat:applyVAT))
               .filterSuccessfulStatusCodes()
               .mapJSON().asObservable()
               .showAPIErrorToast()
               .mapObject(type: APIResponse.self)
    }
    //MARK: API lấy danh sách món in
    func getFoodsNeedPrint() -> Observable<APIResponse> {
        return appServiceProvider.rx.request(.foodsNeedPrint(order_id: order.value.id))
               .filterSuccessfulStatusCodes()
               .mapJSON().asObservable()
               .showAPIErrorToast()
               .mapObject(type: APIResponse.self)
    }
    
    //MARK: API gửi in bếp
    func updateReadyPrinted(order_detail_ids:[Int]) -> Observable<APIResponse> {
        return appServiceProvider.rx.request(.updateReadyPrinted(order_id: order.value.id, order_detail_ids: order_detail_ids))
               .filterSuccessfulStatusCodes()
               .mapJSON().asObservable()
               .showAPIErrorToast()
               .mapObject(type: APIResponse.self)
    }
    
    //MARK: API gửi in bếp. API này chỉ sử dụng cho GPBH2o2, vì GPBH2o2 print trực tiếp qua máy thu ngân nên ta sẽ gọi API này để gửi tín hiệu SERVER, sau đó server sẽ gửi tín hiệu qua cho WINDOWN để thực hiện quá trình print
    func requestPrintChefBar(printType:Constants.printType) -> Observable<APIResponse> {
        return appServiceProvider.rx.request(.requestPrintChefBar(order_id: order.value.id, branch_id: branch_id.value, print_type:printType.value))
               .filterSuccessfulStatusCodes()
               .mapJSON().asObservable()
               .showAPIErrorToast()
               .mapObject(type: APIResponse.self)
    }
    
    func getFoodsNeedReview() -> Observable<APIResponse> {
        return appServiceProvider.rx.request(.getFoodsNeedReview(branch_id:branch_id.value,order_id: order.value.id))
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




//MARK: api get printItem for only GPBH2o1
extension PaymentRebuildViewModel{
    
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

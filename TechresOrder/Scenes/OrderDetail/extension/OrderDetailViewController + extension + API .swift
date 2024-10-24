//
//  OrderDetailRebuildViewController + extension.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 31/08/2023.
//

import UIKit
import ObjectMapper
import RxSwift
import JonAlert
extension OrderDetailViewController{
    //MARK: API lấy thông tin chi tiết đơn hàng
    func getOrder(){
        viewModel.getOrder().subscribe(onNext: { (response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){
        
                if var order = Mapper<OrderDetail>().map(JSONObject: response.data){
                    order.is_take_away = self.order.is_take_away
                    order.order_details.removeAll(where: {($0.category_type == .drink || $0.category_type == .other) && $0.quantity == 0})
                    self.viewModel.order.accept(order)
                    self.mapData(order: order)
                    
                    self.view_action.isHidden = order.status == ORDER_STATUS_COMPLETE || order.status == ORDER_STATUS_WAITING_WAITING_COMPLETE ? true : false
                    
                    //Nếu bàn booking thì sẽ lấy thêm các món ăn
                    if (order.booking_status == STATUS_BOOKING_SET_UP){
                        self.getFoodBookingStatus()
                    }
                    
                    
                    if permissionUtils.GPBH_2 || permissionUtils.GPBH_1{
                        
                        permissionUtils.GPBH_2_o_1 
                        ? self.getOrderNeedToPrintFor2o1()
                        : self.getFoodsNeedPrint()
                      
                    }else if permissionUtils.GPBH_3 && ManageCacheObject.getPaymentMethod().is_enable_send_to_kitchen_request == ACTIVE {
                        self.getItemNeedToSendToKitchen()
                    }
                    
                }
            }
            
        }).disposed(by: rxbag)
    }
    
    //MARK: API lấy thông tin trạng thái booking
    func getFoodBookingStatus(){
        viewModel.getFoodBookingStatus().subscribe(onNext: { (response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){
                if var bookingItems = Mapper<OrderItem>().mapArray(JSONObject: response.data){
                    
                    bookingItems.enumerated().forEach{(i,_) in
                        bookingItems[i].is_booking_item = ACTIVE
                    }
                    
                    var order = self.viewModel.order.value
                    order.order_details = bookingItems + order.order_details 
                    self.viewModel.order.accept(order)
                    
                }
            }
        }).disposed(by: rxbag)
        
    }
    

    //MARK: API huỷ món ăn
    public func handleCancelFood(item:OrderItem) {
    
        switch item.status {
            case .done:
                
                switch item.category_type {
                    case .buffet_ticket:
                        permissionUtils.BuffetManager
                        ? presentModalCancelFoodViewController(orderItem: item)
                        : showWarningMessage(content: "Bạn chưa được cấp quyền sử dụng tính năng này vui lòng liên hệ quản lý")
                     
                    
                    default:
                        Utils.checkRoleCancelFoodCompleted(permission: ManageCacheObject.getCurrentUser().permissions)
                        ? presentModalCancelFoodViewController(orderItem: item)
                        : JonAlert.showError(message: "Bạn chưa được cấp quyền sử dụng tính năng này vui lòng liên hệ quản lý", duration: 2.0)
                }
            

            default:
                presentModalCancelFoodViewController(orderItem: item)
        }

    }
    
    

    
    //MARK: API thêm ghi chú cho món ăn
    func addNoteToFood(orderDetailId:Int,note:String){
        viewModel.addNoteToOrderDetail(orderDetailId: orderDetailId, note: note).subscribe(onNext: { (response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){
                JonAlert.showSuccess(message:  "Cập nhật ghi chú thành công", duration: 2.0)
                self.getOrder()
            }else{
                JonAlert.showError(message:response.message ?? "", duration: 3.0)
                dLog(response.message ?? "")
            }
        }).disposed(by: rxbag)
        
    }
    
    
    
    
    //MARK: API Huỷ món
    func cancelFood(item:OrderItem){
        viewModel.cancelFood(orderItem: item).subscribe(onNext: { (response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){
                
            }else{
                JonAlert.showError(message:response.message ?? "", duration: 3.0)
            }
        }).disposed(by: rxbag)
        
    }
    
    //MARK: API cancel buffet ticket
    public func cancelBuffetTicket(item:OrderItem) {
    
        viewModel.cancelBuffetTicket(orderItem: item).subscribe(onNext: { (response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){

            }else{
                JonAlert.showError(message:response.message ?? "", duration: 3.0)
            }
        }).disposed(by: rxbag)

    }
    
    
    //MARK: API Huỷ món có kèm phụ thu
    func cancelExtraCharge(item:OrderItem){
        viewModel.cancelExtraCharge(orderItem: item).subscribe(onNext: { (response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){

            }else{
                JonAlert.showError(message:response.message ?? "", duration: 3.0)
            }
        }).disposed(by: rxbag)
        
    }

    func getFoodsNeedPrint(print:Bool = false){
        
        viewModel.getFoodsNeedPrint().subscribe(onNext: { [self] (response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){
   
                if let printItem = Mapper<Food>().mapArray(JSONObject: response.data){
                 
                    let pendingItem = printItem.filter{$0.status == PENDING}
                    let cancelItem = printItem.filter{$0.status == CANCEL_FOOD}
                    let returnedItem = printItem.filter{$0.category_type == .drink && $0.return_quantity_for_drink > 0}
                    
                    if pendingItem.count > 0 && print{
                        permissionUtils.GPBH_2_o_2
                        ? requestPrintChefBar(printType: .new_item)
                        : printItems(items:pendingItem,printType: .new_item)
                    }
                    
                    if cancelItem.count > 0{
                        permissionUtils.GPBH_2_o_2
                        ? requestPrintChefBar(printType: .cancel_item)
                        : printItems(items: cancelItem,printType: .cancel_item)
                    }
                    
                    
                    if returnedItem.count > 0{
                        permissionUtils.GPBH_2_o_2
                        ? requestPrintChefBar(printType: .return_item)
                        : printItems(items: returnedItem,printType: .return_item)
                    } 
                    
                    viewModel.foodsNeedToPrint.accept(pendingItem)
                    
                }
            }
        }).disposed(by: rxbag)
    }
    
    

    func requestPrintChefBar(printType:Constants.printType){
        viewModel.requestPrintChefBar(printType:printType).subscribe(onNext: { (response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){

                self.showSuccessMessage(content: "Gửi bếp bar thành công")
            
            }else{
                JonAlert.showError(message: response.message ?? "Có lỗi xảy ra trong quá trình kết nối tới máy chủ. Vui lòng thử lại.", duration: 3.0)
            }
        }).disposed(by: rxbag)
        
    }
    
    func updateReadyPrinted(order_detail_ids:[Int]){
        viewModel.updateReadyPrinted(order_detail_ids:order_detail_ids).subscribe(onNext: { (response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){
                self.getOrder()
            }else{
                JonAlert.showError(message: response.message ?? "Có lỗi xảy ra trong quá trình kết nối tới máy chủ. Vui lòng thử lại.", duration: 3.0)
            }
        }).disposed(by: rxbag)
        
    }
    
    func updateFoodsToOrder(){
        viewModel.updateFoods().subscribe(onNext: { (response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){
                self.viewModel.foodsNeedToUpdate.accept([])
                self.lbl_number_need_to_update.text = "0"
            }else{
                JonAlert.showError(message: response.message ?? "Có lỗi xảy ra trong quá trình kết nối tới máy chủ. Vui lòng thử lại.", duration: 3.0)
            }
        }).disposed(by: rxbag)
        
    }
    
    
    
    
    func pauseService(orderDetailId:Int){
        viewModel.pauseService(orderDetailId: orderDetailId).subscribe(onNext: { [self] (response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){
                getOrder()
            }else{
                JonAlert.showError(message: response.message ?? "", duration: 2.0)
            }
        }).disposed(by: rxbag)
    }
    
   
    func getItemNeedToSendToKitchen(send:Bool = false) {
        //CALL API COMPLETED ORDER
        viewModel.getSendToKitchen().subscribe(onNext: { [self] (response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){
                if let items = Mapper<Food>().mapArray(JSONObject: response.data){

                    viewModel.foodsNeedToPrint.accept(items)
                    
                    if send{
                        sendItemsToKitchen(itemIds: items.map{$0.id})
                    }
                }
                
            }else{
                JonAlert.showError(message: response.message ?? "", duration: 2.0)
            }
        }).disposed(by: rxbag)
    }
    
    func sendItemsToKitchen(itemIds:[Int]) {
        //CALL API COMPLETED ORDER
        viewModel.sendToKitchen(itemIds: itemIds).subscribe(onNext: { [self] (response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){
                JonAlert.showSuccess(message: "Gửi thành công", duration: 2.0)
                getOrder()
            }else{
                JonAlert.showError(message: response.message ?? "", duration: 2.0)
            }
        }).disposed(by: rxbag)
    }
    
    
    func discountOrderItem(item:OrderItem) {
        //CALL API COMPLETED ORDER
        viewModel.discountOrderItem(item: item).subscribe(onNext: { [self] (response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){
                JonAlert.showSuccess(message: "Giảm giá thành công", duration: 2.0)
                getOrder()
            }else{
                JonAlert.showError(message: response.message ?? "", duration: 2.0)
            }
        }).disposed(by: rxbag)
    }

    
}

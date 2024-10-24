//
//  OrderRebuildViewController + extension.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 16/01/2024.
//

import UIKit
import ObjectMapper

extension OrderRebuildViewController{
    func setupSocketIO(){
        // socket io here
        let namespace = String(format: "/restaurants_%d_branches_%d", ManageCacheObject.getCurrentBrand().id, ManageCacheObject.getCurrentBranch().id)
        
        SocketIOManager.shared().initSocketInstance(namespace)
        SocketIOManager.shared().establishConnection()
        
        SocketIOManager.shared().socketRealTime?.on("connect") {data, ack in
            
            self.real_time_url = String(format: "%@/%d/%@/%d/%@","restaurants", ManageCacheObject.getCurrentUser().restaurant_id,"branches", ManageCacheObject.getCurrentBranch().id,"orders")
            
            SocketIOManager.shared().socketRealTime!.emit("join_room", self.real_time_url)
            
            SocketIOManager.shared().socketRealTime!.on(self.real_time_url) {data, ack in
                let order = Mapper<Order>().map(JSONObject: data[0])!
                if(order.order_status == ORDER_STATUS_WAITING_MERGED){
                    self.fetchOrders()
                }else{
                    self.updateOrderInArray(order: order)
                }
                
            }
        }
        
    }
    
    func updateOrderInArray(order:Order) {
        var list_orders = self.viewModel.dataArray.value
        
        if list_orders.first(where: { $0.id == order.id }) != nil {
            //do something
            if(list_orders.count > 0 ){
                //phần tử nào hiện đã được thanh toán thì xoá khỏi list_order (danh sách hiển thị local)
                list_orders.removeAll { $0.order_status == ORDER_STATUS_COMPLETE }
                for i in 0..<list_orders.count {
                    
                        if(list_orders[i].id == order.id){
                            debugPrint(String(format: "order.total_order_detail_customer_request: %d", order.total_order_detail_customer_request))
                            switch order.order_status {
                            case ORDER_STATUS_OPENING:
                                dLog(i)
                                list_orders.remove(at: i)
                                list_orders.insert(order, at: i)
                                break
                            case ORDER_STATUS_REQUEST_PAYMENT:
                                dLog(i)
                                list_orders.remove(at: i)
                                list_orders.insert(order, at: 0)//sort order to top list
                                break
                            case ORDER_STATUS_WAITING_WAITING_COMPLETE:
                                dLog(i)
                                list_orders.remove(at: i)
                                list_orders.insert(order, at: 0)//sort order to top list
                                break
                            case ORDER_STATUS_COMPLETE:
                                dLog(i)
                                //                            list_orders.remove(at: i)//remove order done out array
                                list_orders[i].order_status = ORDER_STATUS_COMPLETE
//                                list_orders.removeAll { $0.id == order.id }
                                break
                            case ORDER_STATUS_WAITING_MERGED:
                                dLog(i)
                                list_orders.remove(at: i)//remove order done out array
                                break
                            default:
                                list_orders.remove(at: i)
                                list_orders.insert(order, at: i)
                                
                            }
                    }
                }
            }
          
        }else{
            list_orders.insert(order, at: list_orders.count)
        }
        //xoá bỏ dữ liệu cũ đã lưu
        self.viewModel.dataArray.accept(list_orders)
        //giải pháp có thể dùng tạm - nhưng khả năng realtime giảm
//        dLog(list_orders.toJSON())
    }
    
}

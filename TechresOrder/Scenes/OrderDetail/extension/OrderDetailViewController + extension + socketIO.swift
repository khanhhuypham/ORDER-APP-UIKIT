//
//  OrderDetailRebuildViewController + extension + socketIO.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 01/09/2023.
//

import UIKit

extension OrderDetailViewController{
//    func setupSocketIO() {
//        // socket io here
//        let namespace = String(format: "/restaurants_%d_branches_%d", ManageCacheObject.getCurrentUser().restaurant_id, ManageCacheObject.getCurrentUser().branch_id)
//        let real_time_url = String(format: "restaurants/%d/branches/%d/orders/%d",
//                                    ManageCacheObject.getCurrentUser().restaurant_id,
//                                    ManageCacheObject.getCurrentUser().branch_id,
//                                    viewModel.order.value.id)
//        
//        SocketIOManager.shareSocketRealtimeInstance().initSocketInstance("")
//        SocketIOManager.shareSocketRealtimeInstance().socketRealTime?.on("connect") {data, ack in
//            
//            SocketIOManager.shareSocketRealtimeInstance().socketRealTime!.on("joinned_room") {data, ack in
//                
//                dLog("pham khanh huy")
//            }
//
//            SocketIOManager.shareSocketRealtimeInstance().socketRealTime!.on(real_time_url) {data, ack in
//                
//                self.getOrder()
//            }
//            
//            SocketIOManager.shareSocketRealtimeInstance().socketRealTime!.emit("join_room", real_time_url)
//            
//            SocketIOManager.shareSocketRealtimeInstance().socketRealTime!.on("joinned_room") {data, ack in
//                
//                dLog("pham khanh huy")
//            }
//            
//        }
//        SocketIOManager.shareSocketRealtimeInstance().socketRealTime?.connect()
//    }
    
    
    func setupSocketIO() {
            // socket io here
            let namespace = String(format: "/restaurants_%d_branches_%d", ManageCacheObject.getCurrentBrand().id, ManageCacheObject.getCurrentBranch().id)
        
            let real_time_url = String(format: "restaurants/%d/branches/%d/orders/%d",
                                            ManageCacheObject.getCurrentUser().restaurant_id,
                                            ManageCacheObject.getCurrentBranch().id,
                                            viewModel.order.value.id
            )
           
        
            SocketIOManager.shared().initSocketInstance(namespace)
            SocketIOManager.shared().establishConnection()
            
            SocketIOManager.shared().socketRealTime?.on("connect") {data, ack in
               
                SocketIOManager.shared().socketRealTime!.emit("join_room", real_time_url)
                
                SocketIOManager.shared().socketRealTime!.on(real_time_url) {data, ack in
           
                    self.getOrder()
                    
                }
               
            }
    }
    
}

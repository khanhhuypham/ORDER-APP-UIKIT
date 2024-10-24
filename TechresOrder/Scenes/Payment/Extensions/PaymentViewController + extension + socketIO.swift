//
//  PaymentRebuildViewController + extension + socketIO.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 25/10/2023.
//

import UIKit

extension PaymentRebuildViewController {
    func setupSocketIO() {
        // socket io here
        let namespace = String(format: "/restaurants_%d_branches_%d", ManageCacheObject.getCurrentBrand().id, ManageCacheObject.getCurrentBranch().id)
        SocketIOManager.shared().initSocketInstance(namespace)

        SocketIOManager.shared().socketRealTime?.on("connect") {data, ack in
            self.real_time_url = String(format: "restaurants/%d/branches/%d/orders/%d",
                                ManageCacheObject.getCurrentUser().restaurant_id,
                                ManageCacheObject.getCurrentBranch().id,
                                self.order.id
            )
                    
            SocketIOManager.shared().socketRealTime!.emit("join_room", self.real_time_url)
            

            SocketIOManager.shared().socketRealTime!.on(self.real_time_url) {data, ack in
                self.getOrderDetail()
            }
        }

    }
    
    
    
    

}

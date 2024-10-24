//
//  EditBuffetTicketViewModel.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 09/05/2024.
//

import UIKit
import RxSwift
import RxRelay

class EditBuffetTicketViewModel: NSObject {
    
    private(set) weak var view: EditBuffetTicketViewController?
 
    var buffet = BehaviorRelay<Buffet>(value: Buffet())
    var ticketChildren = BehaviorRelay<[BuffetTicketChild]>(value:[])
    
    func bind(view: EditBuffetTicketViewController){
        self.view = view
    }
    
    func updateBuffetTickets(buffet:Buffet,orderId:Int) -> Observable<APIResponse> {
        return appServiceProvider.rx.request(
            .postUpdateBuffetTicket(
                branch_id:Constants.branch.id,
                order_Id: orderId,
                buffet: buffet
            ))
               .filterSuccessfulStatusCodes()
               .mapJSON().asObservable()
               .showAPIErrorToast()
               .mapObject(type: APIResponse.self)
    }
    
   
   
}

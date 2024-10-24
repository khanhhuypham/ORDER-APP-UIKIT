//
//  OrderDetailRebuildRouter.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 31/08/2023.
//

import UIKit

class OrderDetailRouter: NSObject {
    var viewController: UIViewController{
        return createViewController()
    }
    
    private var sourceView:UIViewController?
    
    private func createViewController()-> UIViewController {
        let view = OrderDetailViewController(nibName: "OrderDetailViewController", bundle: Bundle.main)
        return view
    }
    
    func setSourceView(_ sourceView:UIViewController?){
        guard let view = sourceView else {fatalError("Error Desconocido")}
        self.sourceView = view
    }
    
    func navigateToPopViewController(){
       sourceView?.navigationController?.popViewController(animated: true)
    }
    
    func navigateToAddOtherViewController(orderDetail:OrderDetail){
        let vc = AddOtherRouter().viewController as! AddOtherViewController
        vc.orderDetail = orderDetail
        sourceView?.navigationController?.pushViewController(vc, animated: true)
    }
    

    
    func navigateToAddFoodViewController(order:OrderDetail,is_gift:Int){
        let addFoodViewController = AddFoodRouter().viewController as! AddFoodViewController
        addFoodViewController.order = order
        addFoodViewController.is_gift = is_gift
        sourceView?.navigationController?.pushViewController(addFoodViewController, animated: true)
    }
    
    
    func navigateToPayMentViewController(order: OrderDetail){
        let vc = PaymentRebuildRouter().viewController as! PaymentRebuildViewController
        vc.order = order
        sourceView?.navigationController?.pushViewController(vc, animated: true)
        
    }
    

    
}

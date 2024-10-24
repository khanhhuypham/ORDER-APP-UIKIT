//
//  OrderManagementRouter.swift
//  TechresOrder
//
//  Created by Kelvin on 25/01/2023.
//

import UIKit

class OrderManagementRouter {
    var viewController: UIViewController{
        return createViewController()
    }
    
    private var sourceView:UIViewController?
    
    private func createViewController()-> UIViewController {
        let view = OrderManagementViewController(nibName: "OrderManagementViewController", bundle: Bundle.main)
        return view
    }
    
    func setSourceView(_ sourceView:UIViewController?){
        guard let view = sourceView else {fatalError("Error Desconocido")}
        self.sourceView = view
    }
    
    func navigateToOrderDetailViewController(order:OrderDetail){
        let orderDetailViewController = OrderDetailRouter().viewController as! OrderDetailViewController
        orderDetailViewController.order = order
        sourceView?.navigationController?.pushViewController(orderDetailViewController, animated: true)
    }
    
    func navigateToPayMentViewController(order: OrderDetail){
        let vc = PaymentRebuildRouter().viewController as! PaymentRebuildViewController
        vc.order = order
        sourceView?.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    func navigateToPopViewController(){
        sourceView?.navigationController?.popViewController(animated: true)
    }
    
}

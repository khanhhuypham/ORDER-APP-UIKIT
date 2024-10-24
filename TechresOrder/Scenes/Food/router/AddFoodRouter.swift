//
//  AddFood_RebuildRouter.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 06/09/2023.
//

import UIKit

class AddFoodRouter {
    var viewController: UIViewController{
        return createViewController()
    }
    
    private var sourceView:UIViewController?
    
    private func createViewController()-> UIViewController {
        let view = AddFoodViewController(nibName: "AddFoodViewController", bundle: Bundle.main)
        return view
    }
    
    func setSourceView(_ sourceView:UIViewController?){
        guard let view = sourceView else {fatalError("Error Desconocido")}
        self.sourceView = view
    }
    
    func navigateToOrderDetailViewController(order:OrderDetail){
        let vc = OrderDetailRouter().viewController as! OrderDetailViewController
        vc.order = order
        sourceView?.navigationController?.pushViewController(vc, animated: true)
    }
    
    
//    func navigateToOrderDetailViewController(order_id : Int, table_name:String = "",is_take_away:Int){
//        let orderDetailViewController = OrderDetailRouter().viewController as! OrderDetailViewController
//        orderDetailViewController.order_id = order_id
//        orderDetailViewController.table_name = table_name
//        orderDetailViewController.is_take_away = is_take_away
//        sourceView?.navigationController?.pushViewController(orderDetailViewController, animated: true)
//    }
    func navigateToPopViewController(){
        sourceView?.navigationController?.popViewController(animated: true)
    }
}

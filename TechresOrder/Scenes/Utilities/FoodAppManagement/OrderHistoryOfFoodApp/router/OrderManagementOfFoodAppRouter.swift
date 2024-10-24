//
//  OrderManagementOfFoodAppRouter.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 20/08/2024.
//

import UIKit

class OrderManagementOfFoodAppRouter {
    var viewController: UIViewController{
        return createViewController()
    }
    
    private var sourceView:UIViewController?
    
    private func createViewController()-> UIViewController {
        let view = OrderManagementOfFoodAppViewController(nibName: "OrderManagementOfFoodAppViewController", bundle: Bundle.main)
        return view
    }
    
    func setSourceView(_ sourceView:UIViewController?){
        guard let view = sourceView else {fatalError("Error Desconocido")}
        self.sourceView = view
    }
    func navigateToPopViewController(){
        sourceView?.navigationController?.popViewController(animated: true)
    }
    
    func navigateToOrderHistoryDetailOfFoodAppViewController(order:FoodAppOrder){
        let vc = OrderHistoryDetailOfFoodAppRouter().viewController as! OrderHistoryDetailOfFoodAppViewController
        vc.order = order
        sourceView?.navigationController?.pushViewController(vc, animated: true)

    }
    
   
}

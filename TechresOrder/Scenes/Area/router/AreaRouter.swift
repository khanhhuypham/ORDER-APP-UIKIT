//
//  AreaRouter.swift
//  TechresOrder
//
//  Created by macmini_techres_03 on 14/01/2023.
//

import UIKit

class AreaRouter {
    
    var viewController: UIViewController{
        return createViewController()
    }
    
    private var sourceView:UIViewController?
    
    private func createViewController()-> UIViewController {
        let view = AreaViewController(nibName: "AreaViewController", bundle: Bundle.main)
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
    
    
    
    func navigateToAddFoodViewController(table:Table){
        let vc = AddFoodRouter().viewController as! AddFoodViewController        
        vc.order = OrderDetail(table: table)
        sourceView?.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
}

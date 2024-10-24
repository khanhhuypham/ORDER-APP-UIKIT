//
//  TechresShopRouter.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 05/09/2024.
//

import UIKit

class TechresShopRouter: NSObject {
    var viewController: UIViewController{
        return createViewController()
    }
    
    private var sourceView:UIViewController?
    
    private func createViewController()-> UIViewController {
        let view = TechresShopViewController(nibName: "TechresShopViewController", bundle: Bundle.main)
        return view
    }
    
    func setSourceView(_ sourceView:UIViewController?){
        guard let view = sourceView else {fatalError("Error Desconocido")}
        self.sourceView = view
    }
    func navigateToPopViewController(){
        sourceView?.navigationController?.popViewController(animated: true)
    }
    
//    func navigateToFoodAppLoginViewController(partner:FoodAppAPartner){
//        let vc = AppFoodLoginRouter().viewController as! AppFoodLoginViewController
//        vc.partner = partner
//        sourceView?.navigationController?.pushViewController(vc, animated: true)
//    }
}

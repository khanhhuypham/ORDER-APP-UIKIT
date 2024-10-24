//
//  AppFoodRouter.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 29/07/2024.
//

import UIKit


class AppFoodRouter {
    var viewController: UIViewController{
        return createViewController()
    }
    
    private var sourceView:UIViewController?
    
    private func createViewController()-> UIViewController {
        let view = AppFoodViewController(nibName: "AppFoodViewController", bundle: Bundle.main)
        return view
    }
    
    func setSourceView(_ sourceView:UIViewController?){
        guard let view = sourceView else {fatalError("Error Desconocido")}
        self.sourceView = view
    }
    func navigateToPopViewController(){
        sourceView?.navigationController?.popViewController(animated: true)
    }
//    
//    func navigateToFoodAppLoginViewController(partner:FoodAppAPartner){
//        let vc = AppFoodLoginRouter().viewController as! AppFoodLoginViewController
//        vc.partner = partner
//        sourceView?.navigationController?.pushViewController(vc, animated: true)
//    }
    
    
    func navigateToTokenListOfFoodAppViewController(partner:FoodAppAPartner){
        let vc = TokenListOfFoodAppRouter().viewController as! TokenListOfFoodAppViewController
        vc.partner = partner
        sourceView?.navigationController?.pushViewController(vc, animated: true)
    }
}

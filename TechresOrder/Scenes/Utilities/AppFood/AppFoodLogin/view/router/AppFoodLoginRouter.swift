//
//  AppFoodLoginRouter.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 29/07/2024.
//

import UIKit


class AppFoodLoginRouter {
    var viewController: UIViewController{
        return createViewController()
    }
    
    private var sourceView:UIViewController?
    
    private func createViewController()-> UIViewController {
        let view = AppFoodLoginViewController(nibName: "AppFoodLoginViewController", bundle: Bundle.main)
        return view
    }
    
    func setSourceView(_ sourceView:UIViewController?){
        guard let view = sourceView else {fatalError("Error Desconocido")}
        self.sourceView = view
    }
    func navigateToPopViewController(){
        sourceView?.navigationController?.popViewController(animated: true)
    }
    
   
}

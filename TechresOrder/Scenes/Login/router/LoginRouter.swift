//
//  LoginRouter.swift
//  TechresOrder
//
//  Created by macmini_techres_03 on 12/01/2023.
//

import UIKit

class LoginRouter {
    var viewController: UIViewController{
        return createViewController()
    }
    
    private var sourceView:UIViewController?
    
    private func createViewController()-> UIViewController {
        let view = LoginViewController(nibName: "LoginViewController", bundle: Bundle.main)
        return view
    }
    
    func setSourceView(_ sourceView:UIViewController?){
        guard let view = sourceView else {fatalError("Error Desconocido")}
        self.sourceView = view
    }
    
    
    func navigateToResetPasswordViewController(){
        let resetPasswordViewController = ResetPasswordRouter().viewController as! ResetPasswordViewController
        sourceView?.navigationController?.pushViewController(resetPasswordViewController, animated: true)
    }
    
}

//
//  VerifyOTPRouter.swift
//  TechresOrder
//
//  Created by Kelvin on 24/02/2023.
//

import UIKit

class VerifyOTPRouter {
    var viewController: UIViewController{
        return createViewController()
    }
    
    private var sourceView:UIViewController?
    
    private func createViewController()-> UIViewController {
        let view = VerifyOTPViewController(nibName: "VerifyOTPViewController", bundle: Bundle.main)
        return view
    }
    
    func setSourceView(_ sourceView:UIViewController?){
        guard let view = sourceView else {fatalError("Error Desconocido")}
        self.sourceView = view
    }
    
    
    func navigateToPopViewController(){
       sourceView?.navigationController?.dismiss(animated: true)
    }
    
    func navigateToVerifyPasswordViewController(username:String, otp_code:String){
        let verifyPasswordViewController = VerifyPasswordRouter().viewController as! VerifyPasswordViewController
        verifyPasswordViewController.username = username
        verifyPasswordViewController.otp_code = otp_code
        sourceView?.navigationController?.pushViewController(verifyPasswordViewController, animated: true)
    }
    
    func navigateToLoginViewController(){
        let loginViewController = LoginRouter().viewController as! LoginViewController
        sourceView?.navigationController?.pushViewController(loginViewController, animated: true)
    }
}

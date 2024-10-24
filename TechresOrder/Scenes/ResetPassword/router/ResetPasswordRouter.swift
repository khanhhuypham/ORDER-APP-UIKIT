//
//  ResetPasswordRouter.swift
//  TechresOrder
//
//  Created by Kelvin on 21/02/2023.
//

import UIKit

class ResetPasswordRouter {
    var viewController: UIViewController{
        return createViewController()
    }
    
    private var sourceView:UIViewController?
    
    private func createViewController()-> UIViewController {
        let view = ResetPasswordViewController(nibName: "ResetPasswordViewController", bundle: Bundle.main)
        return view
    }
    
    func setSourceView(_ sourceView:UIViewController?){
        guard let view = sourceView else {fatalError("Error Desconocido")}
        self.sourceView = view
    }
    
    func navigateToPopViewController(){
        sourceView?.navigationController?.popViewController(animated: true)
    }
    
    func navigateToVerifyOTPViewController(){
        sourceView?.navigationController?.popViewController(animated: true)
    }
    
    func navigateToPopViewController(username:String, restaurant_name_identify:String){
        let verifyOTPViewController = VerifyOTPRouter().viewController as! VerifyOTPViewController
        verifyOTPViewController.username = username
        verifyOTPViewController.restaurant_brand_name = restaurant_name_identify
        sourceView?.navigationController?.pushViewController(verifyOTPViewController, animated: true)
    }
    
}

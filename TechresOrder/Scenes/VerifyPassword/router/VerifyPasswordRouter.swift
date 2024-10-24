//
//  VerifyPasswordRouter.swift
//  TechresOrder
//
//  Created by Kelvin on 24/02/2023.
//

import UIKit

class VerifyPasswordRouter {
    var viewController: UIViewController{
        return createViewController()
    }
    
    private var sourceView:UIViewController?
    
    private func createViewController()-> UIViewController {
        let view = VerifyPasswordViewController(nibName: "VerifyPasswordViewController", bundle: Bundle.main)
        return view
    }
    
    func setSourceView(_ sourceView:UIViewController?){
        guard let view = sourceView else {fatalError("Error Desconocido")}
        self.sourceView = view
    }
    
    
    func navigateToPopViewController(){
       sourceView?.navigationController?.dismiss(animated: true)
    }
}

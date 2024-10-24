//
//  ChangePasswordRouter.swift
//  TechresOrder
//
//  Created by Kelvin on 12/02/2023.
//

import UIKit

class ChangePasswordRouter {

    var viewController: UIViewController{
        return createViewController()
    }
    
    private var sourceView:UIViewController?
    
    private func createViewController()-> UIViewController {
        let view = ChangePasswordViewController(nibName: "ChangePasswordViewController", bundle: Bundle.main)
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

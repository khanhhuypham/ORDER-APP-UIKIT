//
//  OpenWorkingSessionRouter.swift
//  TechresOrder
//
//  Created by Kelvin on 26/01/2023.
//

import UIKit

class OpenWorkingSessionRouter {
    var viewController: UIViewController{
        return createViewController()
    }
    
    private var sourceView:UIViewController?
    
    private func createViewController()-> UIViewController {
        let view = OpenWorkingSessionViewController(nibName: "OpenWorkingSessionViewController", bundle: Bundle.main)
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

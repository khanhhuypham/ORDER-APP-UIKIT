//
//  EnvironmentModeRouter.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 18/02/2024.
//

import UIKit

class EnvironmentModeRouter {
    var viewController: UIViewController{
        return createViewController()
    }
    
    private var sourceView:UIViewController?
    
    private func createViewController()-> UIViewController {
        let view = EnvironmentModeViewController(nibName: "EnvironmentModeViewController", bundle: Bundle.main)
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

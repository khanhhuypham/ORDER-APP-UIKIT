//
//  CreateFood_rebuildRouter.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 08/11/2023.
//

import UIKit

class CreateFooddRouter: NSObject {
    var viewController: UIViewController{
        return createViewController()
    }
    
    private var sourceView:UIViewController?
    
    private func createViewController()-> UIViewController {
        let view = CreateFoodViewController(nibName: "CreateFoodViewController", bundle: Bundle.main)
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

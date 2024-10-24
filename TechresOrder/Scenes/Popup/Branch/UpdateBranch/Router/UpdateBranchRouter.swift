//
//  UpdateBranchRouter.swift
//  TECHRES-ORDER
//
//  Created by macmini_techres_04 on 14/09/2023.
//

import UIKit

class UpdateBranchRouter {
    
    var viewController: UIViewController{
        return createViewController()
    }
    
    private var sourceView:UIViewController?
    
    private func createViewController()-> UIViewController {
        let view = UpdateBranchViewController(nibName: "UpdateBranchViewController", bundle: Bundle.main)
        return view
    }
    
    func setSourceView(_ sourceView:UIViewController?){
        guard let view = sourceView else {fatalError("Error Desconocido")}
        self.sourceView = view
    }
  
    func navigationPopToViewController() {
        sourceView?.navigationController?.popViewController(animated: true)
    }
   
}


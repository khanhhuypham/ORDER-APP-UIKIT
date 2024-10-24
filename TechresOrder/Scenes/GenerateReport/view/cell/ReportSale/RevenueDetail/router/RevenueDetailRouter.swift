//
//  RevenueDetailRouter.swift
//  TechresOrder
//
//  Created by Kelvin on 05/02/2023.
//

import UIKit

class RevenueDetailRouter {
    var viewController: UIViewController{
        return createViewController()
    }
    
    private var sourceView:UIViewController?
    
    private func createViewController()-> UIViewController {
        let view = RevenueDetailViewController(nibName: "RevenueDetailViewController", bundle: Bundle.main)
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

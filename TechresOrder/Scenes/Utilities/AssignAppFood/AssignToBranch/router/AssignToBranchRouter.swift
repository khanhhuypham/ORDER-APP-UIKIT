//
//  AssignToBranchRouter.swift
//  TECHRES-ORDER
//
//  Created by Huynh Quang Huy on 26/8/24.
//

import UIKit

class AssignToBranchRouter {
    var viewController: UIViewController{
        return createViewController()
    }
    
    private var sourceView:UIViewController?
    
    private func createViewController()-> UIViewController {
        let view = AssignToBranchViewController(nibName: "AssignToBranchViewController", bundle: Bundle.main)
        return view
    }
    
    func setSourceView(_ sourceView:UIViewController?){
        guard let view = sourceView else {fatalError("Error Desconocido")}
        self.sourceView = view
    }
    
    func navigateToPopViewController() {
        sourceView?.navigationController?.popViewController(animated: true)
    }
}

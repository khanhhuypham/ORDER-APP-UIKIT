//
//  CreateFeedRebuildRouter.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 02/02/2024.
//

import UIKit

class CreateFeedRebuildRouter: NSObject {
    
    var viewController: UIViewController{
        return createViewController()
    }
    
    private var sourceView:UIViewController?
    
    private func createViewController()-> UIViewController {
        let view = CreateFeedRebuildViewController(nibName: "CreateFeedRebuildViewController", bundle: Bundle.main)
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

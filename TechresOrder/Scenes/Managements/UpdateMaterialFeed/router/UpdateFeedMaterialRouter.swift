//
//  UpdateFeedRouter.swift
//  ORDER
//
//  Created by Macbook Pro M1 Techres - BE65F182D41C on 16/06/2023.
//

import UIKit

class UpdateFeedMaterialRouter: NSObject {
    var viewController: UIViewController{
        return createViewController()
    }
    
    private var sourceView:UIViewController?
    
    private func createViewController()-> UIViewController {
        let view = UpdateFeedMaterialViewController(nibName: "UpdateFeedMaterialViewController", bundle: Bundle.main)
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

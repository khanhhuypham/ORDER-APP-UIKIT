//
//  DialogGiftDetailRouter.swift
//  TechresOrder
//
//  Created by Kelvin on 09/03/2023.
//

import UIKit

class DialogGiftDetailRouter {
    var viewController: UIViewController{
        return createViewController()
    }
    
    private var sourceView:UIViewController?
    
    private func createViewController()-> UIViewController {
        let view = DialogGiftDetailViewController(nibName: "DialogGiftDetailViewController", bundle: Bundle.main)
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

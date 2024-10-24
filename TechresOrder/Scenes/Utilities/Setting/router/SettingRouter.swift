//
//  SettingRouter.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 29/12/2023.
//

import UIKit

class SettingRouter: NSObject {
    var viewController: UIViewController{
        return createViewController()
    }
    
    private var sourceView:UIViewController?
    
    private func createViewController()-> UIViewController {
        let view = SettingViewController(nibName: "SettingViewController", bundle: Bundle.main)
        return view
    }
    
    func setSourceView(_ sourceView:UIViewController?){
        guard let view = sourceView else {fatalError("Error Desconocido")}
        self.sourceView = view
    }
    
    func navigateToPopViewController(){
       sourceView?.navigationController?.popViewController(animated: true)
    }
    
    func navigateToBankAccountSettingViewController(){
        let vc = BankAccountSettingRouter().viewController as! BankAccountSettingViewController
        sourceView?.navigationController?.pushViewController(vc, animated: true)
    }
    
    
}

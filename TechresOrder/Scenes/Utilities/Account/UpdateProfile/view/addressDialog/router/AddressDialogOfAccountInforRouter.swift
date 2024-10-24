//
//  AddressDialogOfAccountInforRouter.swift
//  SEEMT
//
//  Created by Pham Khanh Huy on 27/05/2023.
//  Copyright © 2023 OVERATE-VNTECH. All rights reserved.
//

import UIKit

class AddressDialogOfAccountInforRouter: NSObject {
    var viewController:UIViewController{
        return createViewController()
    }
    
    private var sourceView:UIViewController?
    
    private func createViewController() -> UIViewController{
        let view = AddressDialogOfAccountInforViewController(nibName: "AddressDialogOfAccountInforViewController",bundle: Bundle.main)
        return view
    }
    
    func setSourceView(_ sourceView:UIViewController?){
        guard let view = sourceView else {fatalError("Error Desconocido")}
        self.sourceView = view
    }

    func navigatePopView(){
        sourceView?.navigationController?.popViewController(animated: true)
    }
    
}



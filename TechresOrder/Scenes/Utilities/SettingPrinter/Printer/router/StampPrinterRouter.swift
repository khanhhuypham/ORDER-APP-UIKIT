//
//  StampPrinterRouter.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 20/09/2023.
//

import UIKit

class DetailedPrinterRouter: NSObject {
    var viewController: UIViewController{
        return createViewController()
    }
    
    private var sourceView:UIViewController?
    
    private func createViewController()-> UIViewController {
        
        let view = DetailedPrinterViewController(nibName: "DetailedPrinterViewController", bundle: Bundle.main)
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

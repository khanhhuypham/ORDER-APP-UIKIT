//
//  SettingPrinter_RebuildRouter.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 09/09/2023.
//

import UIKit

class SettingPrinterRouter{
    var viewController: UIViewController{
        return createViewController()
    }
    
    private var sourceView:UIViewController?
    
    private func createViewController()-> UIViewController {
        let view = SettingPrinterViewController(nibName: "SettingPrinterViewController", bundle: Bundle.main)
        return view
    }
    
    func setSourceView(_ sourceView:UIViewController?){
        guard let view = sourceView else {fatalError("Error Desconocido")}
        self.sourceView = view
    }
    
    func navigateToPopViewController(){
        sourceView?.navigationController?.popViewController(animated: true)
    }
    
 
    func navigateToDetailedPrinterViewController(printer:Printer){
        let vc = DetailedPrinterRouter().viewController as! DetailedPrinterViewController
        vc.printer = printer
        sourceView?.navigationController?.pushViewController(vc, animated: true)
    }
    
}

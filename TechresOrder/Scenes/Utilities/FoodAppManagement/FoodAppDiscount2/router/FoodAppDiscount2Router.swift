//
//  FoodAppDiscount2Router.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 28/08/2024.
//

import UIKit


class FoodAppDiscount2Router: NSObject {
    var viewController: UIViewController{
        return createViewController()
    }
    
    private var sourceView:UIViewController?
    
    private func createViewController()-> UIViewController {
        let view = FoodAppDiscount2ViewController(nibName: "FoodAppDiscount2ViewController", bundle: Bundle.main)
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

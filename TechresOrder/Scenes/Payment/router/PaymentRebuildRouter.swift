//
//  PaymentRebuildRouter.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 23/10/2023.
//

import UIKit


class PaymentRebuildRouter {
    var viewController: UIViewController{
        return createViewController()
    }
    
    private var sourceView:UIViewController?
    
    private func createViewController()-> UIViewController {
        let view = PaymentRebuildViewController(nibName: "PaymentRebuildViewController", bundle: Bundle.main)
        return view
    }
    
    func setSourceView(_ sourceView:UIViewController?){
        guard let view = sourceView else {fatalError("Error Desconocido")}
        self.sourceView = view
    }
    func navigateToPopViewController(){
       sourceView?.navigationController?.popViewController(animated: true)
    }
    


    
//    func navigateToReviewFoodViewController(order_id : Int){
//        let reviewFoodViewController = ReviewFoodRouter().viewController as! ReviewFoodViewController
//        reviewFoodViewController.order_id = order_id
//        sourceView?.navigationController?.pushViewController(reviewFoodViewController, animated: true)
//    }

    
    func navigateToOrderHistoryViewController(order:Order){
        let vc = OrderHistoryViewController()
        vc.order = order
        sourceView?.navigationController?.pushViewController(vc, animated: true)
    }
    
}

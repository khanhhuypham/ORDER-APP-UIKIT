//
//  FeeRebuildRouter.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 31/01/2024.
//


import UIKit

class FeeRebuildRouter {
    var viewController: UIViewController{
        return createViewController()
    }
    
    private var sourceView:UIViewController?
    
    private func createViewController()-> UIViewController {
        let view = FeeRebuildViewController(nibName: "FeeRebuildViewController", bundle: Bundle.main)
        return view
    }
    
    func setSourceView(_ sourceView:UIViewController?){
        guard let view = sourceView else {fatalError("Error Desconocido")}
        self.sourceView = view
    }
    
    func navigateToPopViewController(){
        sourceView?.navigationController?.popViewController(animated: true)
    }
    
    func navigateToCreateFeeViewController(){
        let vc = CreateFeedRebuildRouter().viewController as! CreateFeedRebuildViewController
        sourceView?.navigationController?.pushViewController(vc, animated: true)
    }
    
    func navigateToUpdateFeeMaterialViewController(materialFeeId:Int){
        let vc = UpdateMaterialFeeRouter().viewController as! UpdateMaterialFeeViewController
        vc.materialFeeId = materialFeeId
        sourceView?.navigationController?.pushViewController(vc, animated: true)
    }
    func navigateToUpdateOtherFeedViewController(fee: Fee){
        let vc = UpdateOtherFeedRouter().viewController as! UpdateOtherFeedViewController
        vc.fee = fee
        sourceView?.navigationController?.pushViewController(vc, animated: true)
    }
    
}

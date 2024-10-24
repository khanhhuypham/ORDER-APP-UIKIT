//
//  FoodManagementRouter.swift
//  TechresOrder
//
//  Created by Kelvin on 24/01/2023.
//

import UIKit

class FoodManagementRouter {
    var viewController: UIViewController{
        return createViewController()
    }
    
    private var sourceView:UIViewController?
    
    private func createViewController()-> UIViewController {
        let view = FoodManagementViewController(nibName: "FoodManagementViewController", bundle: Bundle.main)
        return view
    }
    
    func setSourceView(_ sourceView:UIViewController?){
        guard let view = sourceView else {fatalError("Error Desconocido")}
        self.sourceView = view
    }
    
    func navigateToPopViewController(){
        sourceView?.navigationController?.popViewController(animated: true)
    }
    
    func navigateToUpdateFoodViewController(food:Food){
        let vc = CreateFooddRouter().viewController as! CreateFoodViewController
        vc.createFoodModel = CreateFood.init(food: food)
        sourceView?.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func navigateToCreateFoodViewController(createFood:CreateFood){
        let vc = CreateFooddRouter().viewController as! CreateFoodViewController
        vc.createFoodModel = createFood
        sourceView?.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
}

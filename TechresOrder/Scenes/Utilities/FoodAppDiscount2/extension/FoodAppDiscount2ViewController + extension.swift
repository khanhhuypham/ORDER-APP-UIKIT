//
//  FoodAppDiscount2ViewController + extension.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 28/08/2024.
//

import UIKit
import RxSwift
import RxRelay
import ObjectMapper


extension FoodAppDiscount2ViewController {
    
    
    func getCommissionOfFoodApp() {
        appServiceProvider.rx.request(.getCommissionOfFoodApp(restaurant_id: Constants.restaurant_id, restaurant_brand_id: Constants.brand.id))
        .filterSuccessfulStatusCodes()
        .mapJSON().asObservable()
        .showAPIErrorToast()
        .mapObject(type: APIResponse.self).subscribe(onNext: { [weak self] response in
            guard let self = self else { return }
            
            if let partners = Mapper<DiscountOfFoodAppPartner>().mapArray(JSONObject: response.data){
                self.viewModel.partners.accept(partners.filter{$0.channel_order_food_code == "GRF" || $0.channel_order_food_code == "GOF" })
                self.tableView.reloadData()
            }
            
            
        }).disposed(by: rxbag)
        
    }
    
    
    func postSetCommissionForFoodApp(partner:DiscountOfFoodAppPartner,percent:Int) {
        appServiceProvider.rx.request(.postSetCommissionForFoodApp(
            id: partner.id,
            restaurant_id: Constants.restaurant_id,
            brand_id: Constants.brand.id,
            branch_id: Constants.branch.id,
            channel_order_food_id: partner.channel_order_food_id,
            percent: percent)
        )
        .filterSuccessfulStatusCodes()
        .mapJSON().asObservable()
        .showAPIErrorToast()
        .mapObject(type: APIResponse.self).subscribe(onNext: { [weak self] response in
            guard let self = self else { return }
           
            
            if (response.code == RRHTTPStatusCode.ok.rawValue) {
                getCommissionOfFoodApp()
            } else if (response.code == RRHTTPStatusCode.badRequest.rawValue) {
           
                self.showWarningMessage(content: response.message ?? "")
            } else {
               
                self.showWarningMessage(content: response.message ?? "")
            }
            
        
        }).disposed(by: rxbag)
        
    }
    
    

    
}


extension FoodAppDiscount2ViewController:EnterPercentDelegate{
    func callbackToGetPercent(id:Int,percent: Int) {
        let partners = viewModel.partners.value
        
        if let p = partners.firstIndex(where: {$0.id == id}){
            postSetCommissionForFoodApp(partner: partners[p], percent: percent)
        }
        
    }

    func presentPopupDiscountViewController(partner:DiscountOfFoodAppPartner,percent:Int? = nil) {
        let vc = PopupEnterPercentViewController()
        vc.header = "CÀI ĐẶT CHIẾT KHẤU " + partner.channel_order_food_name.uppercased(with: .autoupdatingCurrent)
        vc.placeHolder = "Vui lòng nhập % bạn muốn chiếu khấu"
        vc.percent = percent
        vc.itemId = partner.id
        vc.delegate = self
        vc.view.backgroundColor = ColorUtils.blackTransparent()
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overCurrentContext
        present(vc, animated: true, completion: nil)
    }

}

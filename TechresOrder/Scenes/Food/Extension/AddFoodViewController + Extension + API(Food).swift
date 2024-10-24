//
//  AddFood_RebuildViewController + Extension + API.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 07/09/2023.
//

import UIKit
import ObjectMapper
import JonAlert
import RxDataSources


extension AddFoodViewController{
    
    func createOrder(order:OrderDetail){
        order.is_take_away == ACTIVE ? createTakeOutOder() : createDineInOrder()
    }
    
    
    //MARK: API mở order tại bàn
   private func createDineInOrder(){
        viewModel.createDineInOrder().subscribe(onNext: { (response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){
                if let data  = Mapper<Table>().map(JSONObject: response.data){
                    var order = self.viewModel.order.value
                    order.id = data.order_id
                    self.viewModel.order.accept(order)
                    self.proccessAddFoodToOrder()
                }
            }else{
                JonAlert.showError(message: response.message ?? "Có lỗi xảy ra trong quá trình kết nối tới máy chủ.", duration: 2.0)
                dLog(response.message ?? "")
            }
         
        }).disposed(by: rxbag)
    }
    
    //MARK: API tạo order mang về.
    private func createTakeOutOder(){
        viewModel.createTakeOutOder().subscribe(onNext: { (response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){
                if let data  = Mapper<NewOrder>().map(JSONObject: response.data){
                    var order = self.viewModel.order.value
                    order.id = data.order_id
                    self.viewModel.order.accept(order)
                    self.proccessAddFoodToOrder()
                }
            }else{
                JonAlert.showError(message: response.message ?? "Có lỗi xảy ra trong quá trình kết nối tới máy chủ.", duration: 2.0)
                dLog(response.message ?? "")
            }
         
        }).disposed(by: rxbag)
    }

}

//MARK: FOOD
extension AddFoodViewController{
    
    func getCategories(){

        viewModel.getCategories().subscribe(onNext: { (response) in
            
            if(response.code == RRHTTPStatusCode.ok.rawValue){
                if var categories = Mapper<Category>().mapArray(JSONObject: response.data) {
                    
                    var cate = Category()!

                    cate.id = -1
                    cate.name = "Tất cả"
                    cate.isSelected = ACTIVE
                    
                    categories.insert(cate, at: 0)
                    self.viewModel.categoryArray.accept(categories)
                    
                    
                    var apiParameter = self.viewModel.APIParameter.value
                    apiParameter.category_id = cate.id
                    self.viewModel.APIParameter.accept(apiParameter)
                    self.fetFoods()
                }
               
            }else{
                dLog(response.message ?? "")
            }
         
        }).disposed(by: rxbag)
    }
    
    
    func healthCheckForFood(){
        viewModel.healthCheckDataChangeFromServer().subscribe(onNext: { (response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){
                self.getCategories()
                dLog("Gọi API health check thành công")
            }else{
                dLog(response.message ?? "Có lỗi xảy ra trong quá trình kết nối tới máy chủ.")
            }
        }).disposed(by: rxbag)
    }
    
 

    
    
    func fetFoods(){

        viewModel.foods().subscribe(onNext: {[weak self] (response) in
            
            guard let self = self else { return }
            
            if(response.code == RRHTTPStatusCode.ok.rawValue){

                if var data = Mapper<FoodResponse>().map(JSONObject: response.data) {
                    
                    
                    if let section = self.viewModel.sectionArray.value.first,section.model == .food {
                        var p = self.viewModel.APIParameter.value
                        var list = section.items
                        
                        if(data.foods.count > 0 && !p.isGetFullData){
                            //===================== assign selected item ========================================
                            for (i,element) in data.foods.enumerated(){
                                if let selectedItem = self.viewModel.selectedFoods.value.first(where: {$0.id == element.id}){
                                    data.foods[i] = selectedItem
                                }
                            }
                            //===================================================================================
                            
                            list.append(contentsOf: data.foods)
                        }

                         p.isGetFullData = data.foods.count < p.limit ? true: false
                         p.isAPICalling = false
                      
                        self.viewModel.APIParameter.accept(p)
                        
                        self.viewModel.sectionArray.accept(
                            [SectionModel(model: FOOD_CATEGORY.food,items: list)]
                        )
                        self.view_nodata_order.isHidden = (list.count) > 0 ? true:false // thêm kiểm tra hiển thị icon ko có dữ liệu
                        
                    
                        self.tableView.tableFooterView?.isHidden = true
                        self.tableView.tableHeaderView?.isHidden = true
              
                    }else{
                        self.view_nodata_order.isHidden = false
                    }
                    
 
                }
            }else{
                dLog(response.message ?? "")
            }
         
        }).disposed(by: rxbag)
    }
    
    
 
    
    
        
  
    
    func addFoodsToOrder(items:[FoodRequest]){
        
        viewModel.addFoods(items:items).subscribe(onNext: { (response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){
                if let data  = Mapper<NewOrder>().map(JSONObject: response.data){
                    var order = self.viewModel.order.value
                    order.id = data.order_id
                    self.viewModel.order.accept(order)
                    
                    self.navigationController?.viewControllers.removeAll(where: { (vc) -> Bool in
                        return vc.isKind(of: OrderDetailViewController.self) ? true : false
                    })
                
                    self.viewModel.makeOrderDetailViewController()
                    // remove addFoodViewController
                    self.navigationController?.viewControllers.removeAll(where: { (vc) -> Bool in
                        return vc.isKind(of: AddFoodViewController.self) ? true : false
                    })
                    JonAlert.showSuccess(message: "Thêm món thành công",duration: 2.0)
                }
                
            }else{
                dLog(response.message ?? "Có lỗi xảy ra trong quá trình kết nối tới máy chủ.")

            }
         
        }).disposed(by: rxbag)
    }
    
    func addGiftFoodsToOrder(items:[FoodRequest]){
        viewModel.addGiftFoods(items:items).subscribe(onNext: { (response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){
                JonAlert.showSuccess(message: "Tặng món thành công",duration: 2.0)
               
                self.navigationController?.viewControllers.removeAll(where: { (vc) -> Bool in
                    return vc.isKind(of: AddFoodViewController.self) ? true : false
                })
                 self.viewModel.makeOrderDetailViewController()


            }else{

                dLog(response.message ?? "Có lỗi xảy ra trong quá trình kết nối tới máy chủ.")
            }
         
        }).disposed(by: rxbag)
    }

}


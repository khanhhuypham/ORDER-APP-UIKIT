//
//  CreateFood_rebuildViewController + extension + API.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 09/11/2023.
//

import UIKit
import ObjectMapper
import JonAlert
extension CreateFoodViewController {
    func getCategories(){
        viewModel.getCategories().subscribe(onNext: {(response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){
                if var data = Mapper<Category>().mapArray(JSONObject: response.data) {
                    var model = self.viewModel.createFoodModel.value
                    
                    //Nếu là món bán kèm thì danh mục ko dc là món nước và món khác
                    if model.is_addition == ACTIVE{
                        data = data.filter{$0.categoryType == .processed }
                    }
       
                    
                    if(model.id > 0) { // update food
                        if let position = data.firstIndex(where: {$0.id == model.category_id}){
                            self.btn_show_category_list.setTitle("  " + data[position].name , for: .normal)
                            model.category_id = data[position].id
                            model.category_type = data[position].categoryType.value
                        }
                    }else{
                        model.category_id = data[0].id
                        model.category_type = data[0].categoryType.value
                        self.btn_show_category_list.setTitle("  " + data[0].name , for: .normal)
                    }
                    
                    self.viewModel.categoryList.accept(data)
                    self.viewModel.createFoodModel.accept(model)
                }
               
            }else{
                dLog(response.message ?? "")
            }
         
        }).disposed(by: rxbag)
    }
    
    
    
    func getUnits(){
        viewModel.getUnits().subscribe(onNext: { (response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){
                if let data  = Mapper<Unit>().mapArray(JSONObject: response.data){
                    var model = self.viewModel.createFoodModel.value
                    
                    if(model.id > 0) { // update food
                        if let position = data.firstIndex(where: {$0.name == model.unit}){
                            self.btn_show_unit_list.setTitle("  " + data[position].name , for: .normal)
                            model.unit = data[position].name
                        }
                    }else {
                        model.unit = data[0].name
                        self.btn_show_unit_list.setTitle("  " + data[0].name, for: .normal)
                    }
                    
                    self.viewModel.unitList.accept(data)
                    self.viewModel.createFoodModel.accept(model)
                }
            }
        }).disposed(by: rxbag)
        
    }
    
    
    func getPrinters(){
        viewModel.getPrinters().subscribe(onNext: { (response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){
          
                if var data = Mapper<Printer>().mapArray(JSONObject: response.data){
                   
                    data = data.filter{$0.type == .chef || $0.type == .bar}
                    var model = self.viewModel.createFoodModel.value
                    
    
                    
                    if(model.id > 0) { // update food
                        if let position = data.firstIndex(where: {$0.id == model.restaurant_kitchen_place_id}){
                            self.btn_show_printer.setTitle("  " + data[position].name , for: .normal)
                            model.restaurant_kitchen_place_id = data[position].id
                        }
                    }else{
                        if data.count > 0{
                            model.restaurant_kitchen_place_id = data[0].id
                            self.btn_show_printer.setTitle("  " + data[0].name, for: .normal)
                        }
                    }
                    
                    self.viewModel.createFoodModel.accept(model)
                    self.viewModel.printerList.accept(data)
                }

            }
        }).disposed(by: rxbag)
        
    }
    
    
    
    func getVAT(){
        viewModel.getVAT().subscribe(onNext: { (response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){
              
                if let data = Mapper<Vat>().mapArray(JSONObject: response.data){
                    var model = self.viewModel.createFoodModel.value
                    
                 
                    /* Thuế khi chọn mặc định sẽ là thuế đầu tiên trả về */
                    if(model.restaurant_vat_config_id > 0) {
                        if let position = data.firstIndex(where: {$0.id == model.restaurant_vat_config_id}){
                            self.btn_show_vat_list.setTitle("  " + data[position].vat_config_name, for: .normal)
                            model.restaurant_vat_config_id = data[position].id
                        }
                    }else{
                        model.restaurant_vat_config_id = data[0].id
                        self.btn_show_vat_list.setTitle("  " + data[0].vat_config_name, for: .normal)
                    }
                    
                    self.viewModel.vatList.accept(data)
                    self.viewModel.createFoodModel.accept(model)
                }

            }
        }).disposed(by: rxbag)
        
    }
    
    
    
    func getAdditionFoodsManagement(){
        viewModel.getFoodsManagement().subscribe(onNext: { (response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){
                if var additionFoods = Mapper<Food>().mapArray(JSONObject: response.data) {
           

                    let createFoodModel = self.viewModel.createFoodModel.value
                    self.taglist.removeAllTags()
                    for childFoodId in createFoodModel.food_addition_ids{
                        if let pos = additionFoods.firstIndex(where: {$0.id == childFoodId}){
                            self.taglist.addTag(additionFoods[pos].name)
                            additionFoods[pos].is_selected = ACTIVE
                        }
                    }
                    
                    self.viewModel.additionFoodList.accept(additionFoods)
                    
                    self.embeddedDropDown.optionArray = additionFoods.map{(name:$0.name,id:$0.id)}
                    self.embeddedDropDown.selectedIds = additionFoods.filter{$0.is_selected == ACTIVE}.map{$0.id}
                    
                    self.taglist.isHidden = self.taglist.intrinsicContentSize.height > 0 ? false : true
                    self.height_of_taglist.constant = self.taglist.intrinsicContentSize.height

                }
            }else{
                dLog(response.message ?? "")
            }

        }).disposed(by: rxbag)
    }
    
    
    
    

}

extension CreateFoodViewController {

    func createFood(){
        viewModel.createFood().subscribe(onNext: { (response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){
            
                JonAlert.showSuccess(message: "Thêm mới món ăn thành công!", duration: 2.0)
//                self.delegate?.callBackReload()
                self.viewModel.makePopViewController()
            }else{
                self.showErrorMessage(content: response.message ?? "")
            }
            
        }).disposed(by: rxbag)
        
    }
    
    func updateFood(){
        viewModel.updateFood().subscribe(onNext: { (response) in
     
            if(response.code == RRHTTPStatusCode.ok.rawValue){
    
                JonAlert.showSuccess(message: "Cập nhật món ăn thành công!", duration: 2.0)
//                self.delegate?.callBackReload()
                self.viewModel.makePopViewController()
            }else if response.code == RRHTTPStatusCode.badRequest.rawValue {
                self.showErrorMessage(content: response.message ?? "Cập nhật thất bại")
            }else{
                self.showErrorMessage(content: response.message ?? "Cập nhật thất bại")
            }

        }).disposed(by: rxbag)
        
    }
}

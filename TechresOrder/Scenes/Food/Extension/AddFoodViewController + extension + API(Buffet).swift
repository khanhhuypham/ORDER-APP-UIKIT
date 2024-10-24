//
//  AddFoodViewController + extension + API(Buffet).swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 02/05/2024.
//

import UIKit
import ObjectMapper
import JonAlert
import RxDataSources

//MARK: Buffet
extension AddFoodViewController{
    
    func healthCheckForBuffet(buffet:Buffet){
        viewModel.healthCheckForBuffet(buffet: buffet).subscribe(onNext: { (response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){
                self.getBuffetTickets(buffet: buffet)
            }else{
                dLog(response.message ?? "Có lỗi xảy ra trong quá trình kết nối tới máy chủ.")
            }
        }).disposed(by: rxbag)
    }
    
    func getBuffetTickets(){

        viewModel.getBuffetTickets().subscribe(onNext: {[weak self] (response) in
            guard let self = self else { return }
            if(response.code == RRHTTPStatusCode.ok.rawValue){
                if var data = Mapper<BuffetResponse>().map(JSONObject: response.data) {

                    if let section = self.viewModel.sectionArray.value.first,section.model == .buffet_ticket{
                        var p = self.viewModel.APIParameter.value
                        var list = section.items

                        if(data.list.count > 0 && !p.isGetFullData){
                             
                            //===================== assign selected item ========================================                            
                            if let selectedItem = self.viewModel.selectedBuffet.value,
                               let p = data.list.firstIndex(where: {$0.id == selectedItem.id}){
                                data.list[p] = selectedItem
                            }
                            
                            //========================================================================
                            
                            list.append(contentsOf: data.list)
                            
                         }

                         p.isGetFullData = data.list.count < p.limit ? true: false
                         p.isAPICalling = false
                      
                        self.viewModel.APIParameter.accept(p)

                        self.viewModel.sectionArray.accept(
                            [SectionModel(model: .buffet_ticket,items: list)]
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
    
    
    
    func getBuffetTickets(buffet:Buffet){

        viewModel.getDetailOfBuffetTicket(buffet: buffet).subscribe(onNext: { (response) in
           
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
                            [SectionModel(model: .food, items: list)]
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
    
    
    
    
    //MARK: API tạo vé buffet.
    func createBuffetTicket(buffet: Buffet){
        viewModel.createBuffetTickets(buffet: buffet).subscribe(onNext: { (response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){
                if let data  = Mapper<Buffet>().map(JSONObject: response.data){
                                        
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
                JonAlert.showError(message: response.message ?? "Có lỗi xảy ra trong quá trình kết nối tới máy chủ.", duration: 2.0)
                dLog(response.message ?? "")
            }
         
        }).disposed(by: rxbag)
    }
    
}

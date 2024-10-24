//
//  FoodManagementViewController+Extension.swift
//  TechresOrder
//
//  Created by Kelvin on 24/01/2023.
//

import UIKit
import ObjectMapper
import RxSwift

//MARK: -- CALL API
extension FoodManagementViewController {
    func getFoodList(){
        viewModel.getFoodsManagement().subscribe(onNext: { (response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){
                if let foods = Mapper<Food>().mapArray(JSONObject: response.data) {
                   
                    self.viewModel.dataArray.accept(foods)
                    self.viewModel.fullDataArray.accept(foods)
                }
            }else{
                dLog(response.message ?? "")
            }
         
        }).disposed(by: rxbag)
    }
}

extension FoodManagementViewController{
    
    func registerCellAndBindTableViewData(){
        registerCell()
        bindTableViewData()
    }
    
    private func registerCell() {
        let foodManagementTableViewCell = UINib(nibName: "FoodManagementTableViewCell", bundle: .main)
        tableView.register(foodManagementTableViewCell, forCellReuseIdentifier: "FoodManagementTableViewCell")
        tableView.rowHeight = UITableView.automaticDimension

        
        tableView.rx.modelSelected(Food.self) .subscribe(onNext: { [self] element in
            self.viewModel.makeUpdateFoodViewController(food: element)
            textfield_search_food.text = ""
        })
        .disposed(by: rxbag)
        
    }
    
    private func bindTableViewData() {
       viewModel.dataArray.bind(to: tableView.rx.items(cellIdentifier: "FoodManagementTableViewCell", cellType: FoodManagementTableViewCell.self))
           {  (row, food, cell) in
               cell.data = food
               cell.viewModel = self.viewModel
           }.disposed(by: rxbag)
       }
}


extension FoodManagementViewController: TechresDelegate{
    func callBackReload() {
        self.getFoodList()
    }
}

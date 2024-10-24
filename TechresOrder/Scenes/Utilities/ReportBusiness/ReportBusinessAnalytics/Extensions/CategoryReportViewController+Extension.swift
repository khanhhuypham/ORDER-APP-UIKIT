//
//  CategoryReportViewController+Extension.swift
//  TechresOrder
//
//  Created by Kelvin on 26/02/2023.
//

import UIKit
import RxSwift
import ObjectMapper

extension CategoryReportViewController{
    //MARK: Register Cells as you want
    func registerCell(){
        let categoriesTableViewCell = UINib(nibName: "CategoriesTableViewCell", bundle: .main)
        tableView.register(categoriesTableViewCell, forCellReuseIdentifier: "CategoriesTableViewCell")
        tableView.rx.setDelegate(self).disposed(by: rxbag)
    }
    
     func bindTableViewData() {
        viewModel!.dataArray.bind(to: tableView.rx.items(cellIdentifier: "CategoriesTableViewCell", cellType: CategoriesTableViewCell.self))
            {  (row, food, cell) in
                cell.data = food                
            }.disposed(by: rxbag)
 
    }
        
}

extension CategoryReportViewController:UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}
//MARK: -- CALL API
extension CategoryReportViewController {
    func getFoodByCategory(){
        viewModel!.getReportFood().subscribe(onNext: { (response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){
//                dLog(response.data)
                if let foodResponse = Mapper<FoodReportData>().map(JSONObject: response.data) {
                
                    if let foods = foodResponse.foods{
                        self.viewModel?.dataArray.accept(foods)
                        self.no_data_view.isHidden = (self.viewModel?.dataArray.value.count)! > 0 ? true : false
                    }
                }
            }else{
                dLog(response.message ?? "")
            }
         
        }).disposed(by: rxbag)
    }
}

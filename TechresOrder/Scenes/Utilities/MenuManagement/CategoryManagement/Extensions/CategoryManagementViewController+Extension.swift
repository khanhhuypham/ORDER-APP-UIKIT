//
//  CategoryManagementViewController+Extension.swift
//  TechresOrder
//
//  Created by Kelvin on 24/01/2023.
//

import UIKit
import ObjectMapper
import RxSwift

extension CategoryManagementViewController{
    func registerCell() {
        let categoryTableViewCell = UINib(nibName: "CategoryTableViewCell", bundle: .main)
        tableView.register(categoryTableViewCell, forCellReuseIdentifier: "CategoryTableViewCell")
        self.tableView.rowHeight = UITableView.automaticDimension
       
        tableView.rx.modelSelected(Category.self) .subscribe(onNext: { [self] element in
            print("Selected \(element)")
            self.presentModalCreateCategory(cate: element)
        })
        .disposed(by: rxbag)
        
    }
    
    func bindTableViewData() {
       viewModel.dataArray.bind(to: tableView.rx.items(cellIdentifier: "CategoryTableViewCell", cellType: CategoryTableViewCell.self))
           {  (row, cate, cell) in
               cell.data = cate
               cell.viewModel = self.viewModel
           }.disposed(by: rxbag)
       }
}



//MARK: -- CALL API
extension CategoryManagementViewController {
    func getCategoriesManagement(){
        viewModel.getCategories().subscribe(onNext: { (response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){
                if let categories = Mapper<Category>().mapArray(JSONObject: response.data) {


                    self.viewModel.dataArray.accept( categories.count > 0 ? categories : [])
                    self.no_data_view.isHidden = categories.count > 0 ? true : false
                }
               
            }else{
                dLog(response.message ?? "")
            }
         
        }).disposed(by: rxbag)
    }
}
extension CategoryManagementViewController: TechresDelegate{

    func presentModalCreateCategory(cate:Category = Category()!) {
            let vc = CreateCategoryPopupViewController()
            vc.category = cate
            vc.delegate = self
            vc.view.backgroundColor = ColorUtils.blackTransparent()
            let nav = UINavigationController(rootViewController: vc)
            // 1
            nav.modalPresentationStyle = .overCurrentContext

            
            // 2
            if #available(iOS 15.0, *) {
                if let sheet = nav.sheetPresentationController {
                    
                    // 3
                    sheet.detents = [.medium()]
                    
                }
            } else {
                // Fallback on earlier versions
            }
            // 4

            present(nav, animated: true, completion: nil)

    }
    
    func callBackReload() {
        self.getCategoriesManagement()
    }
}

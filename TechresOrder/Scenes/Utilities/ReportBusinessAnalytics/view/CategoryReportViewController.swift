//
//  CategoryReportViewController.swift
//  TechresOrder
//
//  Created by Kelvin on 25/02/2023.
//

import UIKit
import ObjectMapper
class CategoryReportViewController: BaseViewController {

    
    @IBOutlet weak var no_data_view: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        no_data_view.isHidden = true
        // Do any additional setup after loading the view.
        registerCell()
        bindTableViewData()

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getFoodByCategory()
    }

    var viewModel: ReportBusinessAnalyticsViewModel? {
       didSet {
           bindViewModel()
       }
    }
    
    private func bindViewModel() {
       if let viewModel = viewModel {
           viewModel.report_type.subscribe( // Thực hiện subscribe Observable
             onNext: { [weak self] report_type in
                 self?.getFoodByCategory()
             }).disposed(by: rxbag)
           
       }
    }
}


extension CategoryReportViewController:UITableViewDelegate{
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
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
        
}


//MARK: -- CALL API
extension CategoryReportViewController {
    func getFoodByCategory(){
        viewModel?.getReportFood().subscribe(onNext: { (response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){
                if let foodResponse = Mapper<FoodReportData>().map(JSONObject: response.data) {

                    self.viewModel?.dataArray.accept(foodResponse.foods.sorted(by: {$0.quantity > $1.quantity}))
                    self.no_data_view.isHidden = (self.viewModel?.dataArray.value.count)! > 0 ? true : false

                }
            }else{
                dLog(response.message ?? "")
            }
        }).disposed(by: rxbag)
    }
}


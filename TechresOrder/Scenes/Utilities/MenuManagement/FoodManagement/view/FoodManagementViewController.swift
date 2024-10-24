//
//  FoodManagementViewController.swift
//  TechresOrder
//
//  Created by Kelvin on 24/01/2023.
//

import UIKit
import RxSwift

class FoodManagementViewController: BaseViewController {
    var viewModel = FoodManagementViewModel()
    var router = FoodManagementRouter()
    let refreshControl = UIRefreshControl()
    
    
    @IBOutlet weak var lbl_normal_food: UILabel!
    @IBOutlet weak var underline_of_normal_food: UIView!
    @IBOutlet weak var lbl_addition_food: UILabel!
    @IBOutlet weak var underline_of_addition_food: UIView!
    
    
    @IBOutlet weak var view_no_data: UIView!
    @IBOutlet weak var textfield_search_food: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var btn_create: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        viewModel.bind(view: self, router: router)
        registerCellAndBindTableViewData()
        


        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        tableView.addSubview(refreshControl) // not required when using UItableViewController
        
        viewModel.dataArray.subscribe(onNext: {(foods) in
            self.view_no_data.isHidden = foods.count > 0 ? true : false
        }).disposed(by: rxbag)
        
        textfield_search_food.rx.controlEvent(.editingChanged).withLatestFrom(textfield_search_food.rx.text).subscribe(onNext:{(query) in
            let fullDataArray = self.viewModel.fullDataArray.value
            if !query!.isEmpty {
                let filteredDataArray = fullDataArray.filter({
                    (value) -> Bool in
                    let str1 = query!.uppercased().applyingTransform(.stripDiacritics, reverse: false)!
                    let str2 = value.name.uppercased().applyingTransform(.stripDiacritics, reverse: false)!
                    let str3 = value.normalize_name.uppercased().applyingTransform(.stripDiacritics, reverse: false)!
                    return str2.contains(str1) || str3.contains(str1)
                })
                self.viewModel.dataArray.accept(filteredDataArray)
            }else{
                self.viewModel.dataArray.accept(fullDataArray)
            }
        }).disposed(by: rxbag)
        
    }
    @objc func refresh(_ sender: AnyObject) {
          // Code to refresh table view
        self.getFoodList()
        refreshControl.endRefreshing()
    }
    @IBAction func actionCreate(_ sender: Any) {
        viewModel.makeCreateFoodViewController()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.is_addition.value == DEACTIVE ? actionFilterNormalFood("") : actionFilterAdditionFood("")
    }
    
    
    @IBAction func actionFilterNormalFood(_ sender: Any) {
        btn_create.setTitle("  THÊM MÓN", for: .normal)
        lbl_normal_food.textColor = ColorUtils.green_600()
        underline_of_normal_food.backgroundColor = ColorUtils.green_600()
        lbl_addition_food.textColor = ColorUtils.green_200()
        underline_of_addition_food.backgroundColor = .white
        viewModel.is_addition.accept(DEACTIVE)
        getFoodList()
    }
    
    @IBAction func actionFilterAdditionFood(_ sender: Any) {
        btn_create.setTitle("  THÊM MÓN BÁN KÈM/TOPPING", for: .normal)
        lbl_addition_food.textColor = ColorUtils.green_600()
        underline_of_addition_food.backgroundColor = ColorUtils.green_600()
        
        lbl_normal_food.textColor = ColorUtils.green_200()
        underline_of_normal_food.backgroundColor = .white
        viewModel.is_addition.accept(ACTIVE)
        getFoodList()
    }
    
        
}

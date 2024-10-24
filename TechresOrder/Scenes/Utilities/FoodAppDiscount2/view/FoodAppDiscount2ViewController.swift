//
//  FoodAppDiscount2ViewController.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 28/08/2024.
//

import UIKit

class FoodAppDiscount2ViewController: BaseViewController {

    var viewModel = FoodAppDiscount2ViewModel()
    var router = FoodAppDiscount2Router()
    
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.bind(view: self, router: router)
        registerCell()
        getCommissionOfFoodApp()
    }
    
    
    @IBAction func actionBack(_ sender: Any) {
        viewModel.makePopViewController()
    }
    
    
}


extension FoodAppDiscount2ViewController:UITableViewDataSource,UITableViewDelegate {
    
    func registerCell() {
        
        let cell = UINib(nibName: "AppFoodTableViewCell", bundle: .main)
        tableView.register(cell, forCellReuseIdentifier: "AppFoodTableViewCell")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.isScrollEnabled = false
        tableView.dataSource = self
        tableView.delegate = self
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.partners.value.count
    }
    

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "AppFoodTableViewCell", for: indexPath) as! AppFoodTableViewCell

        guard indexPath.row < viewModel.partners.value.count else {
            return cell
        }
        
        let partner = viewModel.partners.value[indexPath.row]
        
        cell.lbl_partner_name.text = String(format: "%@ (%d%%)", partner.channel_order_food_name, partner.percent)
        cell.lbl_partner_name.textColor = ColorUtils.gray_600()
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let partner = viewModel.partners.value[indexPath.row]
        
        presentPopupDiscountViewController(partner: partner, percent: partner.percent)
        
   }
    
    
    
}
 

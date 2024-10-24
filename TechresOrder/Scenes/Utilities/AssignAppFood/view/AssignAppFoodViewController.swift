//
//  AppFoodViewController.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 29/07/2024.
//

import UIKit
import ObjectMapper
import RxSwift
class AssignAppFoodViewController: BaseViewController {
    
    var viewModel = AssignAppFoodViewModel()
    var router = AssignAppFoodRouter()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.bind(view: self, router: router)
        registerCell()
       
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getChannelFoodOrder()
    }
    
    
    @IBAction func actionBack(_ sender: Any) {
        viewModel.makePopViewController()
    }
    

    func getChannelFoodOrder() {
        
        viewModel.getChannelFoodOrder().subscribe(onNext: { (response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){
                if let partners = Mapper<FoodAppAPartner>().mapArray(JSONObject: response.data){
                    self.viewModel.partners.accept(partners)
                    self.tableView.reloadData()
                }

            }else{
                   dLog(response.message ?? "Có lỗi xảy ra trong quá trình kết nối tới máy chủ. Vui lòng thử lại.")
                  
            }
        }).disposed(by: rxbag)
        
        
    }
    
}


extension AssignAppFoodViewController:UITableViewDataSource,UITableViewDelegate {
    
    func registerCell() {
        
        let cell = UINib(nibName: "AssignAppFoodTableViewCell", bundle: .main)
        tableView.register(cell, forCellReuseIdentifier: "AssignAppFoodTableViewCell")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.isScrollEnabled = false
        tableView.dataSource = self
        tableView.delegate = self
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.partners.value.count
    }
    

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "AssignAppFoodTableViewCell", for: indexPath) as! AssignAppFoodTableViewCell

        guard indexPath.row < viewModel.partners.value.count else {
            return cell
        }

        cell.data = viewModel.partners.value[indexPath.row]
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let partner = viewModel.partners.value[indexPath.row]
        viewModel.makeFoodAppLoginViewController(partner: partner)
   }
    
}
 

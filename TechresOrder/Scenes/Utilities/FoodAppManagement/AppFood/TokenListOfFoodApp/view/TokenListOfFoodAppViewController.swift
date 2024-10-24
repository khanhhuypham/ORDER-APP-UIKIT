//
//  TokenListOfFoodAppViewController.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 30/09/2024.
//

import UIKit
import ObjectMapper
class TokenListOfFoodAppViewController: BaseViewController {

    var viewModel = TokenListOfFoodAppViewModel()
    var router = TokenListOfFoodAppRouter()
    var partner:FoodAppAPartner = FoodAppAPartner()
    
    @IBOutlet weak var lbl_title: UILabel!
    @IBOutlet weak var view_of_btn_add: UIView!
    
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.bind(view: self, router: router)
        registerCell()
        viewModel.partner.accept(partner)
        lbl_title.text = String(format: "KẾT NỐI VỚI %@", partner.name.uppercased(with: .autoupdatingCurrent))
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getChannelOrderFoodTokenList()
    }

    @IBAction func actionBack(_ sender: Any) {
        viewModel.makePopViewController()
    }
    
    @IBAction func actionAdd(_ sender: Any) {
    
//        let cre = PartnerCredential.init(
//            id: 0,
//            restaurant_id: Constants.restaurant_id,
//            restaurant_brand_id: Constants.brand.id,
//            partnerType: partner.code,
//            channel_order_food_id: partner.id,
//            access_token: "",
//            username: "",
//            password: ""
//        )
        var cre = PartnerCredential()
        cre.id = 0
        cre.restaurant_id = Constants.restaurant_id
        cre.restaurant_brand_id =  Constants.brand.id
        cre.partnerType = partner.code
        cre.channel_order_food_id = partner.id
        cre.is_connection = DEACTIVE
        cre.name = partner.name
        cre.access_token = ""
        cre.username = ""
        cre.username = ""
        
        
        
        viewModel.makeFoodAppLoginViewController(cre:cre)
    }
    
    
    
    
}

extension TokenListOfFoodAppViewController{
    private func getChannelOrderFoodTokenList(){
        
        appServiceProvider.rx.request(.getChannelOrderFoodTokenList(
            brand_id: Constants.brand.id,
            channel_order_food_id: viewModel.partner.value.id,
            channel_order_food_token_id: -1,
            is_connection: -1)
        ).mapJSON().asObservable().mapObject(type: APIResponse.self).subscribe(onNext:{[weak self](response) in
            
            guard let self = self else { return }
            
            if var list = Mapper<PartnerCredential>().mapArray(JSONObject: response.data){
                
                for (i,_) in list.enumerated(){
                    list[i].partnerType = self.viewModel.partner.value.code
                }
                
                self.viewModel.credentials.accept(list)
                
                
                switch self.partner.code {
                    
                    case .shoppee:
                        self.view_of_btn_add.isHidden = list.count < Constants.brand.setting?.maximum_shf_account ?? 0 ? false : true
                    
                    case .grabfood:
                        self.view_of_btn_add.isHidden = list.count < Constants.brand.setting?.maximum_grf_account ?? 0 ? false : true
                
                    case .befood:
                        self.view_of_btn_add.isHidden = list.count < Constants.brand.setting?.maximum_bef_account ?? 0 ? false : true
                        
                    default:
                        self.view_of_btn_add.isHidden = true
                }
                 
          
                
                self.tableView.reloadData()
            }
        }).disposed(by: rxbag)
    }
    
}

extension TokenListOfFoodAppViewController:UITableViewDataSource,UITableViewDelegate {
    
    func registerCell() {
        
        let cell = UINib(nibName: "TokenListOfFoodAppTableViewCell", bundle: .main)
        tableView.register(cell, forCellReuseIdentifier: "TokenListOfFoodAppTableViewCell")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.isScrollEnabled = false
        tableView.dataSource = self
        tableView.delegate = self
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.credentials.value.count
    }
    

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TokenListOfFoodAppTableViewCell", for: indexPath) as! TokenListOfFoodAppTableViewCell
        cell.data = viewModel.credentials.value[indexPath.row]
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cre = viewModel.credentials.value[indexPath.row]
        viewModel.makeFoodAppLoginViewController(cre: cre)
   }
    

}
 



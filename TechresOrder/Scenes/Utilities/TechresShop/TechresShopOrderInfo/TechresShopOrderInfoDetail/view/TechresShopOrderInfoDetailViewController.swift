//
//  TechresShopOrderInfoDetailViewController.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 05/09/2024.
//

import UIKit
import ObjectMapper
class TechresShopOrderInfoDetailViewController: BaseViewController {
    
    var order = TechresShopOrder()
    @IBOutlet weak var lbl_name: UILabel!
    
    @IBOutlet weak var lbl_phone: UILabel!
    
    @IBOutlet weak var lbl_address: UILabel!

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var lbl_total_payment: UILabel!
    @IBOutlet weak var lbl_discount: UILabel!
    @IBOutlet weak var lbl_vat: UILabel!
    @IBOutlet weak var lbl_returned_quantity: UILabel!
    @IBOutlet weak var lbl_total_netPayment: UILabel!
    
    


    override func viewDidLoad() {
        super.viewDidLoad()
        registerCell()
        tableView.reloadData()
        getTechresShopOrderDetail()
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func actionBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    private func mapData(order:TechresShopOrder){
        
        lbl_name.text = String(format: "Tên người đặt: %@", order.receiver_name)

        lbl_phone.text = String(format: "Số điện thoại: %@", order.receiver_phone)

        lbl_address.text = String(format: "Địa chỉ: %@", order.shipping_full_address)

        lbl_total_payment.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: order.total_amount)

        lbl_discount.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: order.discount_amount)

        lbl_vat.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: order.vat_amount)

        lbl_returned_quantity.text = Utils.stringVietnameseMoneyFormatWithNumberInt(amount: order.total_amount_returned)

        lbl_total_netPayment.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: order.total_amount)
    }
    
}



extension TechresShopOrderInfoDetailViewController {
    func getTechresShopOrderDetail() {
        appServiceProvider.rx.request(.getTechresShopOrderDetail(order_id: order.id))
        .filterSuccessfulStatusCodes()
        .mapJSON().asObservable()
        .showAPIErrorToast()
        .mapObject(type: APIResponse.self).subscribe(onNext: { [weak self] response in
            guard let self = self else { return }
           
        
            if (response.code == RRHTTPStatusCode.ok.rawValue) {
                if let order = Mapper<TechresShopOrder>().map(JSONObject: response.data) {
                    self.order = order
                    self.mapData(order:order)
                    tableView.reloadData()
                }
            } else if (response.code == RRHTTPStatusCode.badRequest.rawValue) {
                self.showWarningMessage(content: response.message ?? "")
            }
            

        }).disposed(by: rxbag)
        
    }
}

extension TechresShopOrderInfoDetailViewController:UITableViewDataSource,UITableViewDelegate {
    
    func registerCell() {
        
        let cell = UINib(nibName: "TechresShopOrderInfoDetailTableViewCell", bundle: .main)
        tableView.register(cell, forCellReuseIdentifier: "TechresShopOrderInfoDetailTableViewCell")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.dataSource = self
        tableView.delegate = self
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return order.details.count
    }
    

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TechresShopOrderInfoDetailTableViewCell", for: indexPath) as! TechresShopOrderInfoDetailTableViewCell
        cell.data = order.details[indexPath.row]
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
   }
    
}
 

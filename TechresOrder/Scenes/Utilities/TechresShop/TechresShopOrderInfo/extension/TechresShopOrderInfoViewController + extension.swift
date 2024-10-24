//
//  TechresShopOrderInfoViewController + extension.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 05/09/2024.
//

import UIKit
import RxSwift
import ObjectMapper

extension TechresShopOrderInfoViewController {
    func getTechresShopOrder() {
        appServiceProvider.rx.request(.getTechresShopOrder(product_order_status: -1, payment_status: -1))
        .filterSuccessfulStatusCodes()
        .mapJSON().asObservable()
        .showAPIErrorToast()
        .mapObject(type: APIResponse.self).subscribe(onNext: { [weak self] response in
            guard let self = self else { return }
           
        
            if (response.code == RRHTTPStatusCode.ok.rawValue) {
                if let res = Mapper<TechresShopOrderResponse>().map(JSONObject: response.data) {
                    viewModel.orderArray.accept(res.list)
                    tableView.reloadData()
                }
            } else if (response.code == RRHTTPStatusCode.badRequest.rawValue) {
                self.showWarningMessage(content: response.message ?? "")
            }
            

        }).disposed(by: rxbag)
        
    }
}

extension TechresShopOrderInfoViewController:UITableViewDataSource,UITableViewDelegate {
    
    func registerCell() {
        let cell = UINib(nibName: "TechresShopOrderInfoTableViewCell", bundle: .main)
        tableView.register(cell, forCellReuseIdentifier: "TechresShopOrderInfoTableViewCell")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.dataSource = self
        tableView.delegate = self
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.orderArray.value.count
    }
    

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TechresShopOrderInfoTableViewCell", for: indexPath) as! TechresShopOrderInfoTableViewCell
        cell.data = viewModel.orderArray.value[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // add order proccessing when load view
        let vc = TechresShopOrderInfoDetailViewController(nibName: "TechresShopOrderInfoDetailViewController", bundle: Bundle.main)
        vc.order = viewModel.orderArray.value[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
}
 

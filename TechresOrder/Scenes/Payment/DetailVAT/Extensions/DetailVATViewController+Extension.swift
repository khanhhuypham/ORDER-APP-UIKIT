//
//  DetailVATViewController+Extension.swift
//  TECHRES - Bán Hàng
//
//  Created by Kelvin on 20/03/2023.
//

import UIKit
import ObjectMapper
import RxSwift

extension DetailVATViewController {
    func getVATDetails(){
        viewModel.getVATDetails().subscribe(onNext: { (response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){
                if let vats = Mapper<VATOrder>().mapArray(JSONObject: response.data) {
                    var total = 0.0
                    vats.enumerated().forEach { (index, value) in
                        total += value.vat_amount
                    }
                    self.lbl_total_vat.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: Float(total))
                    self.viewModel.dataArray.accept(vats)
                    self.tableView.reloadData()

                }
            }else{
                dLog(response.message ?? "")
            }
         
        }).disposed(by: rxbag)
    }
}
extension DetailVATViewController:UITableViewDelegate{
    func registerCell() {
        let VATCategoryTableViewCell = UINib(nibName: "VATCategoryTableViewCell", bundle: .main)
        tableView.register(VATCategoryTableViewCell, forCellReuseIdentifier: "VATCategoryTableViewCell")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        tableView.rx.setDelegate(self).disposed(by: rxbag)
    }
    
    func bindTableViewData() {
       viewModel.dataArray.bind(to: tableView.rx.items(cellIdentifier: "VATCategoryTableViewCell", cellType: VATCategoryTableViewCell.self))
           {(row, vat, cell) in
               cell.viewModel = self.viewModel
               cell.data = vat
           }.disposed(by: rxbag)
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat((viewModel.dataArray.value[indexPath.row].order_details.count * 90) + 40)
    }
    
}


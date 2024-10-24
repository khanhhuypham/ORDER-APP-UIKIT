//
//  InformationApplicationViewController+Extension.swift
//  TECHRES-SEEMT
//
//  Created by Nguyen Thanh Vinh on 04/12/2023.
//  Copyright © 2023 OVERATE-VNTECH. All rights reserved.
//

import UIKit
import ObjectMapper
import RxCocoa

extension InformationApplicationViewController {
    func registerCell() {
        let itemVersionAppTableViewCell = UINib(nibName: "ItemVersionAppTableViewCell", bundle: .main)
        tableView.register(itemVersionAppTableViewCell, forCellReuseIdentifier: "ItemVersionAppTableViewCell")
        
        let infoVersionAppTableViewCell = UINib(nibName: "InfoVersionAppTableViewCell", bundle: .main)
        tableView.register(infoVersionAppTableViewCell, forCellReuseIdentifier: "InfoVersionAppTableViewCell")
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        
        refreshControl.tintColor = ColorUtils.orange_brand_900()
        refreshControl.attributedTitle = NSAttributedString(string: "Cập nhật dữ liệu mới",
                                                            attributes: [NSAttributedString.Key.foregroundColor: ColorUtils.orange_brand_900()])
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        tableView.addSubview(refreshControl) // not required when using UITableViewController
   }
    
   @objc func refresh(_ sender: AnyObject) {
      // Code to refresh table view
       getInforApp()
       refreshControl.endRefreshing()
   }
    
    func bindTableViewData() {
        viewModel.dataArray
            .bind(to: tableView.rx.items){ (tableView, index, element) in
                let indexPath = IndexPath(row: index, section: 0)
                if (indexPath.row == 0){
                    let cell = tableView.dequeueReusableCell(withIdentifier: "InfoVersionAppTableViewCell", for: indexPath) as! InfoVersionAppTableViewCell
                    cell.viewModel = self.viewModel
                    return cell
                } else {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "ItemVersionAppTableViewCell", for: indexPath) as! ItemVersionAppTableViewCell
                    cell.data = element
                    cell.constraint_top_root_view.constant = 0
                    cell.constraint_bottom_root_view.constant = 0
                    switch indexPath.row {
                        case 1:
                            cell.root_view.round(with: .top, radius: 10)
                            cell.constraint_top_root_view.constant = 16
                            break
                        case self.viewModel.dataArray.value.count - 1:
                            cell.root_view.round(with: .bottom, radius: 10)
                            cell.constraint_bottom_root_view.constant = 8
                            break
                        default:
                            break
                    }
                    return cell
                }
            }.disposed(by: rxbag)
    }
}

extension InformationApplicationViewController {
    func getInforApp() {
        viewModel.infoApp().subscribe(onNext: { (response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){
                if let dataFromServer = Mapper<ResponseListInfoApp>().map(JSONObject: response.data){
                    
                    var datas = self.viewModel.dataArray.value
                    datas.append(contentsOf: dataFromServer.list)
                    self.viewModel.dataArray.accept(datas)
                    
                }
            }else{
                dLog(response.message ?? "Có lỗi xảy ra trong quá trình kết nối tới máy chủ. Vui lòng thử lại")
            }
        }).disposed(by: rxbag)
    }
}

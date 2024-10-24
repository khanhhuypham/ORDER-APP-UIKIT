//
//  LinkStoreViewController+Extensions.swift
//  TECHRES-SEEMT
//
//  Created by Nguyen Thanh Vinh on 03/01/2024.
//  Copyright © 2024 OVERATE-VNTECH. All rights reserved.
//

import UIKit
import ObjectMapper
import RxCocoa
import RxSwiftExt

extension LinkStoreViewController {
    func registerCell() {
        let itemLinkInStoreTableViewCell = UINib(nibName: "ItemLinkInStoreTableViewCell", bundle: .main)
        tableView.register(itemLinkInStoreTableViewCell, forCellReuseIdentifier: "ItemLinkInStoreTableViewCell")
        tableView.separatorStyle = .none
        
        tableView.rx.modelSelected(MediaStore.self).subscribe(onNext: { [self] element in
            self.viewModel.makeToWebViewController(title_header: element.thumb.title, link_website: element.thumb.url)
        }).disposed(by: rxbag)
    
        tableView.rx.reachedBottom(offset: CGFloat(self.viewModel.limit.value))
                   .subscribe(onNext:  {
                       if (self.isLoadingMore) {
                           self.spinner.color = ColorUtils.blue_brand_700()
                           self.spinner.startAnimating()
                           self.spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: self.tableView.bounds.width, height: CGFloat(55))
                           self.tableView.tableFooterView = self.spinner
                           self.tableView.tableFooterView?.isHidden = false

                           DispatchQueue.main.async { [self] in
                               let position = self.viewModel.dataArray.value.last?.position ?? ""
                               self.viewModel.position.accept(position)
                               self.isLoadingMore = false
                               self.getListMedia()
                           }
                       }
                   }).disposed(by: rxbag)
        
        refreshControl.tintColor = ColorUtils.blue_brand_700()
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        tableView.addSubview(refreshControl) // not required when using UITableViewController
   }
    
   @objc func refresh(_ sender: AnyObject) {
       self.isLoadingMore = true
       self.viewModel.position.accept("")
       self.viewModel.dataArray.accept([])
       self.getListMedia()
       refreshControl.endRefreshing()
   }
    
    func bindTableViewData() {
        viewModel.dataArray.bind(to: tableView.rx.items(cellIdentifier: "ItemLinkInStoreTableViewCell", cellType: ItemLinkInStoreTableViewCell.self))
        {(row, item, cell) in
            cell.data = item
            if row == 0 {
                cell.lbl_time_group.text = item.time
                cell.constraint_top_lbl_time_group.constant = 10
                cell.constraint_bottom_lbl_time_group.constant = 10
            } else {
                if item.is_day_different == ACTIVE {
                    cell.lbl_time_group.text = item.time
                    cell.constraint_top_lbl_time_group.constant = 20
                    cell.constraint_bottom_lbl_time_group.constant = 10
                } else {
                    cell.lbl_time_group.text = ""
                    cell.constraint_top_lbl_time_group.constant = 0
                    cell.constraint_bottom_lbl_time_group.constant = 0
                }
            }
        }.disposed(by: rxbag)
    }
}

extension LinkStoreViewController {
    func getListMedia() {
        viewModel.getListMedia().subscribe(onNext: { (response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue) {
                if var dataFromServer = Mapper<MediaStore>().mapArray(JSONObject: response.data) {
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                    if dataFromServer.count > 1 {
                        for i in 1..<dataFromServer.count {
                            let calendar = Calendar.current
                            let date1 = calendar.dateComponents([.day, .month, .year], from: dateFormatter.date(from: dataFromServer[i].created_at)!)
                            let date2 = calendar.dateComponents([.day, .month, .year], from: dateFormatter.date(from: dataFromServer[i - 1].created_at)!)

                            if date1 != date2 {
                                dataFromServer[i].is_day_different = 1
                            }
                        }
                    }
                    var newData = self.viewModel.dataArray.value
                    newData.append(contentsOf: dataFromServer)
                    self.viewModel.dataArray.accept(newData)
                    Utils.isHideAllView(isHide: newData.count > 0, view: self.root_view_empty_data)
                    self.isLoadingMore = dataFromServer.count > 0
                    self.spinner.stopAnimating()
                }
            } else {
                dLog(response.message ?? "Có lỗi xảy ra trong quá trình kết nối tới máy chủ. Vui lòng thử lại")
            }
        }).disposed(by: rxbag)
    }
}

//
//  OrderManagementOfFoodAppViewController + extension + registerCell.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 20/08/2024.
//


import UIKit
import RxSwift
import RxRelay
import JonAlert
//MARK: this extension is used to register cell==
extension OrderManagementOfFoodAppViewController:UITableViewDelegate{
    func bindTableViewAndRegisterCell(){
        registerCell()
        bindTableViewData()
    }
    
    private func registerCell() {
        let cell = UINib(nibName: "OrderManagementOfFoodAppTableViewCell", bundle: .main)
        tableView.register(cell, forCellReuseIdentifier: "OrderManagementOfFoodAppTableViewCell")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
        tableView.rx.setDelegate(self).disposed(by: rxbag)
        
        refreshControl.attributedTitle = NSAttributedString(string: "")
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        tableView.addSubview(refreshControl) // not required when using UItableViewController
    }
    
    
    @objc func refresh(_ sender: AnyObject) {
          // Code to refresh table view
     
        refreshControl.endRefreshing()
    }
    
    
    private func bindTableViewData() {
        viewModel.history.map{$0.list}.bind(to: tableView.rx.items(cellIdentifier: "OrderManagementOfFoodAppTableViewCell", cellType: OrderManagementOfFoodAppTableViewCell.self)){  (row, data, cell) in
            cell.data = data
        }.disposed(by: rxbag)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let order = viewModel.history.value.list[indexPath.row]
        viewModel.makeOrderHistoryDetailOfFoodAppViewController(order: order)
    }
}


extension OrderManagementOfFoodAppViewController{
    func showDropDown(btn:UIButton,list:[String]){
        var listName = [String]()
        var listIcon = [String]()
           
        for element in list {
            listName.append(element)
            listIcon.append("baseline_account_balance_black_48pt")
        }
           
        let controller = ArrayChooseViewController(Direction.allValues)
        
        controller.list_icons = listIcon
        controller.listString = listName
        controller.preferredContentSize = CGSize(width: btn.frame.width, height: 200)
        controller.delegate = self
        
        showPopup(controller, sourceView: btn)
    }

    
    private func showPopup(_ controller: UIViewController, sourceView: UIView) {
        let presentationController = AlwaysPresentAsPopover.configurePresentation(forController: controller)
        presentationController.sourceView = sourceView
        presentationController.permittedArrowDirections = UIPopoverArrowDirection.init(rawValue: 0)
        presentationController.sourceRect = CGRectMake(sourceView.bounds.origin.x, sourceView.bounds.origin.y + 135, sourceView.bounds.width, sourceView.bounds.height)
        self.present(controller, animated: true)
    }
    
}
extension OrderManagementOfFoodAppViewController: ArrayChooseViewControllerDelegate{
    
    func selectAt(pos: Int) {
        
        var history = viewModel.history.value
        
        switch viewModel.filterType.value{
            case 1:
              
                history.reportType = viewModel.reportTypeFilter.value.map{$0.key}[pos]
                history.dateString = Constants.REPORT_TYPE_DICTIONARY[history.reportType] ?? ""
            
                btn_reportType_filter.setTitle(viewModel.reportTypeFilter.value.map{$0.value}[pos], for: .normal)
            
            
                let attr:NSAttributedString = Utils.setAttributesForBtn(
                    content: viewModel.reportTypeFilter.value.map{$0.value}[pos],
                    attributes: [
                        NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .regular),
                        NSAttributedString.Key.foregroundColor: ColorUtils.black()
                    ]
                )
            
                btn_reportType_filter.setAttributedTitle(attr,for: .normal)
            

                
            case 2:
                history.partnerId = viewModel.partnerFilter.value.map{$0.value}[pos]
             
                let attr:NSAttributedString = Utils.setAttributesForBtn(
                    content: viewModel.partnerFilter.value.map{$0.key}[pos],
                    attributes: [
                        NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .regular),
                        NSAttributedString.Key.foregroundColor: ColorUtils.black()
                    ]
                )
            
                btn_partner_filter.setAttributedTitle(attr,for: .normal)
        
            
                break
            
            default:
                return
        }
        
        viewModel.history.accept(history)
        
        getOrderHistoryOfFoodApp()
    }
    
}




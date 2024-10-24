//
//  OrderDetailRebuildViewController + extension + registerCell.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 01/09/2023.
//

import UIKit
import RxSwift
import RxRelay
import JonAlert
//MARK: this extension is used to register cell==
extension OrderDetailViewController:UITableViewDelegate{
    func bindTableViewAndRegisterCell(){
        registerCell()
        bindTableViewData()
    }
    
    private func registerCell() {
        let orderDetailTableViewCell = UINib(nibName: "OrderDetailTableViewCell", bundle: .main)
        tableView.register(orderDetailTableViewCell, forCellReuseIdentifier: "OrderDetailTableViewCell")
        tableView.rx.setDelegate(self).disposed(by: rxbag)
        
        refreshControl.attributedTitle = NSAttributedString(string: "")
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        tableView.addSubview(refreshControl) // not required when using UItableViewController
    }
    
    
    @objc func refresh(_ sender: AnyObject) {
          // Code to refresh table view
        getOrder()
        refreshControl.endRefreshing()
    }
    
    
    private func bindTableViewData() {
        viewModel.order.map{$0.order_details}.bind(to: tableView.rx.items(cellIdentifier: "OrderDetailTableViewCell", cellType: OrderDetailTableViewCell.self))
           {  (row, orderDetail, cell) in
               cell.viewModel = self.viewModel
               cell.data = orderDetail
           }.disposed(by: rxbag)
       }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var order = viewModel.order.value
        let order_detail = order.order_details[indexPath.row]
        
        let conditionForReturnBeer = (order_detail.category_type == .drink || order_detail.category_type == .other)
            && order_detail.status == .done
            && order_detail.enable_return_beer == ACTIVE
            && order_detail.quantity > 0
            && order_detail.buffet_ticket_id == 0
        
        let conditionForFood = order_detail.status == .pending && order_detail.is_gift == DEACTIVE && order_detail.is_bbq == DEACTIVE
        
        if(order_detail.status != .not_enough || order_detail.status != .cancel) {
            
            
            if conditionForReturnBeer{
                
                presentModalReturnBeerViewController(order_id:order.id, order_detail_id:order_detail.id, quantity:Int(order_detail.quantity))
                
            }else{
                if conditionForFood{
    
                    if order_detail.is_booking_item == ACTIVE && order_detail.category_type == .food{
                       return
                    }

                    if order_detail.is_gift == DEACTIVE && order_detail.order_detail_promotion_foods.count == 0{
                        // món tặng và món khuyến mãi và món booking không được phép chỉnh sửa số lượng
                        var item =  order.order_details[indexPath.row]
                        item.setQuantity(quantity: item.quantity + (item.is_sell_by_weight == ACTIVE ? 0.01 : 1))
                        order.order_details[indexPath.row] = item
                        viewModel.order.accept(order)
                    }
                }
            }
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let item = viewModel.order.value.order_details[indexPath.row]
     
        // cancelFood action
        let cancelFood = UIContextualAction(style: .normal,title: ""){[weak self] (action, view, completionHandler) in
            
            self?.handleCancelFood(item: item)
            completionHandler(true)
        }
        cancelFood.backgroundColor = ColorUtils.red_500()
        cancelFood.image = UIImage(named: "icon-cancel-item-bg-red")
        
        
        // split item action
        let splitFood = UIContextualAction(style: .normal,title: "") {[weak self] (action, view, completionHandler) in
            self?.viewModel.foodsNeedToSplit.accept([item])
            Utils.checkRoleManagerOrder(permission: ManageCacheObject.getCurrentUser().permissions)
            ? self!.presentModalSeparateFoodViewController(order: self!.viewModel.order.value, only_one: ACTIVE)
            : JonAlert.showError(message: "Bạn chưa được cấp quyền sử dụng tính năng này vui lòng liên hệ quản lý", duration: 2.0)
            
            completionHandler(true)
        }
        splitFood.backgroundColor = ColorUtils.green_600()
        splitFood.image = UIImage(named: "icon-split-food-bg-green")
        
        // discount action
        let discount = UIContextualAction(style: .normal, title: "") { [weak self] (action, view, completionHandler) in
            
            if permissionUtils.discountOrderItem {
                item.discount_percent != 0
                ? self?.presentPopupDiscountViewController(itemId:item.id, percent:item.discount_percent)
                : self?.presentPopupDiscountViewController(itemId:item.id)
            }else{
                self?.showWarningMessage(content: "Bạn chưa được cấp quyền sử dụng tính năng này vui lòng liên hệ quản lý")
            }
            
            completionHandler(true)
        }
        discount.backgroundColor = ColorUtils.orange_brand_900()
        discount.image = UIImage(named: "icon-discount-orange")
        
        // note action
        let noteFood = UIContextualAction(style: .normal,title: "") {[weak self] (action, view, completionHandler) in
            self?.presentModalNoteViewController(
                pos: indexPath.row,
                note: item.note,
                order_detail_id: item.food_id)
            completionHandler(true)
        }
        noteFood.backgroundColor = ColorUtils.gray_600()
        noteFood.image = UIImage(named: "icon-note-bg-gray")
        
        // edit service
        let editItem = UIContextualAction(style: .normal,title: "") {[weak self] (action, view, completionHandler) in
            
        
                switch item.category_type {
    
                    case .service:
                        self?.presentServicePopupViewController(orderItem: item)
                        break
                    
                    case .buffet_ticket:
                        permissionUtils.BuffetManager
                        ? self?.presentEditBuffetTicketViewController(buffet: self?.viewModel.order.value.buffet)
                        : self?.showWarningMessage(content: "Bạn chưa được cấp quyền sử dụng tính năng này vui lòng liên hệ quản lý")
                        break
                
                    default:
                        self!.presentEditChildrenFoodViewController(orderItem: item)
                        break
                }
            completionHandler(true)
        }
        
        editItem.backgroundColor = ColorUtils.blue_brand_700()
        editItem.image = UIImage(named: "icon-edit-service-bg-blue")
        
        
        var action:[UIContextualAction] = []

        switch item.status {
            
            case .pending:
                if item.buffet_ticket_id > 0{
                    action = [cancelFood,noteFood]
                }else{
                    if item.is_gift == ACTIVE{
                        action = item.order_detail_additions.count > 0
                        ? [cancelFood,splitFood,editItem,noteFood]
                        : [cancelFood,splitFood,noteFood]
                    }else{
                        action = item.order_detail_additions.count > 0
                        ? [cancelFood,splitFood,editItem,discount,noteFood]
                        : [cancelFood,splitFood,discount,noteFood]
                    }
                }
            
            case .done,.cooking:
                
                switch item.category_type {
                    case .buffet_ticket:
                        action = [cancelFood,editItem]
                    
                
                    case .drink, .other:
                        if item.quantity == 0 && item.buffet_ticket_id == 0{
                            action = []
                        }else{
                            action = item.is_gift == ACTIVE || item.is_extra_Charge == ACTIVE
                            ? [cancelFood,splitFood]
                            : [cancelFood,discount,splitFood]
                        }
                    
                    default:
                        if item.buffet_ticket_id > 0{
                            action = [cancelFood]
                        }else{
                            action = item.is_gift == ACTIVE || item.is_extra_Charge == ACTIVE ? [cancelFood,splitFood] : [cancelFood,discount,splitFood]
                        }
                        
                }
                
            case .cancel,.not_enough:
                action = []
            
            case .servic_block_stopped,.servic_block_using:
                action = [cancelFood, splitFood, editItem]
        
        }
        
        
        if item.is_booking_item == ACTIVE{ //nếu là món booking
            action = item.category_type == .drink ? [cancelFood,noteFood] : []
        }
        
        let configuration = UISwipeActionsConfiguration(actions: action)
        configuration.performsFirstActionWithFullSwipe = false
 
              
        return configuration
    }
}

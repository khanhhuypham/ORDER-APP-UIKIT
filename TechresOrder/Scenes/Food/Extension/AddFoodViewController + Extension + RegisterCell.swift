//
//  AddFood_RebuildViewController + Extension + RegisterCell.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 07/09/2023.
//

import UIKit
import ObjectMapper
import RxSwift
import RxRelay
import RxCocoa
import RxSwiftExt
import RxDataSources

extension AddFoodViewController:UITextFieldDelegate,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UIScrollViewDelegate,UITableViewDelegate{
    
    func registerCellAndBindTableView(){
        registerCell()
        bindTableViewData()
    }

    private func registerCell() {

        let cellIdentifiers = ["AddFoodTableViewCell","BuffetTicketTableViewCell","cell"]
        
        // Register cells using a for loop
        for identifier in cellIdentifiers {
            let cell = UINib(nibName: identifier, bundle: .main)
            tableView.register(cell, forCellReuseIdentifier: identifier)
        }
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.singleLine
        tableView.tableHeaderView = self.spinner
        tableView.tableFooterView = self.spinner
        tableView.delegate = self


        let categoryCollectionViewCell = UINib(nibName: "CategoryCollectionViewCell", bundle: .main)
        collectionView.collectionViewLayout.invalidateLayout()
        collectionView.register(categoryCollectionViewCell, forCellWithReuseIdentifier: "CategoryCollectionViewCell")
        collectionView.delegate = self
        
    }
    
    
    private func bindTableViewData() {
        // datasource
        let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<FOOD_CATEGORY, Any>> (
            
            // for cell
            configureCell: { (dataSource, tableView, indexPath, item) in
    
                guard let section = dataSource.sectionModels.first else {
                    return tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
                }
                
                switch section.model{
                 
                    case .buffet_ticket:
                        let cell = tableView.dequeueReusableCell(withIdentifier:"BuffetTicketTableViewCell" ) as! BuffetTicketTableViewCell
                        cell.viewModel = self.viewModel
                        cell.data = item as? Buffet
                        return cell
                    
                    default:
                        let cell = tableView.dequeueReusableCell(withIdentifier: "AddFoodTableViewCell") as! AddFoodTableViewCell
                        cell.viewModel = self.viewModel
                        cell.data = item as? Food
//                        let food = item as? Food
//                    
//                        if let selectedFood = self.viewModel.selectedFood.value.first(where: {$0.id == food?.id}){
//                            cell.data = selectedFood
//                        }else{
//                            cell.data = food
//                        }
//                        
                        return cell
                    
                }
                

            }
    
        )

        
        // bind
        viewModel.sectionArray.bind(to: tableView.rx.items(dataSource: dataSource)).disposed(by: rxbag)
        

        viewModel.categoryArray.bind(to: collectionView.rx.items(cellIdentifier: "CategoryCollectionViewCell", cellType: CategoryCollectionViewCell.self))
        {(index, element, cell) in
            cell.viewModel = self.viewModel
            cell.data = element
        }.disposed(by: rxbag)
        
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if let section = viewModel.sectionArray.value.first {
            switch section.model {
                case .buffet_ticket:
                    if var item = section.items[indexPath.row] as? Buffet {
                        let discount = UIContextualAction(style: .normal, title: "") { [weak self] (action, view, completionHandler) in
                            
                            
                            if permissionUtils.discountOrderItem {
                                self?.presentPopupEnterPercentForBuffetViewController(buffet: item)
                            }else{
                                self?.showWarningMessage(content: "Bạn chưa được cấp quyền sử dụng tính năng này vui lòng liên hệ quản lý")
                            }
                            
                            completionHandler(true)
                        }
                        
                        discount.backgroundColor = ColorUtils.orange_brand_900()
                        discount.image = UIImage(named: "icon-discount-orange")
                        
                        // Create and return UISwipeActionsConfiguration with the defined action
                        let configuration = UISwipeActionsConfiguration(actions: [discount])
                        configuration.performsFirstActionWithFullSwipe = false
                        return configuration
                    }else{
                        return nil
                    }
                
                   
                default:
                    // For other section models (assuming they contain Food items)
                    if let item = section.items[indexPath.row] as? Food {
                        // Check if the item's is_out_stock status is DEACTIVE
                        if item.is_out_stock == DEACTIVE {
                            // Define the swipe action to present the note modal
                            let note = UIContextualAction(style: .normal, title: "") { [weak self] (action, view, completionHandler) in
                                self?.presentModalNoteViewController(pos: indexPath.row, id: item.id, note: item.note)
                                completionHandler(true)
                            }
                            note.backgroundColor = ColorUtils.gray_600()
                            note.image = UIImage(named: "icon-note-bg-gray")
                            
                            
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
                            
                            // Create and return UISwipeActionsConfiguration with the defined action
                            let configuration = UISwipeActionsConfiguration(actions:item.buffet_ticket_ids != nil || is_gift == ACTIVE
                                                                                ? [note]
                                                                                : [discount,note]
                            )
                            configuration.performsFirstActionWithFullSwipe = false
                            return configuration
                        } else {
                            // Return nil to disable swipe actions when is_out_stock is not DEACTIVE
                            return nil
                        }
                    }
                }
        }
        return nil
    }

    
    
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        var p = viewModel.APIParameter.value
        let tableViewContentHeight = tableView.contentSize.height
        let tableViewHeight = tableView.frame.size.height
        let scrollOffset = scrollView.contentOffset.y
        self.spinner.startAnimating()

        if scrollOffset + tableViewHeight >= tableViewContentHeight {  // scroll downward
          
            if(!p.isGetFullData && !p.isAPICalling){

                self.tableView.tableFooterView?.isHidden = false
                
                p.page += 1
                p.isAPICalling = true
                viewModel.APIParameter.accept(p)
                
                switch p.category_type{
                    case .buffet_ticket:
                        getBuffetTickets()
                    default:
                        self.fetFoods()
                }
                
                
            }
            
           
        }else if scrollOffset < -80 { // scroll upward

            self.tableView.tableHeaderView?.isHidden = false
            switch p.category_type{
                case .buffet_ticket:
                    getBuffetTickets()
                default:
                    self.fetFoods()
            }
           
        }
    }
    
    
    
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool{
        textfield_search.text = ""
        var APIParameter = viewModel.APIParameter.value
        APIParameter.key_word = ""
        viewModel.APIParameter.accept(APIParameter)
        fetFoods()
        return true
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let string = viewModel.categoryArray.value[indexPath.row].name
        let font = UIFont.systemFont(ofSize: 14,weight: .semibold)
        let width = string.sizeOfString(usingFont: font).width //
        
        //(2(margin-right of view) + 2(margin-left of view) + 20 (margin of label))
        return CGSize(width: width + 10 + (2 + 2 + 20), height: collectionView.frame.size.height)
    }
    
}




//
//  ChatChannel + extension + registercell.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 06/05/2024.
//

import UIKit
import RxCocoa


extension ChatChannelViewController {
    
    func registerCellAndBindTable(){
        registerCell()
        bindTableView()
    }
    
    
    //MARK: Register Cells as you want
    func registerCell(){
        
        let cell = UINib(nibName: "MessageCellTableViewCell", bundle: .main)
        tableView.register(cell, forCellReuseIdentifier: "MessageCellTableViewCell")
        tableView.separatorStyle = .none
        
    }
    
    func bindTableView(){
        
        viewModel.messageList.bind(to: tableView.rx.items(cellIdentifier: "MessageCellTableViewCell", cellType: MessageCellTableViewCell.self))
        {  (row, message, cell) in
            cell.index = row
            cell.viewModel = self.viewModel
            cell.isLastMessage = row == 0 && message.user.user_id == Constants.user.id
            cell.data = message
            cell.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
        }.disposed(by: rxbag)
        
        
    }
    
}

extension ChatChannelViewController: UITableViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        btn_scroll_bottom_table.isHidden = offsetY < 200
    }
    
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        
        let tableViewContentHeight = tableView.contentSize.height
        let tableViewHeight = tableView.frame.size.height
        let scrollOffset = scrollView.contentOffset.y
        
        if scrollOffset + tableViewHeight >= tableViewContentHeight {  // Scroll To Top
            if !isLastPage {
                let newData = viewModel.messageList.value
                viewModel.conversationPosition.accept(newData.last?.position ?? "")
                view_loading_more.isHidden = false
                loading_more_message.startAnimating()
                viewModel.conversationArrow.accept(1)
                getMessageList()
            }
        } else if scrollOffset < -80 { // Scroll To Bottom
            if !isFirstPage {
                let newData = viewModel.messageList.value
                viewModel.conversationPosition.accept(newData.first?.position ?? "")
                view_loading_more.isHidden = false
                loading_more_message.startAnimating()
                viewModel.conversationArrow.accept(2)
                getMessageList()
            }
        }
    }
    
}

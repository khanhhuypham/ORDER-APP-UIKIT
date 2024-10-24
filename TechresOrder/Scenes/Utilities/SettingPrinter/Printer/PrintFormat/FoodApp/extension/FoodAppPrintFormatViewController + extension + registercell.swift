//
//  FoodAppPrintFormatViewController + extension + registercell.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 21/08/2024.
//

import UIKit

extension FoodAppPrintFormatViewController {


    func bindTableViewAndRegisterCell(){
        registerCell()
        bindTableViewData()
    }
    
    private func registerCell() {
        let cell = UINib(nibName: "Bill3TableViewCell", bundle: .main)
        tableView.register(cell, forCellReuseIdentifier: "Bill3TableViewCell")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.isScrollEnabled = false
    
    }
    
    private func bindTableViewData() {
        viewModel.order.map{$0.details}.bind(to: tableView.rx.items(cellIdentifier: "Bill3TableViewCell", cellType: Bill3TableViewCell.self)){(row, item, cell) in
            let item = self.viewModel.order.value.details[row]
            
           
            //=====================================================If having children item==========================================================================================
            var orderItem = OrderItem(name: item.name, price: Int(item.price), quantity: Float(item.quantity), total_price: item.total_price_addition)
            orderItem.total_price_include_addition_foods = item.total_price_addition
            orderItem.note = item.note
            
            for child in item.food_options{
                orderItem.order_detail_additions.append(OrderDetailAddition(
                    id: 0,
                    name: child.name,
                    quantity: Float(child.quantity),
                    price: child.price,
                    total_price: child.quantity*child.price)
                )
            }
            //===================================================================================================================================================================================
            cell.view_of_food_note.isHidden = item.note.count == 0 ? true : false
            cell.data = orderItem
            
            if row != (self.viewModel.order.value.details.count  - 1) {
                let A = CGPoint(x: 0, y: cell.underlineView.bounds.height)
                let B = CGPoint(x: cell.underlineView.bounds.width, y: cell.underlineView.bounds.height)
                self.createDashedLine(parentView:cell.underlineView,from: A, to: B, color: self.textColor, strokeLength: 10, gapLength: 2, width: 2)
            }
            
        }.disposed(by: rxbag)
    }
    
    

    func createDashedLine(parentView:UIView,from point1: CGPoint, to point2: CGPoint, color: UIColor, strokeLength: NSNumber, gapLength: NSNumber, width: CGFloat) {
        let shapeLayer = CAShapeLayer()
        let path = CGMutablePath()
        
        shapeLayer.strokeColor = color.cgColor
        shapeLayer.lineWidth = width
        shapeLayer.lineDashPattern = [strokeLength, gapLength]
        
        path.addLines(between: [point1, point2])
        shapeLayer.path = path
        parentView.layer.addSublayer(shapeLayer)
      
    }

    
    
}

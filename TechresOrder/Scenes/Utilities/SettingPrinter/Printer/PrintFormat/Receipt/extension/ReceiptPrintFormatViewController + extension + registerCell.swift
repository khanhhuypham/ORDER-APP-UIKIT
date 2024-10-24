//
//  ReceiptPrintFormatViewController + extension.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 05/04/2024.
//

import UIKit

extension ReceiptPrintFormatViewController {

    func registerCell(){
        
        if permissionUtils.GPBH_1{
            let cell = UINib(nibName: "Bill3TableViewCell", bundle: .main)
            tableView.register(cell, forCellReuseIdentifier: "Bill3TableViewCell")
        }else {
            
            switch Constants.bill_type{
                case .bill1:
                    let cell = UINib(nibName: "Bill1TableViewCell", bundle: .main)
                    tableView.register(cell, forCellReuseIdentifier: "Bill1TableViewCell")
                case .bill2:
                    let cell = UINib(nibName: "Bill2TableViewCell", bundle: .main)
                    tableView.register(cell, forCellReuseIdentifier: "Bill2TableViewCell")
                case .bill3:
                    let cell = UINib(nibName: "Bill3TableViewCell", bundle: .main)
                    tableView.register(cell, forCellReuseIdentifier: "Bill3TableViewCell")
                case .bill4:
                    let cell = UINib(nibName: "Bill4TableViewCell", bundle: .main)
                    tableView.register(cell, forCellReuseIdentifier: "Bill4TableViewCell")
            
            }
        }
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.isScrollEnabled = false
        tableView.dataSource = self
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return order?.order_details.count ?? 0
    }


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if permissionUtils.GPBH_1{
            let cell = tableView.dequeueReusableCell(withIdentifier: "Bill3TableViewCell", for: indexPath) as! Bill3TableViewCell
            cell.data = order?.order_details[indexPath.row]
            return cell

        }else{

            switch Constants.bill_type{
                case .bill1:
                    let cell = tableView.dequeueReusableCell(withIdentifier: "Bill1TableViewCell", for: indexPath) as! Bill1TableViewCell
                    cell.data = order?.order_details[indexPath.row]
                    return cell

                case .bill2:
                    let cell = tableView.dequeueReusableCell(withIdentifier: "Bill2TableViewCell", for: indexPath) as! Bill2TableViewCell
                    cell.data = order?.order_details[indexPath.row]
                    return cell

                case .bill3:
                    let cell = tableView.dequeueReusableCell(withIdentifier: "Bill3TableViewCell", for: indexPath) as! Bill3TableViewCell
                    cell.data = order?.order_details[indexPath.row]

                    if indexPath.row != ((order?.order_details.count ?? 0) - 1) {
                        let A = CGPoint(x: 0, y: cell.underlineView.bounds.height)
                        let B = CGPoint(x: cell.underlineView.bounds.width, y: cell.underlineView.bounds.height)
                        createDashedLine(parentView:cell.underlineView,from: A, to: B, color: self.textColor, strokeLength: 10, gapLength: 2, width: 2)
                    }

                    return cell

                case .bill4:
                    let cell = tableView.dequeueReusableCell(withIdentifier: "Bill4TableViewCell", for: indexPath) as! Bill4TableViewCell
                    cell.data = order?.order_details[indexPath.row]
                    if indexPath.row != ((order?.order_details.count ?? 0) - 1) {
                        let A = CGPoint(x: 0, y: cell.underlineView.bounds.height)
                        let B = CGPoint(x: cell.underlineView.bounds.width, y: cell.underlineView.bounds.height)
                        createDashedLine(parentView:cell.underlineView,from: A, to: B, color: self.textColor, strokeLength: 10, gapLength: 2, width: 2)
                    }
                    return cell
            }
        }
        
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


//
//  Extensions.swift
//  CustomTabBarExample
//
//  Created by kelvin on 18/12/2022.
//

import UIKit
import RealmSwift
import ObjectMapper




extension UIStackView {
    func addArrangedSubviews(_ subviews: [UIView]) {
        subviews.forEach { addArrangedSubview($0) }
    }
}

//extension UITableView {
//    
//    func getAllCells() -> [UITableViewCell] {
//        var cells = [UITableViewCell]()
//        for i in 0..<self.numberOfSections
//        {
//            for j in 0..<self.numberOfRows(inSection: i)
//            {
//                if let cell = self.cellForRow(at: IndexPath(row: j, section: i)) {
//                    cells.append(cell)
//                }
//                
//            }
//        }
//        return cells
//    }
//}


extension Results{

    func get <T:Object> (offset: Int, limit: Int ) -> Array<T>{
        //create variables
        var lim = 0 // how much to take
        var off = 0 // start from
        var l: Array<T> = Array<T>() // results list

        //check indexes
        if off<=offset && offset<self.count - 1 {
            off = offset
        }
        if limit > self.count {
            lim = self.count
        }else{
            lim = limit
        }

        //do slicing
        for i in off..<lim{
            let dog = self[i] as! T
            l.append(dog)
        }

        //results
        return l
    }
}

//
//  TableCollectionViewCell.swift
//  TechresOrder
//
//  Created by Kelvin on 13/01/2023.
//

import UIKit
import RxRelay

class TableCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var lbl_table_name: UILabel!
    @IBOutlet weak var image_table: UIImageView!

    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    public var data: Table? = nil{
        didSet{
            mapData(table: data ?? Table())
        }
    }
    
    private func mapData(table:Table){
        lbl_table_name.text = table.name
        lbl_table_name.textColor = .white
        
        switch table.status{
            
            case STATUS_TABLE_USING:
                image_table.image = UIImage(named: "icon-table-active")
                break
            
            case STATUS_TABLE_CLOSED:
                image_table.image = UIImage(named: "icon-table-inactive")
                lbl_table_name.textColor = ColorUtils.dimGrayColor()
                break
            
            case STATUS_TABLE_MERGED:
                image_table.image = UIImage(named: "icon-table-waiting-payment")
                break
            
            default:
                image_table.image = UIImage(named: "icon-table-booking")
                break
    
        }
        
       
    }
    
}

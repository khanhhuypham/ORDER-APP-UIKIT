//
//  DialogChooseTableCollectionViewCell.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 17/01/2024.
//

import UIKit

class DialogChooseTableCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var lbl_table_name: UILabel!
    @IBOutlet weak var image_table: UIImageView!
    @IBOutlet weak var image_check: UIImageView!
    
    
    var option:OrderAction = .moveTable
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    public var data: Table? = nil{
        didSet{
            lbl_table_name.text = data?.name
            lbl_table_name.textColor = .white
            
            switch data?.status{
                case STATUS_TABLE_USING:
                    image_table.image = UIImage(named: "icon-table-active")
                case STATUS_TABLE_CLOSED:
                    image_table.image = UIImage(named: "icon-table-inactive")
                    lbl_table_name.textColor = ColorUtils.dimGrayColor()
                case STATUS_TABLE_BOOKING:
                    image_table.image = UIImage(named: "icon-table-booking")
                default:
                    break
            }
            
            if option == .mergeTable{
                image_check.isHidden = data?.is_selected == ACTIVE ? false : true
            }else{
                image_check.isHidden = true
            }
            
         
           
        }
    }

}


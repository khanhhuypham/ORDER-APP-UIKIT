//
//  ManagementAreaCollectionViewCell.swift
//  TechresOrder
//
//  Created by Kelvin on 23/01/2023.
//

import UIKit

class AreaManagementCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var view_cell: UIView!
    
    @IBOutlet weak var lbl_area_name: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    public var data: Area? = nil{
        didSet{
            lbl_area_name.text = data?.name
            self.backgroundColor = data?.status == DEACTIVE ? ColorUtils.gray_300() : ColorUtils.blue_brand_700()
        }
    }

}

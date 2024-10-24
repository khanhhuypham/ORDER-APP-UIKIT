//
//  AreaCollectionViewCell.swift
//  TechresOrder
//
//  Created by macmini_techres_03 on 14/01/2023.
//

import UIKit

class AreaCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var view_bg: UIView!
    @IBOutlet weak var lbl_area_name: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
   
    
    public var data: Area? = nil{
        didSet{
            lbl_area_name.text = data?.name
            view_bg.backgroundColor = data!.is_select == ACTIVE ? ColorUtils.orange_brand_900() : .white
            lbl_area_name.textColor = data!.is_select == ACTIVE ? ColorUtils.white() : ColorUtils.orange_brand_900()
         
        }
    }
    
}

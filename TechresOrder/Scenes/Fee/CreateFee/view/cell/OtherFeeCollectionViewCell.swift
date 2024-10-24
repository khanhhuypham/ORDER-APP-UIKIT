//
//  OtherFeeCollectionViewCell.swift
//  TechresOrder
//
//  Created by Kelvin on 31/01/2023.
//

import UIKit
class OtherFeeCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var image_light: UIImageView!
    @IBOutlet weak var lbl_fee_name: UILabel!
  
    @IBOutlet weak var view_boder: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
   
    public var data: Fee? = nil{
        didSet{
            lbl_fee_name.text = data?.object_name
            
            
            if(data?.isSelect == ACTIVE){
                view_boder.backgroundColor = ColorUtils.orange_brand_700()
                image_light.image = UIImage(named: "icon-light-gray")
                lbl_fee_name.textColor = ColorUtils.white()

            }else{
                view_boder.backgroundColor = ColorUtils.white()
                image_light.image = UIImage(named: "icon-light-orange")
                lbl_fee_name.textColor = ColorUtils.orange_brand_700()
            }
            

        }
    }
}

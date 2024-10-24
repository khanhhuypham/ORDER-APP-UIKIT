//
//  UpdateOtherFeedCollectionViewCell.swift
//  ORDER
//
//  Created by Macbook Pro M1 Techres - BE65F182D41C on 17/06/2023.
//

import UIKit

class UpdateOtherFeedCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var image_light: UIImageView!
    @IBOutlet weak var view_boder: UIView!
    @IBOutlet weak var lbl_fee_name: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    public var data: Fee? = nil{
        didSet{
            lbl_fee_name.text = data?.object_name
            dLog(data?.isSelect)
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

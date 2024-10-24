//
//  ReasonCancelFoodTableViewCell.swift
//  TechresOrder
//
//  Created by Kelvin on 18/01/2023.
//

import UIKit

class ReasonCancelFoodTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lbl_reason_name: UILabel!
    @IBOutlet weak var image_check: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(false, animated: false)

        // Configure the view for the selected state
    }
    public var data: ReasonCancel? = nil{
        didSet{
            lbl_reason_name.text = data?.content
            image_check.image = UIImage(named: data?.is_select == 1 ? "icon-radio-checked" : "icon-radio-uncheck")
        }
    }
}

//
//  AppFoodTableViewCell.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 29/07/2024.
//

import UIKit

class AppFoodTableViewCell: UITableViewCell {

    @IBOutlet weak var lbl_partner_name: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    // MARK: - Variable -
    public var data: FoodAppAPartner? = nil {
       didSet {
           mapData(data: data!)
       }
    }
    
    private func mapData(data: FoodAppAPartner){
        lbl_partner_name.textColor = ColorUtils.gray_600()
        lbl_partner_name.text = data.name

    }
    
}

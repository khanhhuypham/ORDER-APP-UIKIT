//
//  TokenListOfFoodAppTableViewCell.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 30/09/2024.
//

import UIKit

class TokenListOfFoodAppTableViewCell: UITableViewCell {
    @IBOutlet weak var lbl_name: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // MARK: - Variable -
    public var data: PartnerCredential? = nil {
       didSet {
           mapData(data: data!)
       }
    }
    
    private func mapData(data: PartnerCredential){
        lbl_name.text = String(format: "%@ %@", data.name ?? "", data.is_connection == ACTIVE ? "(đã kết nối)" : "(chưa kết nối)")
        
        lbl_name.textColor = data.is_connection == ACTIVE ? ColorUtils.green_matcha_400() : ColorUtils.red_600()
    }
    
}

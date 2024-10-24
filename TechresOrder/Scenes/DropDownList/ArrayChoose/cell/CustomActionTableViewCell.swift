//
//  CustomActionTableViewCell.swift
//  Techres-Sale
//
//  Created by kelvin on 5/13/19.
//  Copyright © 2019 vn.aloapp.sale. All rights reserved.
//

import UIKit

class CustomActionTableViewCell: UITableViewCell {

    @IBOutlet weak var lbl_action_name: UILabel!
    @IBOutlet weak var icon_action: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

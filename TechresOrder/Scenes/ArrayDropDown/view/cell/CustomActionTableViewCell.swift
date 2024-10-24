//
//  CustomActionTableViewCell.swift
//  Techres-Seemt
//
//  Created by Kelvin on 14/04/2023.
//  Copyright © 2023 OVERATE-VNTECH. All rights reserved.
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
    
    // MARK: - Variable -
    public var data: Account? = nil {
        didSet {
            dLog(data!.toJSON())
            lbl_action_name.text = data?.name
        }
    }
    
    
}

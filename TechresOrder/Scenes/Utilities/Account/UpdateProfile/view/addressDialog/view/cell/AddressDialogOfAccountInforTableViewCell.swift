//
//  DistrictItemTableViewCell.swift
//  Techres-Seemt
//
//  Created by Kelvin on 02/05/2023.
//  Copyright © 2023 OVERATE-VNTECH. All rights reserved.
//

import UIKit

class AddressDialogOfAccountInforTableViewCell: UITableViewCell {

    @IBOutlet weak var lbl_district_name: UILabel!
    @IBOutlet weak var btnCheck: UIImageView!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(false, animated: false)

        // Configure the view for the selected state
    }
    // MARK: - Variable -
    public var area: Area? = nil {
        didSet {
            lbl_district_name.text = area?.name
            btnCheck.image = UIImage(named: area?.is_select == ACTIVE ? "icon-radio-checked" : "icon-radio-uncheck")
        }
    }
}

//
//  ItemVersionAppTableViewCell.swift
//  TECHRES-SEEMT
//
//  Created by Nguyen Thanh Vinh on 04/12/2023.
//  Copyright © 2023 OVERATE-VNTECH. All rights reserved.
//

import UIKit

class ItemVersionAppTableViewCell: UITableViewCell {

    @IBOutlet weak var circle: UILabel!
    @IBOutlet weak var root_view: UIView!
    @IBOutlet weak var constraint_top_root_view: NSLayoutConstraint!
    @IBOutlet weak var constraint_bottom_root_view: NSLayoutConstraint!
    
    @IBOutlet weak var lbl_version: UILabel!
    @IBOutlet weak var lbl_created_at: UILabel!
    @IBOutlet weak var lbl_description_version: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        circle.round(with: .both, radius: 5)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    var data: ResponseInfoApp? {
        didSet {
            lbl_version.text = "Phiên bản \(data?.app_version ?? "")"
            lbl_created_at.text = data?.created_at ?? ""
            lbl_description_version.text = data?.message ?? ""
        }
    }
}

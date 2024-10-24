//
//  ItemLinkInStoreTableViewCell.swift
//  TECHRES-SEEMT
//
//  Created by Nguyen Thanh Vinh on 03/01/2024.
//  Copyright © 2024 OVERATE-VNTECH. All rights reserved.
//

import UIKit
import Kingfisher

class ItemLinkInStoreTableViewCell: UITableViewCell {

    @IBOutlet weak var lbl_time_group: UILabel!
    @IBOutlet weak var constraint_top_lbl_time_group: NSLayoutConstraint!
    @IBOutlet weak var constraint_bottom_lbl_time_group: NSLayoutConstraint!
    @IBOutlet weak var image_thumb_link: UIImageView!
    @IBOutlet weak var lbl_domain_link: UILabel!
    @IBOutlet weak var lbl_title_link: UILabel!
    @IBOutlet weak var lbl_user_send: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    var data: MediaStore? {
        didSet {
            lbl_time_group.text = data?.created_at ?? ""
            image_thumb_link.kf.setImage(with: URL(string: data?.thumb.logo ?? ""),
                                         placeholder: UIImage(named: "icon-link-gray"))
            lbl_domain_link.text = data?.thumb.url ?? ""
            lbl_title_link.text = data?.thumb.title ?? ""
            lbl_user_send.text = data?.user.name ?? ""
        }
    }
}

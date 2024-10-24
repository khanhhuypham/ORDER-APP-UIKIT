//
//  ItemFileInStoreTableViewCell.swift
//  TECHRES-SEEMT
//
//  Created by Nguyen Thanh Vinh on 03/01/2024.
//  Copyright © 2024 OVERATE-VNTECH. All rights reserved.
//

import UIKit

class ItemFileInStoreTableViewCell: UITableViewCell {

    @IBOutlet weak var lbl_time_group: UILabel!
    @IBOutlet weak var constraint_top_lbl_time_group: NSLayoutConstraint!
    @IBOutlet weak var constraint_bottom_lbl_time_group: NSLayoutConstraint!
    @IBOutlet weak var lbl_path_extension: UILabel!
    @IBOutlet weak var lbl_size_type_name: UILabel!
    @IBOutlet weak var lbl_file_name: UILabel!
    
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
            
            lbl_file_name.text = data?.media.original.name ?? ""
            var size = ""
            if ((data?.media.original.size ?? 0) >= 1048576 && (data?.media.original.size ?? 0) < 1073741824) {
                size = Utils.stringQuantityFormatWithNumberFloat(amount: Float(data?.media.original.size ?? 0) / 1048576) + " MB"
            } else if ((data?.media.original.size ?? 0) > 1024 && (data?.media.original.size ?? 0) < 1048576) {
                size = Utils.stringQuantityFormatWithNumberFloat(amount: Float(data?.media.original.size ?? 0) / 1024) + " KB"
            } else if ((data?.media.original.size ?? 0) <= 1024) {
                size = Utils.stringQuantityFormatWithNumberFloat(amount: Float(data?.media.original.size ?? 0)) + " B"
            } else {
                size = Utils.stringQuantityFormatWithNumberFloat(amount: Float(data?.media.original.size ?? 0) / 1073741824) + " GB"
            }
            
            lbl_size_type_name.text = String(format: "%@ • %@", size, data?.user.name ?? "")
            
            if let url = URL(string: MediaUtils.getFullMediaLink(string: data?.media.original.link_full ?? "",
                                                            media_type: .video)),
               (data?.media.original.link_full ?? "") != "" {
                lbl_path_extension.text = url.pathExtension
            } else {
                lbl_path_extension.text = "file"
            }
        }
    }
    
}

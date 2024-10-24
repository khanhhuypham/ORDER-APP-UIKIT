//
//  SettingInfoTableViewCell.swift
//  TechresOrder
//
//  Created by macmini_techres_03 on 12/01/2023.
//

import UIKit

class SettingInfoTableViewCell: UITableViewCell {

    @IBOutlet weak var btnTermOfUse: UIButton!
    @IBOutlet weak var btnPravicyPolicy: UIButton!
    @IBOutlet weak var btnReviewApplication: UIButton!
    @IBOutlet weak var btnAppInfo: UIButton!
    @IBOutlet weak var btnSentError: UIButton!
    @IBOutlet weak var btnFeedbackDeveloper: UIButton!
    @IBOutlet weak var lbl_version_info: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        lbl_version_info.text = String(format: "Version: %@ (GPBH%d-OPTION-0%d)", Utils.version() + "", ManageCacheObject.getSetting().branch_type, ManageCacheObject.getSetting().branch_type_option)
    }
    
}

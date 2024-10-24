//
//  SettingAccountTableViewCell.swift
//  TechresOrder
//
//  Created by macmini_techres_03 on 12/01/2023.
//

import UIKit

class SettingAccountTableViewCell: UITableViewCell {
    
    @IBOutlet weak var btnUpdateProfile: UIButton!
    @IBOutlet weak var btnChangePassword: UIButton!
    
    @IBOutlet weak var btnChatChannel: UIButton!
    @IBOutlet weak var settingSwitch: UISwitch!
    
//    @IBOutlet weak var btnSyncData: UIButton!
    
//    @IBOutlet weak var loading_sync_data: UIActivityIndicatorView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
//        loading_sync_data.isHidden = true
//        loading_sync_data.stopAnimating()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
}

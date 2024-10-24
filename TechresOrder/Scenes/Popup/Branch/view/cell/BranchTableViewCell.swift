//
//  BranchTableViewCell.swift
//  TechresOrder
//
//  Created by macmini_techres_03 on 12/01/2023.
//

import UIKit

class BranchTableViewCell: UITableViewCell {
    @IBOutlet weak var lbl_branch_name: UILabel!
    
    @IBOutlet weak var lbl_address: UILabel!
    @IBOutlet weak var lbl_branch_address: UILabel!
    
    @IBOutlet weak var avatar_branch: UIImageView!
    
    @IBOutlet weak var btnEditBranch: UIButton!
    
    @IBOutlet weak var icon_check: UIImageView!
    var delegate:BranchDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//        btnEditBranch.isHidden = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    var viewModel: BranchViewModel? {
           didSet {
              
               
           }
    }
    
    // MARK: - Variable -
    public var data: Branch? = nil {
        didSet {
            lbl_branch_name.text = data?.name
            let link_image = Utils.getFullMediaLink(string: data?.image_logo ?? "")
            avatar_branch.kf.setImage(with: URL(string: link_image), placeholder: UIImage(named: "image_defauft_medium"))
            lbl_address.text = data?.address
            
            icon_check.image = UIImage(named: ManageCacheObject.getCurrentBranch().id == data?.id ? "icon-check-green" : "")
            
        }
    }
    
    
}

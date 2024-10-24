//
//  BrandTableViewCell.swift
//  TechresOrder
//
//  Created by macmini_techres_03 on 12/01/2023.
//

import UIKit

class BrandTableViewCell: UITableViewCell {
    @IBOutlet weak var lbl_branch_name: UILabel!
    

    
    @IBOutlet weak var avatar_branch: UIImageView!
    

    @IBOutlet weak var icon_check: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(false, animated: false)

        // Configure the view for the selected state
    }
    
    var viewModel: BrandViewModel? {
           didSet {
              
               
           }
    }
    
    // MARK: - Variable -
    public var data: Brand? = nil {
        didSet {
            

            lbl_branch_name.text = data?.name
            let link_image = Utils.getFullMediaLink(string: data?.logo_url ?? "")
            avatar_branch.kf.setImage(with: URL(string: link_image), placeholder: UIImage(named: "image_defauft_medium"))
            icon_check.image = UIImage(named: data?.id == ManageCacheObject.getCurrentBrand().id ? "icon-check-green" : "")
            
        }
    }
    
    
}

//
//  AssignToBranchViewController.swift
//  TECHRES-ORDER
//
//  Created by Huynh Quang Huy on 26/8/24.
//

import UIKit

class AssignToBranchViewController: BaseViewController {

    var viewModel = AssignToBranchViewModel()
    var router = AssignToBranchRouter()
    var listOptions: [String] = []
    var listIcons: [String] = []
    var partner:FoodAppAPartner = FoodAppAPartner()

    @IBOutlet weak var branchAvatarImg: UIImageView!
    @IBOutlet weak var branchNameLbl: UILabel!
    @IBOutlet weak var branchAddressLbl: UILabel!
    
    @IBOutlet weak var branchNameTxt: UITextField!
    
    @IBOutlet weak var confirmBtn: UIButton!
    @IBOutlet weak var showFilterBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.bind(view: self, router: router)
        viewModel.restaurant_brand_id.accept(ManageCacheObject.getCurrentUser().restaurant_brand_id)
        viewModel.channel_order_food_id.accept(partner.id)
        getBranch()

        branchAvatarImg.kf.setImage(with: URL(string: Utils.getFullMediaLink(string: ManageCacheObject.getCurrentBranch().image_logo)), placeholder: UIImage(named: "image_defauft_medium"))
               
        branchNameLbl.text = ManageCacheObject.getCurrentBranch().name
        branchAddressLbl.text =  ManageCacheObject.getCurrentBranch().address
//        viewModel.isValidBranchMaps.subscribe().disposed(by: rxbag)
    }
    
    @IBAction func actionChooseBranch(_ sender: Any) {
        showFilter()
    }
    
    @IBAction func actionConfirm(_ sender: Any) {
        postAssignBranch()
    }
    
    @IBAction func actionBack(_ sender: Any) {
        viewModel.makePopViewController()
    }
}

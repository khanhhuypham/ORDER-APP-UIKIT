//
//  UpdateBranchViewController.swift
//  TECHRES-ORDER
//
//  Created by macmini_techres_01 on 14/09/2023.
//

import UIKit
import Photos

class UpdateBranchViewController: BaseViewController {

    var viewModel = UpdateBranchViewModel()
    var router = UpdateBranchRouter()
    var imagecover = [UIImage]()
    var resources_path = [URL]()
    var selectedAssets = [PHAsset]()
    var imagecover2 = [UIImage]()
    var resources_path2 = [URL]()
    var selectedAssets2 = [PHAsset]()
    var isCheck = false
    var typecheck = 0
    
    @IBOutlet weak var txt_ward: UITextField!
    @IBOutlet weak var txt_district: UITextField!
    @IBOutlet weak var txt_city: UITextField!
    
    @IBOutlet weak var txt_Branche_Name: UITextField!
    
    @IBOutlet weak var txt_Branche_phone: UITextField!
    
    @IBOutlet weak var txt_Branches_address: UITextField!
    
    @IBOutlet weak var lbl_city: UITextField!
    
    @IBOutlet weak var lbl_district: UITextField!
    
    @IBOutlet weak var lbl_ward: UITextField!
    @IBOutlet weak var banner_image: UIImageView!
    
    @IBOutlet weak var image_Logo: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.bind(view: self, router: router)
        setupValid()
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        var data = viewModel.dataArray.value
        data.id = ManageCacheObject.getCurrentBranch().id
        viewModel.dataArray.accept(data)
        getInfoBranches()
        
    }
    
    @IBAction func action_cancel(_ sender: Any) {
        viewModel.makeToPopViewController()
    }
    
    @IBAction func btn_makePopToViewController(_ sender: Any) {
        viewModel.makeToPopViewController()
    }
    
    @IBAction func btn_choose_logo(_ sender: Any) {
        isCheck = true
        self.chooseAvatar()
    }
    
    @IBAction func btn_choose_banner(_ sender: Any) {
        isCheck = false
        self.chooseAvatar()
    }
    
    
    @IBAction func btn_choose_Area(_ sender: AnyObject) {
        switch sender.tag {
        case 1:
            self.presentAddressDialogOfAccountInforViewController(areaType:"CITY")
            return
        case 2:
            self.presentAddressDialogOfAccountInforViewController(areaType:"DISTRICT")
            return
        default:
            self.presentAddressDialogOfAccountInforViewController(areaType:"WARD")
            return
          
        }
    }
    @IBAction func btn_UpdateInfoBranches(_ sender: Any) {
        imagecover.count > 0 || imagecover2.count > 0 ? self.updateProfileWithAvatar() : updateBranches()
    }
}

//
//  DialogGiftDetailViewController.swift
//  TechresOrder
//
//  Created by Kelvin on 09/03/2023.
//

import UIKit

class DialogGiftDetailViewController: BaseViewController {

    var viewModel = DialogGiftDetailViewModel()
    @IBOutlet weak var view_action: UIView!
    var router  = DialogGiftDetailRouter()
    
    @IBOutlet weak var image_gift_avatar: UIImageView!
    
    @IBOutlet weak var lbl_gift_name: UILabel!
    @IBOutlet weak var lbl_gift_price: UILabel!
    @IBOutlet weak var lbl_gift_quantity: UILabel!
    @IBOutlet weak var lbl_gift_exp: UILabel!
    
    @IBOutlet weak var lbl_customer_name: UILabel!
    @IBOutlet weak var lbl_customer_phone: UILabel!
    
    var qrcode = ""
    var order_id = 0
    var branch_id = 0
    @IBOutlet weak var root_view: UIView!
    var delegate:UsedGiftDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        root_view.round(with: .both, radius: 8)
        // Do any additional setup after loading the view.
        viewModel.bind(view: self, router: router)
        lbl_customer_name.text = ManageCacheObject.getCurrentUser().name
        lbl_customer_phone.text = ManageCacheObject.getCurrentUser().phone_number
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.branch_id.accept(ManageCacheObject.getCurrentBranch().id)
        viewModel.qr_code_gift.accept(qrcode)
        self.gift()
        
    }
    @IBAction func actionCancel(_ sender: Any) {
        self.viewModel.makePopViewController()
    }
    @IBAction func actionSubmit(_ sender: Any) {
        self.viewModel.qr_code_gift.accept(qrcode)
        self.viewModel.branch_id.accept(ManageCacheObject.getCurrentBranch().id)
        self.viewModel.order_id.accept(self.order_id)
        self.useGift()
    }
    

}

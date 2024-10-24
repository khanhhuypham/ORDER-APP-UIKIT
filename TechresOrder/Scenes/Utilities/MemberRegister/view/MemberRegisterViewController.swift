//
//  MemberRegisterViewController.swift
//  TechresOrder
//
//  Created by Kelvin on 15/02/2023.
//

import UIKit
import Foundation
class MemberRegisterViewController: UIViewController {
    var viewModel = MemberRegisterViewModel()
    var router = MemberRegisterRouter()
    
    @IBOutlet weak var link_lbl:UILabel?
    @IBOutlet weak var qr_code_img_view:UIImageView?
    
    var link:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.bind(view: self, router: router)

        link = String(format: "%@:%d:%d:%d",
                      "REGISTER_MEMBERSHIP_CARD",
                      ManageCacheObject.getCurrentUser().restaurant_id,
                      ManageCacheObject.getCurrentBrand().id,
                      ManageCacheObject.getCurrentUser().id)
     
    
        link_lbl?.text = "Đưa mã QRCode này để khách hàng quét đăng ký thành viên của nhà hàng bạn."

        qr_code_img_view?.image = generateQRCode(from: link!)
    
        
    }
    @IBAction func actionBack(_ sender: Any) {
        viewModel.makePopViewController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    func generateQRCode(from string: String) -> UIImage? {
        let data = string.data(using: String.Encoding.ascii)

        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            let transform = CGAffineTransform(scaleX: 10, y: 10)

            if let output = filter.outputImage?.transformed(by: transform) {
                return UIImage(ciImage: output)
            }
        }

        return nil
    }
}

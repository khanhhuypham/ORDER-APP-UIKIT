//
//  UpdateProfileViewController.swift
//  TechresOrder
//
//  Created by Kelvin on 04/02/2023.
//

import UIKit
import ZLPhotoBrowser
import Photos
import JonAlert
import RxSwift
class UpdateProfileViewController: BaseViewController {
    var viewModel = UpdateProfileViewModel()
    var router = UpdateProfileRouter()
    var account = Account()
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var btnChooseImage: UIButton!
    
    @IBOutlet weak var lbl_name: UILabel!
    @IBOutlet weak var lbl_username: UILabel!
    
    @IBOutlet weak var lbl_brand: UILabel!
    @IBOutlet weak var lbl_branch: UILabel!
    @IBOutlet weak var lbl_role: UILabel!
    
    
    @IBOutlet weak var lbl_id: UILabel!
    @IBOutlet weak var lbl_gender: UILabel!
    @IBOutlet weak var btn_choose_gender: UIButton!
    @IBOutlet weak var lbl_birthday: UILabel!
    @IBOutlet weak var textfield_phone: UITextField!
    @IBOutlet weak var textfield_email: UITextField!
    @IBOutlet weak var textView_address: UITextView!
    @IBOutlet weak var height_of_textview_address: NSLayoutConstraint!
    
    @IBOutlet weak var lbl_city: UILabel!
    @IBOutlet weak var lbl_district: UILabel!
    @IBOutlet weak var lbl_ward: UILabel!
    

    var imagecover = [UIImage]()
    var resources_path = [URL]()
    var selectedAssets = [PHAsset]()


    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        viewModel.bind(view: self, router: router)
        
        mappingData()
       
        
        textView_address.withDoneButton()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillChangeFrameNotification , object:nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification , object:nil)
        
    }

        
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.employee_id.accept(ManageCacheObject.getCurrentUser().id)
        self.getProfile()
    }
    
    deinit {
        timer?.invalidate()
    }
    
    
    @objc private func keyboardWillShow(notification: NSNotification ) {

        
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue{
            if textfield_phone.isFirstResponder {
                scrollView.transform = CGAffineTransform(translationX: 0, y: -keyboardSize.height / 1.35)
              
            }else if textfield_email.isFirstResponder{
                scrollView.transform = CGAffineTransform(translationX: 0, y: -keyboardSize.height / 1.35)
         
            }else if textView_address.isFirstResponder{
                scrollView.transform = CGAffineTransform(translationX: 0, y: -keyboardSize.height / 1.35)
               
            }
            
        }
    }
    
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        if textfield_phone.isFirstResponder || textfield_email.isFirstResponder || textView_address.isFirstResponder {
            scrollView.transform = .identity
        }
    }
    
    
    
    @IBAction func actionChooseAvatar(_ sender: Any) {
        chooseAvatar()
    }
    
    
    @IBAction func actionEditGender(_ sender: Any) {
    }
    
    
    @IBAction func actionEditPhoneNumber(_ sender: Any) {
        textfield_phone.becomeFirstResponder()
    }
    
    @IBAction func actionEditEmail(_ sender: Any) {
        textfield_email.becomeFirstResponder()
    }
    
    @IBAction func actionEditAddress(_ sender: Any) {
        textView_address.becomeFirstResponder()
    }
    
    
    @IBAction func actionChooseCity(_ sender: Any) {
        presentAddressDialogOfAccountInforViewController(areaType:"CITY")
    }
    
    @IBAction func actionChooseDistrict(_ sender: Any) {
        presentAddressDialogOfAccountInforViewController(areaType: "DISTRICT")
    }
    
    @IBAction func actionChooseWard(_ sender: Any) {
        presentAddressDialogOfAccountInforViewController(areaType: "WARD")
    }
    

    @IBAction func actionCancel(_ sender: Any) {
        viewModel.makePopViewController()
    }
    
    @IBAction func actionConfirm(_ sender: Any) {
       
        _ = isAccountInforValid.take(1).subscribe(onNext: {[self] (valid) in
            if valid {
                imagecover.count > 0
                ? updateProfileWithAvatar()
                : updateProfileWithoutAvatar()
            }
        }).disposed(by: rxbag)
        
    }
    
    
  
}

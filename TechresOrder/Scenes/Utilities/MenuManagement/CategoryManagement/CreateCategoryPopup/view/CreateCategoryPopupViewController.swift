//
//  CreateCategoryPopupViewController.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 30/11/2023.
//

import UIKit

class CreateCategoryPopupViewController: BaseViewController {
    var viewModel = CreateCategoryPopupViewModel()
    var delegate:TechresDelegate?
    var category = Category()!

    @IBOutlet weak var root_view: UIView!
    @IBOutlet weak var textfield_categoryName: UITextField!
  
    
    @IBOutlet weak var lbl_category_type: UILabel!
    @IBOutlet weak var btn_choose_category: UIButton!
    @IBOutlet weak var btn_status: UIButton!
    @IBOutlet weak var icon_dropDown: UIImageView!
    
    @IBOutlet weak var width_of_icon_dropDown: NSLayoutConstraint!
    @IBOutlet weak var btn_confirm: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.bind(view: self)
        viewModel.category.accept(category)
        // Do any additional setup after loading the view.
        firstSetup()
        
       
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillChangeFrameNotification , object:nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification , object:nil)
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapOutSide(_:)))
        tapGestureRecognizer.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    
    
    @objc func handleTapOutSide(_ gesture:UIGestureRecognizer){
        let tapLocation = gesture.location(in: root_view)
        if !root_view.bounds.contains(tapLocation){
           dismiss(animated: true)
        }
    }
    @objc private func keyboardWillShow(notification: NSNotification ) {

        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue{
            if textfield_categoryName.isFirstResponder {
                root_view.transform = CGAffineTransform(translationX: 0, y: -100)
            }
        }
    }
      

    @objc private func keyboardWillHide(notification: NSNotification) {
        if textfield_categoryName.isFirstResponder  {
          root_view.transform = .identity
        }
    }

    @IBAction func actionChangeStatus(_ sender: Any) {
        btn_status.isSelected = !btn_status.isSelected
        var category = viewModel.category.value
        category.status = btn_status.isSelected ? ACTIVE : DEACTIVE
        viewModel.category.accept(category)
    }
    
    
    @IBAction func actionCancel(_ sender: Any) {
        dismiss(animated: true)
    }
    
    
    @IBAction func actionConfirm(_ sender: Any) {
        viewModel.category.value.id > 0 ? updateCategory() : createCategory()
  
    }
    

}

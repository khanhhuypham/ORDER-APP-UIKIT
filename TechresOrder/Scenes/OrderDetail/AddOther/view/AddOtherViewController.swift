//
//  ManagerOtherAndExtraFoodViewController.swift
//  TechresOrder
//
//  Created by Kelvin on 21/01/2023.
//

import UIKit

class AddOtherViewController: BaseViewController {
    
    var viewModel = AddOtherViewModel()
    var router = AddOtherRouter()
    var orderDetail = OrderDetail()
    
    
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var lbl_header: UILabel!
    @IBOutlet weak var view_segment: UIView!
    @IBOutlet weak var btnOtherFood: UIButton!
    @IBOutlet weak var underline_of_btn_other_food: UILabel!
    
    @IBOutlet weak var btnExtraFood: UIButton!
    @IBOutlet weak var underline_of_btn_extra_food: UILabel!
    
    @IBOutlet weak var btnBack: UIButton!
        
    @IBOutlet weak var childView: UIView!
    

    let enableAttr = [
        NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .semibold),
        NSAttributedString.Key.foregroundColor: ColorUtils.green_600()
    ]
    
    let unEnableAttr = [
        NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .semibold),
        NSAttributedString.Key.foregroundColor: ColorUtils.green_200()
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        viewModel.bind(view: self, router: router)
        
        lbl_header.text = String(format: "#%d - %@", orderDetail.id, orderDetail.table_name)
        
        lbl_header.text = permissionUtils.GPBH_1
        ? "THÊM MÓN KHÁC"
        : String(format: "#%d - %@", orderDetail.id, orderDetail.table_name)
      
        view_segment.isHidden = permissionUtils.GPBH_1 ? true : false
        view.layoutIfNeeded()

        actionLoadOtherFoodVC("")
    }
    
    
    @IBAction func actionBack(_ sender: Any) {
        viewModel.makePopViewController()
    }
    
    @IBAction func actionLoadOtherFoodVC(_ sender: Any) {
        
        btnOtherFood.setAttributedTitle(Utils.setAttributesForBtn(content: "Món ngoài menu", attributes: enableAttr), for: .normal)
        btnExtraFood.setAttributedTitle(Utils.setAttributesForBtn(content: "Món phụ thu",attributes: unEnableAttr), for: .normal)
        
        underline_of_btn_other_food.backgroundColor = ColorUtils.green_600()
        underline_of_btn_extra_food.backgroundColor = .clear
    
        // add order proccessing when load view
        let otherFoodvc = OtherFoodViewController(nibName: "OtherFoodViewController", bundle: Bundle.main)
        otherFoodvc.orderDetail = orderDetail
        otherFoodvc.popViewController = viewModel.makePopViewController

        addViewController(parent:self,child: otherFoodvc)
    }
    
    
    @IBAction func actionLoadExtraFoodVC(_ sender: Any) {

        btnOtherFood.setAttributedTitle(Utils.setAttributesForBtn(content: "Món ngoài menu", attributes: unEnableAttr), for: .normal)
        btnExtraFood.setAttributedTitle(Utils.setAttributesForBtn(content: "Món phụ thu",attributes: enableAttr), for: .normal)
        
        underline_of_btn_other_food.backgroundColor = .clear
        underline_of_btn_extra_food.backgroundColor = ColorUtils.green_600()

        let extraFoodVC = ExtraFoodViewController(nibName: "ExtraFoodViewController", bundle: Bundle.main)
        extraFoodVC.order_id = orderDetail.id
        extraFoodVC.popViewController = viewModel.makePopViewController
        addViewController(parent:self,child: extraFoodVC)

    }
    
    
    private func addViewController(parent:UIViewController,child: UIViewController) {
        
        children.forEach({
          $0.willMove(toParent: nil)
          $0.view.removeFromSuperview()
          $0.removeFromParent()
        })

        
        parent.addChild(child)

        childView.addSubview(child.view)
        
        child.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            child.view.topAnchor.constraint(equalTo: childView.topAnchor, constant: 0),
            child.view.leadingAnchor.constraint(equalTo: childView.leadingAnchor),
            child.view.trailingAnchor.constraint(equalTo: childView.trailingAnchor),
            child.view.bottomAnchor.constraint(equalTo: childView.bottomAnchor, constant: 0)
        ])
        
        child.didMove(toParent: parent)
    }
    
}

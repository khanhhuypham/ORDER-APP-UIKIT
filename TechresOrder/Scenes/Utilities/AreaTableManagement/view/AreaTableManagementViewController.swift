//
//  ManagementAreaTableManagerViewController.swift
//  TechresOrder
//
//  Created by Kelvin on 23/01/2023.
//

import UIKit

class AreaTableManagementViewController: BaseViewController {
    var viewModel = ManagementAreaTableManagerViewModel()
    var router = AreaTableManagementRouter()

        
    @IBOutlet weak var lbl_header: UILabel!
    
    @IBOutlet weak var btn_area_management: UIButton!
    @IBOutlet weak var btn_table_management: UIButton!
    
    @IBOutlet weak var childView: UIView!
    
    
    
    let enableAttr = [
        NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .semibold),
        NSAttributedString.Key.foregroundColor: ColorUtils.green_600()
    ]
    
    let unEnableAttr = [
        NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .semibold),
        NSAttributedString.Key.foregroundColor: ColorUtils.green_200()
    ]
    
    var underlineView:UIView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        viewModel.bind(view: self, router: router)
        
        lbl_header.text = "QUẢN LÝ KHU VỰC/BÀN"
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        actionAreaManagement("")
    }
    
    
    @IBAction func actionAreaManagement(_ sender: Any) {
        btn_area_management.setAttributedTitle(Utils.setAttributesForBtn(content: "QUẢN LÝ KHU VỰC", attributes: enableAttr), for: .normal)
        btn_table_management.setAttributedTitle(Utils.setAttributesForBtn(content: "QUẢN LÝ BÀN",attributes: unEnableAttr), for: .normal)
        addUnderLineView(btn:btn_area_management)
        let vc = AreaManagementViewController(nibName: "AreaManagementViewController", bundle: Bundle.main)
        addViewController(parent: self,child: vc)
    }
    
    
    @IBAction func actionTableManagement(_ sender: Any) {
        btn_area_management.setAttributedTitle(Utils.setAttributesForBtn(content: "QUẢN LÝ KHU VỰC", attributes: unEnableAttr), for: .normal)
        btn_table_management.setAttributedTitle(Utils.setAttributesForBtn(content: "QUẢN LÝ BÀN",attributes: enableAttr), for: .normal)
        addUnderLineView(btn:btn_table_management)
        let vc = TableManagementViewController(nibName: "TableManagementViewController", bundle: Bundle.main)
        addViewController(parent: self,child: vc)
    }
    
    
    @IBAction func actionBack(_ sender: Any) {
        viewModel.makePopViewController()
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
    
    private func addUnderLineView(btn:UIButton){
        underlineView.removeFromSuperview()
        underlineView = UIView(frame: CGRect(x: 0, y: btn.frame.height - 4, width: btn.frame.size.width, height: 4))
        underlineView.backgroundColor = ColorUtils.green_600()
        btn.addSubview(underlineView)
    }
    
}

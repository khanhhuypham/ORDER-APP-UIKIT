//
//  TechresShopViewController.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 05/09/2024.
//

import UIKit

class TechresShopViewController: UIViewController {
    
    var viewModel = TechresShopViewModel()
    private var router = TechresShopRouter()
    
    let enableAttr = [
        NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14, weight: .semibold),
        NSAttributedString.Key.foregroundColor: ColorUtils.green_600()
    ]
    
    let unEnableAttr = [
        NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14, weight: .semibold),
        NSAttributedString.Key.foregroundColor: ColorUtils.green_200()
    ]
    
    
    @IBOutlet weak var btnMakeOrder: UIButton!
    @IBOutlet weak var underline_of_btnMakeOrder: UILabel!
    
    @IBOutlet weak var btnGetOrderInfo: UIButton!
    @IBOutlet weak var underline_of_btnGetOrderInfo: UILabel!
    
    @IBOutlet weak var childView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.bind(view: self, router: router)
        actionTechresOrderVC("")
        // Do any additional setup after loading the view.
    }

    @IBAction func actionBack(_ sender: Any) {
        viewModel.makePopViewController()
    }
    
    @IBAction func actionTechresOrderVC(_ sender: Any) {
        
        btnMakeOrder.setAttributedTitle(Utils.setAttributesForBtn(content: "ĐẶT HÀNG", attributes: enableAttr), for: .normal)
        btnGetOrderInfo.setAttributedTitle(Utils.setAttributesForBtn(content: "THÔNG TIN ĐƠN HÀNG",attributes: unEnableAttr), for: .normal)
        
        underline_of_btnMakeOrder.backgroundColor = ColorUtils.green_600()
        underline_of_btnGetOrderInfo.backgroundColor = .clear
    
        // add order proccessing when load view
        let vc = TechresShopOrderViewController(nibName: "TechresShopOrderViewController", bundle: Bundle.main)
        vc.popViewController = viewModel.makePopViewController
        addViewController(parent:self,child: vc)
    }
    
    
    @IBAction func actionTechresOrderInfoVC(_ sender: Any) {

        btnMakeOrder.setAttributedTitle(Utils.setAttributesForBtn(content: "ĐẶT HÀNG", attributes: unEnableAttr), for: .normal)
        btnGetOrderInfo.setAttributedTitle(Utils.setAttributesForBtn(content: "THÔNG TIN ĐƠN HÀNG",attributes: enableAttr), for: .normal)
        
        underline_of_btnMakeOrder.backgroundColor = .clear
        underline_of_btnGetOrderInfo.backgroundColor = ColorUtils.green_600()

        let vc = TechresShopOrderInfoViewController(nibName: "TechresShopOrderInfoViewController", bundle: Bundle.main)
        vc.popViewController = viewModel.makePopViewController
        addViewController(parent:self,child: vc)
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

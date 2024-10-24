//
//  TechresShopOrderViewController.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 05/09/2024.
//

import UIKit
import SNCollectionViewLayout
class TechresShopOrderViewController: BaseViewController {
    var popViewController:(() -> Void) = {}
    var viewModel = TechresShopOrderViewModel()
    let flowLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 2
        layout.minimumLineSpacing = 2
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        return layout
    }()
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var lbl_total_amount: UILabel!
    @IBOutlet weak var lbl_total_quantity: UILabel!
    @IBOutlet weak var view_cart: UIView!
    
    @IBOutlet weak var btn: UIButton!
    @IBOutlet weak var view_no_data: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerAndBindData()
        getTechresShopDeviceList()
        
        
        viewModel.deviceArray.subscribe(onNext: {value in
            let valid = !value.filter{$0.quantity > 0}.isEmpty
          
            
            self.lbl_total_amount.textColor = valid ? ColorUtils.green_matcha_400() : ColorUtils.gray_600()
            self.lbl_total_quantity.textColor = valid ? ColorUtils.green_matcha_400() : ColorUtils.gray_600()
            self.view_cart.backgroundColor = valid ? ColorUtils.green_matcha_200() : ColorUtils.gray_200()
            self.btn.isUserInteractionEnabled = valid
            
        }).disposed(by: rxbag)
        
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func actionNavigatoTechresShopCart(_ sender: Any) {
        let vc = TechresShopCartViewController()
  
        vc.deviceArray = viewModel.deviceArray.value.filter{$0.quantity > 0}
        vc.completeHandler = {
            var array = self.viewModel.deviceArray.value
            
            for (i,element) in array.enumerated(){
                array[i].quantity = 0
            }
            
            self.viewModel.deviceArray.accept(array)
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    

}

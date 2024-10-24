//
//  OrderRebuildRouter.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 16/01/2024.
//

import UIKit

class OrderRebuildRouter: NSObject {
    
    var viewController: UIViewController{
        return createViewController()
    }
    
    private var sourceView:UIViewController?
    
    private func createViewController()-> UIViewController {
        let view = OrderRebuildViewController(nibName: "OrderRebuildViewController", bundle: Bundle.main)
        return view
    }
    
    func setSourceView(_ sourceView:UIViewController?){
        guard let view = sourceView else {fatalError("Error Desconocido")}
        self.sourceView = view
    }
    
    func navigateToOrderDetailViewController(order:OrderDetail){
        let vc = OrderDetailRouter().viewController as! OrderDetailViewController
        vc.order = order
        sourceView?.navigationController?.pushViewController(vc, animated: true)
    }
    
    func navigateToPayMentViewController(orderDetail: OrderDetail){
        let vc = PaymentRebuildRouter().viewController as! PaymentRebuildViewController
        vc.order = orderDetail
        sourceView?.navigationController?.pushViewController(vc, animated: true)
    }
    
    func navigateToQRCodeCashbackViewController(order_id : Int, table_name:String){
        let qRCodeCashbackBillViewController = QRCodeCashbackBillRouter().viewController as! QRCodeCashbackBillViewController
        qRCodeCashbackBillViewController.order_id = order_id
        qRCodeCashbackBillViewController.table_name = table_name
        qRCodeCashbackBillViewController.delegate = sourceView as! QRCodeCashbackBillDelegate
        sourceView?.navigationController?.pushViewController(qRCodeCashbackBillViewController, animated: true)
    }
    

    func navigateToAddFoodViewController(order:OrderDetail,is_gift:Int){
        let addFoodViewController = AddFoodRouter().viewController as! AddFoodViewController
        addFoodViewController.order = order
        addFoodViewController.is_gift = is_gift
        sourceView?.navigationController?.pushViewController(addFoodViewController, animated: true)
    }
    
    
    func navigateToEmployeeSharePointViewController(order_id : Int, table_name:String){
//        let chooseEmployeeNeedShareViewController = ChooseEmployeeNeedShareRouter().viewController as! ChooseEmployeeNeedShareViewController
//        chooseEmployeeNeedShareViewController.order_id = order_id
//        chooseEmployeeNeedShareViewController.table_name = table_name
//        sourceView?.navigationController?.pushViewController(chooseEmployeeNeedShareViewController, animated: true)
    }
    
    func navigateToGiftDetailViewController(qrcode:String, order_id:Int){
        let dialogGiftDetailViewController = DialogGiftDetailRouter().viewController as! DialogGiftDetailViewController
        dialogGiftDetailViewController.qrcode = qrcode
        dialogGiftDetailViewController.order_id = order_id
        sourceView?.navigationController?.pushViewController(dialogGiftDetailViewController, animated: true)
    }
    
    
    
}

//
//  TechresShopCartViewController.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 05/09/2024.
//

import UIKit
import ObjectMapper

class TechresShopCartViewController: BaseViewController {

    var viewModel = TechresShopCartViewModel()
    var deviceArray:[TechresDevice] = []
    var completeHandler:(() -> Void) = {}

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var lbl_total_payment: UILabel!
    
    @IBOutlet weak var lbl_total_netPayment: UILabel!

    
    @IBOutlet weak var lbl_name: UILabel!
    
    @IBOutlet weak var lbl_phone: UILabel!
    
    @IBOutlet weak var lbl_address: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCellAndBindTable()
        
        viewModel.deviceArray.accept(deviceArray)
     
        lbl_name.text = String(format: "Tên nguời đặt: %@",Constants.user.name)
        lbl_phone.text = String(format: "Số điện thoại: %@",Constants.user.phone_number)
        lbl_address.text = String(format: "Địa chỉ: %@",Constants.user.branch_address)
        
        
        viewModel.deviceArray.subscribe(onNext: {value in
            
            let totalAmount = value.map{x in Float(x.price * x.quantity)}.reduce(0.0,+)
            self.lbl_total_payment.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: totalAmount)
            self.lbl_total_netPayment.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: totalAmount)
            
        }).disposed(by: rxbag)
      
        
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func actionBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func actionClear(_ sender: Any) {
        
        var array = viewModel.deviceArray.value
        
        for (i,element) in array.enumerated(){
            array[i].quantity = 0
        }
        
        viewModel.deviceArray.accept(array)
        
    }
    
    @IBAction func actionCreateOrder(_ sender: Any) {
        var selectedOrder = viewModel.deviceArray.value.filter{$0.quantity > 0}
        if !selectedOrder.isEmpty{
            createTechresShopOrder(selectedDevice: selectedOrder)
        }
    }
    
}




extension TechresShopCartViewController {
    
    func registerCellAndBindTable(){
        registerCell()
        bindTableView()
    }
    
    private func registerCell() {
        
        let cell = UINib(nibName: "TechresShopCartTableViewCell", bundle: .main)
        tableView.register(cell, forCellReuseIdentifier: "TechresShopCartTableViewCell")
        tableView.rowHeight = UITableView.automaticDimension
 
    }

    private func bindTableView(){
         
         viewModel.deviceArray.bind(to: tableView.rx.items(cellIdentifier: "TechresShopCartTableViewCell", cellType: TechresShopCartTableViewCell.self))
             {(row, data, cell) in
                 cell.viewModel = self.viewModel
                 cell.data = data
                 
                 
                
                 
            
        }.disposed(by: rxbag)
         
     }
}


extension TechresShopCartViewController {
    
    func createTechresShopOrder(note:String = "",selectedDevice:[TechresDevice]) {
        appServiceProvider.rx.request(.postCreateTechresShopOrder(note: note, device: selectedDevice))
        .filterSuccessfulStatusCodes()
        .mapJSON().asObservable()
        .showAPIErrorToast()
        .mapObject(type: APIResponse.self).subscribe(onNext: { [weak self] response in
            guard let self = self else { return }
           
            if (response.code == RRHTTPStatusCode.ok.rawValue) {
                self.showSuccessMessage(content: "Tạo đơn hàng thành công")
                self.completeHandler()
                self.actionBack("")
            } else if (response.code == RRHTTPStatusCode.badRequest.rawValue) {
                self.showWarningMessage(content: response.message ?? "")
               
            } else {
               
              
            }
            
        
        }).disposed(by: rxbag)
        
    }
}
 
 

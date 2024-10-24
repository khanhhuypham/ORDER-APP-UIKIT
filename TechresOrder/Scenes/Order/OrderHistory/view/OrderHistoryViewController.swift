//
//  OrderHistoryViewController.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 13/12/2023.
//

import UIKit
import RxSwift
import RxRelay
class OrderHistoryViewController: BaseViewController {
    var viewModel = OrderHistoryViewModel()
    var order:Order?
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var btn_back: UIButton!
    @IBOutlet weak var view_empty_data: UIView!
    
    @IBOutlet weak var textfield_search: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.bind(view: self)
        viewModel.order.accept(order ?? Order()!)
        bindTableViewAndRegisterCell()
        getOrderHistory()
        // Do any additional setup after loading the view.
        
        
        textfield_search.rx.controlEvent(.editingChanged).throttle(.milliseconds(1000), scheduler: MainScheduler.instance).withLatestFrom(textfield_search.rx.text)
                   .subscribe(onNext:{ [self]  query in
                       self.viewModel.keySearch.accept(query ?? "")
                       self.viewModel.clearDataAndCallAPI()
        }).disposed(by: rxbag)
        
    }

    @IBAction func actionBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

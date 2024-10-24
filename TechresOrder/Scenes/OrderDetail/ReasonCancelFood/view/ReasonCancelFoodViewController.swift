//
//  ReasonCancelFoodViewController.swift
//  TechresOrder
//
//  Created by Kelvin on 18/01/2023.
//

import UIKit
import ObjectMapper
import JonAlert
class ReasonCancelFoodViewController: BaseViewController {
    var viewModel = ReasonCancelFoodViewModel()

    @IBOutlet weak var tableView: UITableView!
    var delegate:ReasonCancelFoodDelegate?

    
    var orderItem:OrderItem? = nil
    
    @IBOutlet weak var root_view: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.bind(view: self)


        registerCell()
        binđDataTableView()
        
        //CALL API GET DATA
        reasonCancelFoods()
    }
    
    //MARK: Register Cells as you want
    func registerCell(){
      
        let reasonCancelFoodTableViewCell = UINib(nibName: "ReasonCancelFoodTableViewCell", bundle: .main)
        tableView.register(reasonCancelFoodTableViewCell, forCellReuseIdentifier: "ReasonCancelFoodTableViewCell")
        tableView.rowHeight = UITableView.automaticDimension
        
        tableView.rx.modelSelected(ReasonCancel.self) .subscribe(onNext: { element in
            print("Selected \(element)")
         
            var reasons = self.viewModel.dataArray.value

            reasons.enumerated().forEach { (index, value) in
                reasons[index].is_select = element.id == value.id ? ACTIVE : DEACTIVE
                self.orderItem?.cancel_reason = element.content
            }
            self.viewModel.dataArray.accept(reasons)
        })
        .disposed(by: rxbag)
        
    }

   
    func binđDataTableView(){
     
        viewModel.dataArray.bind(to: tableView.rx.items(cellIdentifier: "ReasonCancelFoodTableViewCell", cellType: ReasonCancelFoodTableViewCell.self)) { (index, element, cell) in
            cell.data = element
         }.disposed(by: rxbag)
    }
    
    

    @IBAction func actionApprovedCancelFood(_ sender: Any) {
        guard let orderItem = self.orderItem else {
            dismiss(animated: true)
            return
        }
    
        if !orderItem.cancel_reason.isEmpty{
            dismiss(animated: true,completion: {self.delegate?.removeItem(item: orderItem)})
        }else{
            showWarningMessage(content: "Vui lòng chọn lý do hủy món")
        }
     
    }
    
    @IBAction func actionCancel(_ sender: Any) {
      
        guard let orderItem = self.orderItem else {
            dismiss(animated: true)
            return
        }
        dismiss(animated: true,completion: {self.delegate?.cancel(item: orderItem)})
    }
    
    
    
}

extension ReasonCancelFoodViewController{
    func reasonCancelFoods(){
        viewModel.reasonCancelFoods().subscribe(onNext: { (response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){
        
                if let reasonCancel  = Mapper<ReasonCancel>().mapArray(JSONObject: response.data){

                    self.viewModel.dataArray.accept(reasonCancel)
                }
            }
        }).disposed(by: rxbag)
        
    }
}

//
//  OrderRebuildViewController.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 16/01/2024.
//

import UIKit
import RxSwift
import JonAlert
class OrderRebuildViewController: BaseViewController {
    var viewModel = OrderRebuildViewModel()
    private var router = OrderRebuildRouter()
    
    
    @IBOutlet weak var rootView: UIView!
    @IBOutlet weak var view_of_point: UIStackView!
    @IBOutlet weak var view_of_text_field: UIView!
    @IBOutlet weak var view_of_btn: UIView!
    
    @IBOutlet weak var textfield_search1: UITextField!
    @IBOutlet weak var textfield_search: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var view_no_data: UIView!
    
    
    
    
    @IBOutlet weak var btnFilterAll: UIButton!
    @IBOutlet weak var btnFilterMyOrder: UIButton!
    @IBOutlet weak var btnFilterServing: UIButton!
    @IBOutlet weak var btnFilterRequestPayment: UIButton!
    @IBOutlet weak var btnFilterWaitingPayment: UIButton!
    
    @IBOutlet weak var block_view: UIView!
    @IBOutlet weak var image_block: UIImageView!
    @IBOutlet weak var lbl_content_of_block_view: UILabel!
    
    let refreshControl = UIRefreshControl()
    
    var real_time_url = ""

    var btnArray:[UIButton] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.bind(view: self, router: router)
        registerCellAndBindTable()
        
        
        if(ManageCacheObject.getSetting().service_restaurant_level_id >= GPQT_LEVEL_FIVE){
            self.getCurrentPoint(employee_id: ManageCacheObject.getCurrentUser().id)
        }
        

        textfield_search.rx.controlEvent(.editingChanged).withLatestFrom(textfield_search.rx.text).subscribe(onNext:{(query) in
            let fullDataArray = self.viewModel.fullDataArray.value
            if !query!.isEmpty {
                let filteredDataArray = fullDataArray.filter({
                    (value) -> Bool in
                    let str1 = query!.uppercased().applyingTransform(.stripDiacritics, reverse: false)!
                    let str2 = value.table_name.uppercased().applyingTransform(.stripDiacritics, reverse: false)!
                    let str3 = String(value.total_amount)
                    return str2.contains(str1) || str3.contains(str1)
                })
                self.viewModel.dataArray.accept(filteredDataArray)
            }else{
                self.viewModel.dataArray.accept(fullDataArray)
            }
            self.view_no_data.isHidden = self.viewModel.dataArray.value.count > 0 ? true : false
        }).disposed(by: rxbag)
        
        
        textfield_search1.rx.controlEvent(.editingChanged).withLatestFrom(textfield_search1.rx.text).subscribe(onNext:{(query) in
            let fullDataArray = self.viewModel.fullDataArray.value
            if !query!.isEmpty {
                let filteredDataArray = fullDataArray.filter({
                    (value) -> Bool in
                    let str1 = query!.uppercased().applyingTransform(.stripDiacritics, reverse: false)!
                    let str2 = value.table_name.uppercased().applyingTransform(.stripDiacritics, reverse: false)!
                    let str3 = String(value.total_amount)
                    return str2.contains(str1) || str3.contains(str1)
                })
                self.viewModel.dataArray.accept(filteredDataArray)
            }else{
                self.viewModel.dataArray.accept(fullDataArray)
            }
            
            self.view_no_data.isHidden = self.viewModel.dataArray.value.count > 0 ? true : false
        }).disposed(by: rxbag)
        

        
    }
    
    
  
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

          if permissionUtils.GPBH_1{
              isBlockViewHidden(true)
              view_of_point.isHidden = true
              view_of_btn.isHidden = true
              view_of_text_field.isHidden = false
              firstSetup()
          }else if permissionUtils.GPBH_2 || permissionUtils.GPBH_3 {
              
              if permissionUtils.GPBH_2_o_3 {
                  isBlockViewHidden(false,icon: UIImage(named: "icon-locked-function"),content: "Giải pháp bán hàng bạn đang sử dụng chỉ có thể order trên máy Thu Ngân")
                  return
              }
              
              view_of_point.isHidden = true
              view_of_btn.isHidden = false
              view_of_text_field.isHidden = true
              isBlockViewHidden(true)
       
              if permissionUtils.GPQT_2_and_above {
                  if !permissionUtils.Checking {//if user hasn't yet checked in
                      isBlockViewHidden(false,icon: UIImage(named: "img-no-data"),content: "Vui lòng Check-in để sử dụng cách tính năng của app Order")
                      return
                  }
                  
              }
              firstSetup()
        
          }
        
        
        
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        SocketIOManager.shared().socketRealTime!.emit("leave_room", real_time_url)
    }
        
    func firstSetup(){
        
        clearDataAndCallApi()
        checkVersion()
        setupSocketIO()
        
        btnArray = [btnFilterAll, btnFilterMyOrder, btnFilterServing, btnFilterRequestPayment, btnFilterWaitingPayment]
        Utils.changeBgBtn(btn: btnFilterAll, btnArray: btnArray)
        for btn in self.btnArray{
            btn.rx.tap.asDriver().drive(onNext: { [weak self] in
                Utils.changeBgBtn(btn: btn, btnArray: self?.btnArray ?? [])
            }).disposed(by: rxbag)
            
        }
    }
    
    private func isBlockViewHidden(_ isHidden:Bool,icon:UIImage? = nil,content:String? = nil){

        block_view.isHidden = isHidden
        if icon != nil && content != nil{
            image_block.image = icon
            lbl_content_of_block_view.text = content
        }
    }


    @IBAction func actionFilterAll(_ sender: Any) {
        var apiParameter = viewModel.APIParameter.value
        apiParameter.order_status = String(format: "%d,%d,%d", ORDER_STATUS_OPENING, ORDER_STATUS_REQUEST_PAYMENT,ORDER_STATUS_WAITING_WAITING_COMPLETE)
        apiParameter.userId = 0
        viewModel.APIParameter.accept(apiParameter)
        clearDataAndCallApi()
    }
    
   
    @IBAction func actionFilterMyOrder(_ sender: Any) {

        var apiParameter = viewModel.APIParameter.value
        apiParameter.order_status = ""
        apiParameter.userId = ManageCacheObject.getCurrentUser().id
        viewModel.APIParameter.accept(apiParameter)
        clearDataAndCallApi()
    }
    @IBAction func actionFilterServing(_ sender: Any) {
        var apiParameter = viewModel.APIParameter.value
        apiParameter.order_status = String(format: "%d", ORDER_STATUS_OPENING)
        apiParameter.userId = 0
        viewModel.APIParameter.accept(apiParameter)
        clearDataAndCallApi()
    }
    @IBAction func actionFilterRequestPayment(_ sender: Any) {
        var apiParameter = viewModel.APIParameter.value
        apiParameter.order_status = String(format: "%d", ORDER_STATUS_REQUEST_PAYMENT)
        apiParameter.userId = 0
        viewModel.APIParameter.accept(apiParameter)
        clearDataAndCallApi()
    }
    
    @IBAction func actionFilterWaitingPayment(_ sender: Any) {
        var apiParameter = viewModel.APIParameter.value
        apiParameter.order_status = String(format: "%d",ORDER_STATUS_WAITING_WAITING_COMPLETE)
        apiParameter.userId = 0
        viewModel.APIParameter.accept(apiParameter)
        clearDataAndCallApi()
    }
   
}


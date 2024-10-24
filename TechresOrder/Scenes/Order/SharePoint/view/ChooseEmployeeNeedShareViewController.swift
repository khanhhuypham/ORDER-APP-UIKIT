//
//  ChooseEmployeeNeedShareViewController.swift
//  TechresOrder
//
//  Created by Kelvin on 27/01/2023.
//

import UIKit
import MSPeekCollectionViewDelegateImplementation

class ChooseEmployeeNeedShareViewController: BaseViewController {
    var viewModel = ChooseEmployeeNeedShareViewModel()
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var behavior: MSCollectionViewPeekingBehavior!
    
    @IBOutlet weak var text_field_search: UITextField!
    var order_id = 0
    var table_name = ""
    
    @IBOutlet weak var lbl_header: UILabel!
    @IBOutlet weak var btnAssignPointToEmployee: UIButton!
    
    @IBOutlet weak var btnCancel: UIButton!

    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        viewModel.bind(view: self)
        
        
        lbl_header.text = String(format: "CHỌN NHÂN VIÊN ĐỂ CHIA ĐIỂM (BÀN %@)", table_name)
        registerCollectionViewCell()
        binđDataCollectionView()
        
        registerCell()
        bindTableViewData()
        
        text_field_search.rx.controlEvent([.editingChanged])
                .asObservable().subscribe({ [unowned self] _ in
                    print("My text : \(self.text_field_search.text ?? "")")
                    var employees = self.viewModel.allEmployees.value
                   
                    if !self.text_field_search.text!.isEmpty{
                        var employees_filter = employees.filter({ $0.normalize_name.lowercased().range(of: self.text_field_search.text!, options: .caseInsensitive) != nil || $0.prefix.lowercased().range(of: self.text_field_search.text!, options: .caseInsensitive) != nil || $0.name.lowercased().range(of: self.text_field_search.text!, options: .caseInsensitive) != nil})
                        
                        let selectedEmployees = self.viewModel.employeesSelected.value
                        
                        for i in 0..<employees_filter.count {
                            for j in 0..<selectedEmployees.count {
                                if employees_filter[i].id == selectedEmployees[j].id {
                                    employees_filter[i].isSelect = 1
                                    break
                                }
                            }
                        }
                        
                        self.viewModel.dataArray.accept(employees_filter)
                        self.viewModel.employeesSelected.accept(selectedEmployees)
                        
                    }else{
                        
                        let selectedEmployees = self.viewModel.employeesSelected.value
                        
                        for i in 0..<employees.count {
                            for j in 0..<selectedEmployees.count {
                                if employees[i].id == selectedEmployees[j].id {
                                    employees[i].isSelect = 1
                                    break
                                }
                            }
                        }
                        
                        self.viewModel.dataArray.accept(employees)
                        self.viewModel.employeesSelected.accept(selectedEmployees)

                    }
                    
                    
                 
                }).disposed(by: rxbag)
        
        
        
        btnAssignPointToEmployee.rx.tap.asDriver()
                       .drive(onNext: { [weak self] in
                           dLog("btnAssignPointToEmployee")
                           self!.presentModalDialogConfirmViewController(dialog_type: 1, title: "XÁC NHẬN CHIA ĐIỂM", content: "Bạn có muốn chia điểm với nhân viên đã chọn?")

                       }).disposed(by:rxbag)
        
        btnCancel.rx.tap.asDriver()
                       .drive(onNext: { [weak self] in
                           self?.dismiss(animated: true)
                       }).disposed(by:rxbag)

        
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.order_id.accept(order_id)
        viewModel.branch_id.accept(ManageCacheObject.getCurrentBranch().id)
        viewModel.is_for_share_point.accept(ACTIVE)
        self.employeeSharePoint()
    }

}

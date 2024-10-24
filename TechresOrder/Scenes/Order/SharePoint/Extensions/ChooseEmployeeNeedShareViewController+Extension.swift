//
//  ChooseEmployeeNeedShareViewController+Extension.swift
//  TechresOrder
//
//  Created by Kelvin on 27/01/2023.
//

import UIKit
import ObjectMapper
import RxSwift
import MSPeekCollectionViewDelegateImplementation
import JonAlert
extension ChooseEmployeeNeedShareViewController {
    func employeeSharePoint(){
            viewModel.employeeSharePoint().subscribe(onNext: { (response) in
                if(response.code == RRHTTPStatusCode.ok.rawValue){
                    if let employees_selected = Mapper<Account>().mapArray(JSONObject: response.data) {

                        self.viewModel.employeesSelected.accept(employees_selected)
                        self.employees()
                        
                    }
                }else{
                    dLog(response.message ?? "")

                    JonAlert.showError(message: response.message ?? "Có lỗi xảy ra trong quá trình kết nối tới máy chủ.", duration: 2.0)
                }
             
            }).disposed(by: rxbag)
        }
    func employees(){
            viewModel.employees().subscribe(onNext: { (response) in
                if(response.code == RRHTTPStatusCode.ok.rawValue){
                    if let arr_employees = Mapper<Account>().mapArray(JSONObject: response.data) {
                        var employees = arr_employees

                        if(self.viewModel.allEmployees.value.count == 0){
                            self.viewModel.allEmployees.accept(employees)
                        }

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
                }else{
                    dLog(response.message ?? "")
                    JonAlert.showError(message: response.message ?? "Có lỗi xảy ra trong quá trình kết nối tới máy chủ.", duration: 2.0)
                }
             
            }).disposed(by: rxbag)
        }
    
    
    func sharePoint(){
            viewModel.sharePoint().subscribe(onNext: { (response) in
                if(response.code == RRHTTPStatusCode.ok.rawValue){
    
                    
                    JonAlert.showSuccess(message: "Chia điểm thành công!", duration: 2.0)
                    self.dismiss(animated: true)
                    
                }else{
                    dLog(response.message ?? "")
                    JonAlert.showError(message: response.message ?? "Có lỗi xảy ra trong quá trình kết nối tới máy chủ.", duration: 2.0)
                }
             
            }).disposed(by: rxbag)
        }
}
extension ChooseEmployeeNeedShareViewController{
        func registerCell() {
            let reviewFoodTableViewCell = UINib(nibName: "ChooseEmployeeNeedShareTableViewCell", bundle: .main)
            tableView.register(reviewFoodTableViewCell, forCellReuseIdentifier: "ChooseEmployeeNeedShareTableViewCell")
            
            self.tableView.estimatedRowHeight = 70
            self.tableView.rowHeight = UITableView.automaticDimension
            tableView.separatorStyle = UITableViewCell.SeparatorStyle.none

            tableView.rx.setDelegate(self).disposed(by: rxbag)
          
        }
    
    func registerCollectionViewCell() {
        let employeeSelectedCollectionViewCell = UINib(nibName: "EmployeeSelectedCollectionViewCell", bundle: .main)
        collectionView.register(employeeSelectedCollectionViewCell, forCellWithReuseIdentifier: "EmployeeSelectedCollectionViewCell")
        
        behavior = MSCollectionViewPeekingBehavior(cellSpacing: CGFloat(10), cellPeekWidth: CGFloat(20), maximumItemsToScroll: Int(1), numberOfItemsToShow: Int(3), scrollDirection: .horizontal)
        collectionView.configureForPeekingBehavior(behavior: behavior)
        
        collectionView
            .rx.setDelegate(self)
            .disposed(by: rxbag)
        
    }
    
}

extension ChooseEmployeeNeedShareViewController{
    
    public func bindTableViewData() {
       viewModel.dataArray.bind(to: tableView.rx.items(cellIdentifier: "ChooseEmployeeNeedShareTableViewCell", cellType: ChooseEmployeeNeedShareTableViewCell.self))
        { [self]  (row, emplooyee, cell) in
               cell.data = emplooyee
              
            cell.viewModel = self.viewModel
           

           }.disposed(by: rxbag)
       }
    
    
    public func binđDataCollectionView(){
     
        viewModel.employeesSelected.bind(to: collectionView.rx.items(cellIdentifier: "EmployeeSelectedCollectionViewCell", cellType: EmployeeSelectedCollectionViewCell.self)) { (index, element, cell) in
            cell.data = element
            cell.btnDeleted.rx.tap.asDriver()
                           .drive(onNext: { [weak self] in
                               dLog("action payment")
                               self!.erase(index: index)
                           }).disposed(by: cell.disposeBag)
            
         }.disposed(by: rxbag)
    }
    
}
extension ChooseEmployeeNeedShareViewController: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}
extension ChooseEmployeeNeedShareViewController: UICollectionViewDelegate{
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
           behavior.scrollViewWillEndDragging(scrollView, withVelocity: velocity, targetContentOffset: targetContentOffset)
       }

       func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
           print(behavior.currentIndex)
       }
    
}

extension ChooseEmployeeNeedShareViewController{
    func erase(index: Int) {
        var employees = viewModel.dataArray.value
        var selectedEmployees = viewModel.employeesSelected.value
        
        for i in 0..<employees.count {
            if employees[i].id == selectedEmployees[index].id {
                employees[i].isSelect = 0
                break
            }
        }
        
        selectedEmployees.remove(at: index)
        
        viewModel.employeesSelected.accept(selectedEmployees)
        viewModel.dataArray.accept(employees)
        
    }
}
extension ChooseEmployeeNeedShareViewController: DialogConfirmDelegate{
    func presentModalDialogConfirmViewController(dialog_type:Int, title:String, content:String) {
        let vc = DialogConfirmViewController()

        vc.view.backgroundColor = ColorUtils.blackTransparent()
        vc.dialog_type = dialog_type
        vc.dialog_title = title
        vc.content = content
        vc.delegate = self
        let nav = UINavigationController(rootViewController: vc)
        // 1
        nav.modalPresentationStyle = .overCurrentContext
        
        // 2
        if #available(iOS 15.0, *) {
            if let sheet = nav.sheetPresentationController {
                
                // 3
                sheet.detents = [.large()]
                
            }
        } else {
            // Fallback on earlier versions
        }
        // 4
       
        present(nav, animated: true, completion: nil)

    }
    
    func accept() {
        dLog("accept.....")
        let selectedEmployees = viewModel.employeesSelected.value
        var employee_list_selected = [EmployeeSharePointRequest]()
        
        for i in 0..<selectedEmployees.count {
            var employee = EmployeeSharePointRequest.init()
            employee.name = selectedEmployees[i].name
            employee.id = selectedEmployees[i].id
            employee_list_selected.append(employee)
        }
        viewModel.employee_list.accept(employee_list_selected)
        self.sharePoint()
        
       
    }
    func cancel() {
        dLog("Cancel...")
    }
}

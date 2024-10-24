//
//  SettingAccountViewController.swift
//  TechresOrder
//
//  Created by macmini_techres_03 on 12/01/2023.
//

import UIKit

class SettingAccountViewController: BaseViewController {
    var viewModel = SettingAccountViewModel()
    private var router = SettingAccountRouter()
        
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var asd: UILabel!
    override func viewDidLoad() {
            super.viewDidLoad()
            // Do any additional setup after loading the view.
            viewModel.bind(view: self, router: router)
            registerCell()
            bindTableView()
            viewModel.dataSectionArray.accept([0,1])
            
    }
    
  
    
    
    @IBAction func actionLogout(_ sender: Any) {
        
        
        permissionUtils.toggleWorkSession
        ? self.presentModalDialogConfirmClosedWorkingSessionViewController()
        : self.presentModalDialogConfirm(title: "XÁC NHẬN ĐĂNG XUẤT", content: "Đăng xuất khỏi tài khoản này?")
        

        
    }
    
    
    @IBAction func actionBack(_ sender: Any) {
        viewModel.makePopViewController()
    }
}

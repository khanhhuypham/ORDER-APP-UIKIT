//
//  OpenWorkingSessionViewController.swift
//  TechresOrder
//
//  Created by Kelvin on 26/01/2023.
//

import UIKit

class OpenWorkingSessionViewController: BaseViewController {
    var viewModel = OpenWorkingSessionViewModel()
    var router = OpenWorkingSessionRouter()
    
    @IBOutlet weak var root_view: UIView!
    @IBOutlet weak var lbl_session_name: UILabel!
    @IBOutlet weak var lbl_session_to_time: UILabel!
    @IBOutlet weak var lbl_session_from_time: UILabel!
    
    @IBOutlet weak var btnInputMoney: UIButton!
    
    var workingSession = WorkingSession.init()
    
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        root_view.round(with: .both, radius: 8)
        // Do any additional setup after loading the view.
        viewModel.bind(view: self, router: router)

    }

    @IBAction func actionChooseFrom(_ sender: Any) {
        
    }
    
    @IBAction func actionChooseTo(_ sender: Any) {
        
    }
    
    @IBAction func actionOpenSession(_ sender: Any) {
        //call api open working session
        self.openSession()
    }
    
    @IBAction func actionCancel(_ sender: Any) {
        logout()
    }
    
    @IBAction func actionInputMoney(_ sender: Any) {
        self.presentModalCaculatorInputMoneyViewController()
    }
    
}

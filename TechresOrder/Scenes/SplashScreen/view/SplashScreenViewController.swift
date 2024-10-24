//
//  SplashScreenViewController.swift
//  TechresOrder
//
//  Created by macmini_techres_03 on 14/01/2023.
//

import UIKit

class SplashScreenViewController: UIViewController {
    private var viewModel = SplashScreenViewModel()

    private var router = SplashScreenRouter()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        viewModel.bind(view: self, router: router)
        
//        navigationController?.isNavigationBarHidden = true
        
        ManageCacheObject.isLogin()
        ? viewModel.makeMainViewController()
        : viewModel.makeLoginViewController()

    }
    
}

//
//  TabbarViewController.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 25/07/2024.
//

import UIKit
import RxSwift
class TabbarViewController: UITabBarController, UITabBarControllerDelegate {
    
    var viewModel = TabbarViewModel()
    var workingSession = WorkingSession.init()
    let disposeBag = DisposeBag()
    var generateReportVC:GenerateReportViewController!
    var orderRebuildVC:OrderRebuildViewController!
    var areaVC:AreaViewController!
    var reportVC:ReportViewController!
    var feeRebuildVC:FeeRebuildViewController!
    var utilitiesVC:UtilitiesViewController!
    
    

    private let imageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(named: "icon-customer-care-blue")
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    private let imageClose: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(named: "icon-delete-background-transparent")
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    private let buttonClose: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .clear
        return button
    }()
    
    private let rootView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    
    
 
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        var safeAreaBottomInset: CGFloat = 0.0

        if #available(iOS 11.0, *) {
           safeAreaBottomInset = view.safeAreaInsets.bottom
        }

        let newTabBarHeight: CGFloat = 70 + safeAreaBottomInset

        var newFrame = tabBar.frame
        newFrame.size.height = newTabBarHeight
        newFrame.origin.y = view.frame.size.height - newTabBarHeight

        tabBar.frame = newFrame
 
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        viewModel.bind(view: self)
        // Do any additional setup after loading the view.
        navigationController?.isNavigationBarHidden = true
        generateReportVC = GenerateReportViewController()
        orderRebuildVC = OrderRebuildViewController()
        areaVC = AreaViewController()
        feeRebuildVC = FeeRebuildViewController()
        reportVC = ReportViewController()
        utilitiesVC = UtilitiesViewController()
        
        
        
        generateReportVC.tabBarItem.image = UIImage(named: "icon-general-tabbar")
        generateReportVC.tabBarItem.title = "Tổng quan"
//        generateReportVC.tabBarItem.selectedImage = UIImage(named: "home-selected")
        
        orderRebuildVC.tabBarItem.image = UIImage(named: "icon-order-tabbar")
        orderRebuildVC.tabBarItem.title = "Đơn hàng"
//        orderRebuildVC.tabBarItem.selectedImage = UIImage(named: "second-selected")
        
        areaVC.tabBarItem.image = UIImage(named: "icon-area-tabbar")
        areaVC.tabBarItem.title = "Khu vực"
        areaVC.tabBarItem.selectedImage = UIImage(named: "action-selected")
        
        feeRebuildVC.tabBarItem.image = UIImage(named: "icon-fee-tabbar")
        feeRebuildVC.tabBarItem.title = "Chi phí"
//        feeRebuildVC.tabBarItem.selectedImage = UIImage(named: "third-selected")
        
        reportVC.tabBarItem.image = UIImage(named: "icon-fee-tabbar")
        reportVC.tabBarItem.title = "Báo cáo"
//        reportVC.tabBarItem.selectedImage = UIImage(named: "third-selected")
        
        utilitiesVC.tabBarItem.image = UIImage(named: "icon-utilities-tabbar")
        utilitiesVC.tabBarItem.title = "Tiện ích"
//        utilitiesVC.tabBarItem.selectedImage = UIImage(named: "fourth-selected")
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if permissionUtils.GPBH_1{
            
            viewControllers = [generateReportVC,orderRebuildVC,areaVC,feeRebuildVC,utilitiesVC]
            
        }else if permissionUtils.GPBH_2{
            
            
            if permissionUtils.GPQT_2_and_above {
                viewControllers = [orderRebuildVC,areaVC,reportVC,utilitiesVC]
            }else{
                if permissionUtils.Owner {
                    viewControllers = [generateReportVC,orderRebuildVC,areaVC,reportVC,utilitiesVC]
                }else{
                    viewControllers = [orderRebuildVC,areaVC,reportVC,utilitiesVC]
                }
            }
            
        }else{

            
            if permissionUtils.GPQT_2_and_above {
                viewControllers = [orderRebuildVC,areaVC,reportVC,utilitiesVC]
            }else{
                if permissionUtils.Owner {
                    viewControllers = [generateReportVC,orderRebuildVC,areaVC,reportVC,utilitiesVC]
                }else{
                    viewControllers = [orderRebuildVC,areaVC,reportVC,utilitiesVC]
                }
            }

        }


            
        
        
        tabBar.tintColor = .white
        tabBar.unselectedItemTintColor = .systemGray4
        tabBar.backgroundColor = ColorUtils.orange_brand_900()
        
        tabBar.layer.masksToBounds = true
        tabBar.isTranslucent = true
        tabBar.layer.cornerRadius = 30
        tabBar.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        tabBarController?.selectedIndex = 1
        
        for tabBarItem in tabBar.items ?? [] {
//                    tabBarItem.badgeValue = "99"
//                    tabBarItem.badgeColor = .blue
//            tabBarI
//            tabBarItem.imageInsets = UIEdgeInsets(top: 5, left: 0, bottom: -5, right: 0)
        }
        

        if permissionUtils.toggleWorkSession{
            checkWorkingSession()
        }
        
        if permissionUtils.reportSytemError{
            setUpChatSupport()
        }
    }
    
    //    MARK: UITabbar Delegate
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        
        if viewController.isKind(of: GenerateReportViewController.self) {
            dLog("Phạm khánh huy")
        }
        return true
        
    }
    
    
    
    private func setUpChatSupport(){
       
        view.addSubview(rootView)
        rootView.addSubview(imageView)
        rootView.addSubview(imageClose)
        rootView.addSubview(buttonClose)
        
        NSLayoutConstraint.activate([
            rootView.widthAnchor.constraint(equalToConstant: 75),
            rootView.heightAnchor.constraint(equalToConstant: 75),
            rootView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -70),
            rootView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            
            imageView.topAnchor.constraint(equalTo: rootView.topAnchor, constant: 6),
            imageView.bottomAnchor.constraint(equalTo: rootView.bottomAnchor, constant: -6),
            imageView.trailingAnchor.constraint(equalTo: rootView.trailingAnchor, constant: 6),
            imageView.leadingAnchor.constraint(equalTo: rootView.leadingAnchor, constant: -6),
            
            imageClose.widthAnchor.constraint(equalToConstant: 18),
            imageClose.heightAnchor.constraint(equalToConstant: 18),
            imageClose.topAnchor.constraint(equalTo: rootView.topAnchor, constant: 0),
            imageClose.trailingAnchor.constraint(equalTo: rootView.trailingAnchor, constant: 0),
            
            buttonClose.widthAnchor.constraint(equalToConstant: 30),
            buttonClose.heightAnchor.constraint(equalToConstant: 30),
            buttonClose.topAnchor.constraint(equalTo: rootView.topAnchor, constant: 0),
            buttonClose.trailingAnchor.constraint(equalTo: rootView.trailingAnchor, constant: 0)
        ])
        
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        rootView.addGestureRecognizer(panGesture)
        
        let tapGestureView = UITapGestureRecognizer(target: self, action: #selector(handleTapChatAdmin(_:)))
        rootView.addGestureRecognizer(tapGestureView)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapDelete(_:)))
        buttonClose.addGestureRecognizer(tapGesture)
            
        
    }
    
    
    
    @objc func handleTapChatAdmin(_ sender: UITapGestureRecognizer) {
        let chatChannelViewController = ChatChannelRouter().viewController as! ChatChannelViewController
        navigationController?.pushViewController(chatChannelViewController, animated: true)
    }
    
    @objc func handleTapDelete(_ sender: UITapGestureRecognizer) {
        rootView.removeFromSuperview()
    }
    
    @objc func handlePan(_ gesture: UIPanGestureRecognizer) {
        guard let superview = rootView.superview else { return }
        let translation = gesture.translation(in: superview)
        switch gesture.state {
        case .began, .changed:
            // Calculate the new position of the movingView
            let newX = rootView.center.x + translation.x
            let newY = rootView.center.y + translation.y
            // Ensure the new position stays within the bounds of the parent view
            let minX = rootView.frame.size.width / 2
            let maxX = superview.bounds.width - minX
            let minY = rootView.frame.size.height / 2
            let maxY = superview.bounds.height - minY
            let clampedX = min(maxX, max(minX, newX))
            let clampedY = min(maxY, max(minY, newY))
            // Update the center of the movingView with animation
            UIView.animate(withDuration: 0.1) {
                self.rootView.center = CGPoint(x: clampedX, y: clampedY)
            }
            // Reset the translation to avoid accumulation
            gesture.setTranslation(.zero, in: superview)
        default: break
        }
    }
    


}


//extension UITabBar {
//    override public func sizeThatFits(_ size: CGSize) -> CGSize {
//        super.sizeThatFits(size)
//        var sizeThatFits = super.sizeThatFits(size)
//        sizeThatFits.height = 50
//    
//
//        return sizeThatFits
//    }
//}

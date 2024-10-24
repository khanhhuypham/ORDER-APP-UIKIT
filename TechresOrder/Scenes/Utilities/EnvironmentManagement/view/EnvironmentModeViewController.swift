//
//  EnvironmentModeViewController.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 18/02/2024.
//

import UIKit

class EnvironmentModeViewController: UIViewController {

    var router = EnvironmentModeRouter()
    let list = ["develop", "staging", "production"]
    
    @IBOutlet weak var lbl_mode_type: UILabel!
    @IBOutlet weak var btn_choose_mode: UIButton!
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        router.setSourceView(self)
        var options:[UIAction] = []
        
        
      
              
        lbl_mode_type.text = String(format: "%@", list[environmentMode.value])
    
        list.enumerated().forEach{(i, item) in
                let option = UIAction(title: item, image: nil, identifier: nil, handler: { _ in
                    self.btn_choose_mode.menu = self.handleSelection(pos: i, menu:self.btn_choose_mode.menu!)
                    
                })
                options.append(option)
        }
        options[environmentMode.value].state = .on
        btn_choose_mode.menu = UIMenu(title: "", children: options)
    }
    

    @IBAction func actionBack(_ sender: Any) {
        router.navigateToPopViewController()
    }

    private func handleSelection(pos: Int,menu:UIMenu) -> UIMenu{
        lbl_mode_type.text = String(format: "%@", list[pos])
        menu.children.enumerated().forEach{(i, action) in
            guard let action = action as? UIAction else {
                return
            }
            action.state = action.title == list[pos] ? .on : .off
        }
        
        switch pos{
            case 0:
                environmentMode = .develop
                break
            case 1:
                environmentMode = .staging
                break
            case 2:
                environmentMode = .production
                break
            default:
                break
        }
        return menu
    }
}

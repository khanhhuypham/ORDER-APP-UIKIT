//
//  ConfirmMoveTableViewController.swift
//  TechresOrder
//
//  Created by Kelvin on 19/01/2023.
//

import UIKit

class ConfirmMoveTableViewController: UIViewController {

    @IBOutlet weak var root_view: UIView!
    var delegate:MoveTableDelegate?
    
    var destination_table:Table = Table()
    var target_table:Table = Table()
    
    var option:OrderAction = .splitFood
    
    
    @IBOutlet weak var lbl_title: UILabel!
    @IBOutlet weak var lbl_destination_table_name: UILabel!
    @IBOutlet weak var icon_destination_table: UIImageView!
    
    
    @IBOutlet weak var lbl_target_table_name: UILabel!
    @IBOutlet weak var icon_target_table: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        lbl_destination_table_name.text = destination_table.name
        lbl_target_table_name.text = target_table.name
    }
    
    override func viewWillAppear(_ animated: Bool) {
        lbl_title.text = option == .splitFood ? "XÁC NHẬN TÁCH MÓN" : "XÁC NHẬN TÁCH BÀN"
        
        switch target_table.status{
            case STATUS_TABLE_USING:
                icon_target_table.image = UIImage(named: "icon-table-active")
                break
            
            default:
                icon_target_table.image = UIImage(named: "icon-table-inactive")
                break
        }
        
    }

    @IBAction func actionCancel(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func actionConfirm(_ sender: Any) {
        dismiss(animated: true,completion: { [self] in
            delegate?.callBackComfirmMoveTable(destination_table: destination_table,target_table: target_table)
        })
       
    }
    
   
}

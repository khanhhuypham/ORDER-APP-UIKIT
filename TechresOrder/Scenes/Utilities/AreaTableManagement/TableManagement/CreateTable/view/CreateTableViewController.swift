//
//  CreateTableViewController.swift
//  TechresOrder
//
//  Created by Kelvin on 23/01/2023.
//

import UIKit
import JonAlert
class CreateTableViewController: BaseViewController {
    var viewModel = CreateTableViewModel()
    var delegate:TechresDelegate?
    
    
    @IBOutlet weak var root_view: UIView!
    
    @IBOutlet weak var lbl_title: UILabel!
    
    @IBOutlet weak var textfield_name: UITextField!
    
    @IBOutlet weak var btn_choose_area: UIButton!
    
    @IBOutlet weak var Menu: UIMenu!
    @IBOutlet weak var image_dropdown: UIImageView!
    
    @IBOutlet weak var textfield_number_slot: UITextField!
    
    @IBOutlet weak var btn_active: UIButton!
    @IBOutlet weak var btn_confirm: UIButton!

    var areaArray:[Area] = []
    var table = Table()
    
    let btnAttr = [
        NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14, weight: .regular),
        NSAttributedString.Key.foregroundColor: ColorUtils.black()
    ]


    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.bind(view: self)
        viewModel.area_array.accept(areaArray)
        viewModel.table.accept(table)
        setUpAndValidate(table: table)

    }
    
    @IBAction func actionStickCheckBox(_ sender: Any) {
        btn_active.isSelected = !btn_active.isSelected
        var table = viewModel.table.value
        table.status = btn_active.isSelected ? ACTIVE : DEACTIVE
        viewModel.table.accept(table)
    }
    
    @IBAction func actionCancel(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func actionAdd(_ sender: Any) {
        createTable()
    }
    
}

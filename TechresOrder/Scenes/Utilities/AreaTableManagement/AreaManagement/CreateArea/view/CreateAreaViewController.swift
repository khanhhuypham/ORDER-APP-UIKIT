//
//  CreateAreaViewController.swift
//  TechresOrder
//
//  Created by Kelvin on 23/01/2023.
//

import UIKit
import RxSwift
import JonAlert
class CreateAreaViewController: BaseViewController {
    var viewModel = CreateAreaViewModel()


    @IBOutlet weak var root_view: UIView!
    @IBOutlet weak var textfield_area_name: UITextField!

    @IBOutlet weak var btnStatus: UIButton!
    @IBOutlet weak var btnCreate: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var lbl_header: UILabel!

    var area = Area()!
    var completeHandler:(()->Void)? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.area.accept(area)
        mappData(area: area)
        validate()
    }
    
    func mappData(area:Area){
        lbl_header.text = area.id > 0 ? "CẬP NHẬT KHU VỰC" : "THÊM KHU VỰC"
        textfield_area_name.text = area.name
        area.status == ACTIVE ? actionStickStatusCheckbox("") : {}()
        btnStatus.isHidden = area.id > 0 ? false : true
        btnCreate.setTitle(area.id > 0 ? "CẬP NHẬT" :"THÊM MỚI", for: .normal)
    }
    
    @IBAction func actionStickStatusCheckbox(_ sender: Any) {
        btnStatus.isSelected = !btnStatus.isSelected
        var area = viewModel.area.value
        area.status = btnStatus.isSelected ? ACTIVE : DEACTIVE
        viewModel.area.accept(area)
    }
    
    
    @IBAction func actionDismiss(_ sender: Any) {
        dismiss(animated: true)
    }
    

    @IBAction func actionCreate(_ sender: Any) {
        createArea()
    }
    
}

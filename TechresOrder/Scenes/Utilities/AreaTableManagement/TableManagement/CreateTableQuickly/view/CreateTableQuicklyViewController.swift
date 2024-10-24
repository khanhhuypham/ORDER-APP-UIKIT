//
//  CreateTableQuicklyViewController.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 19/01/2024.
//

import UIKit

class CreateTableQuicklyViewController: BaseViewController {
    var viewModel = CreateTableQuicklyViewModel()
    
    var completeHandler:(()->Void)? = nil
    @IBOutlet weak var root_view: UIView!
    
    @IBOutlet weak var textfield_name: UITextField!
    
    @IBOutlet weak var textfield_number_from: UITextField!
    
    @IBOutlet weak var textfield_number_to: UITextField!
    @IBOutlet weak var btn_show_area: UIButton!
    
    @IBOutlet weak var textfield_slot: UITextField!
    @IBOutlet weak var lbl_example: UILabel!
    
    
    @IBOutlet weak var btnAdd: UIButton!
    
    
    var areaArray:[Area] = []
    
    let btnAttr = [
        NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13, weight: .regular),
        NSAttributedString.Key.foregroundColor: ColorUtils.black()
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.bind(view: self)
        viewModel.areaList.accept(areaArray)
        mapDataAndValidate()
        // Do any additional setup after loading the view.
    
        lbl_example.text = "Ví dụ: Cần tạo 3 bàn có tên là Bàn1 , Bàn2, Bàn3 \nKý tự bắt đầu là Bàn Số bắt đầu là 1 và số kết thúc là 3"
    }


    
    @IBAction func actionCancel(_ sender: Any) {
        dismiss(animated: true)
    }
    
   
    @IBAction func actionAdd(_ sender: Any) {
        createTableList()
    }
    
}




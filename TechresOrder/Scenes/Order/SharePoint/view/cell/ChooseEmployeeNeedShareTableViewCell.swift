//
//  ChooseEmployeeNeedShareTableViewCell.swift
//  TechresOrder
//
//  Created by Kelvin on 27/01/2023.
//

import UIKit

class ChooseEmployeeNeedShareTableViewCell: UITableViewCell {
    @IBOutlet weak var avatar: UIImageView!
    
    @IBOutlet weak var lbl_department_name: UILabel!
    @IBOutlet weak var lbl_role_name: UILabel!
    @IBOutlet weak var lbl_name: UILabel!
    @IBOutlet weak var iconCheck: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    @IBAction func actionChoosEmployee(_ sender: Any) {
        guard let viewModel = self.viewModel else {return}
        guard let data = self.data else {return}
        
        var employees_selected = viewModel.employeesSelected.value
        
        var employees = viewModel.dataArray.value
        
            if(data.isSelect == 0){
                employees.enumerated().forEach { (index, value) in
                    if(data.id == value.id){
                        employees[index].isSelect = 1
                        employees_selected.append(data)
                    }
                }
               
            }else{
                employees.enumerated().forEach { (index, value) in
                    if(data.id == value.id){
                        employees[index].isSelect = 0
                    }
                }
                for i in 0..<employees_selected.count {
                    if employees_selected[i].id == data.id {
                        employees_selected.remove(at: i)
                        break
                    }
                }

              
            }
        viewModel.employeesSelected.accept(employees_selected)
        viewModel.dataArray.accept(employees)
        
    }
    
    
    
    var viewModel: ChooseEmployeeNeedShareViewModel?
    
    // MARK: - Variable -
    public var data: Account? = nil {
        didSet {
            lbl_name.text = data?.name
            lbl_role_name.text = data?.username
            lbl_department_name.text = data?.role_name
            avatar.kf.setImage(with: URL(string: Utils.getFullMediaLink(string: data!.avatar)), placeholder:  UIImage(named: "image_defauft_medium"))
            iconCheck.image = UIImage(named: data!.isSelect==ACTIVE ? "check_2" : "un_check_2")
            
        }
    }
    
}

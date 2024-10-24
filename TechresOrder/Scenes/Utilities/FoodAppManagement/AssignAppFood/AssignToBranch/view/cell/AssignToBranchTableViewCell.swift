//
//  AssignToBranchTableViewCell.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 30/09/2024.
//

import UIKit

class AssignToBranchTableViewCell: UITableViewCell {

    @IBOutlet weak var lbl_slot: UILabel!
    
    @IBOutlet weak var lbl_branch_name: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    var viewModel: AssignToBranchViewModel?
    
    var slot:(slotNumber:Int,branch:BranchOfFoodApp?)? {
        didSet{
            guard let slot = self.slot else {return}
            lbl_slot.text = String(format: "Điểm bán %d", slot.slotNumber)
            
            if let branch = slot.branch{
              
             
                lbl_branch_name.text = branch.branch_name
            }else{
                lbl_branch_name.text = "Vui lòng chọn"
            }
        }
    }
    
    
    @IBAction func actionShowFilter(_ sender: UIButton) {
        guard 
            let viewModel = self.viewModel,
            let slot = self.slot
        else {return}
        
        viewModel.selectedslot.accept(slot.slotNumber)
        viewModel.view?.showList(list: viewModel.branches.value.filter{$0.isSelect == false}, btn: sender)
        
    }
    
}

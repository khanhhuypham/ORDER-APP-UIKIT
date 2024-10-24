//
//  AssignToBranchViewController.swift
//  TECHRES-ORDER
//
//  Created by Huynh Quang Huy on 26/8/24.
//

import UIKit

class AssignToBranchViewController: BaseViewController {

    var viewModel = AssignToBranchViewModel()
    var router = AssignToBranchRouter()
    var partner:FoodAppAPartner = FoodAppAPartner()

    @IBOutlet weak var branchAvatarImg: UIImageView!
    @IBOutlet weak var branchNameLbl: UILabel!
    @IBOutlet weak var branchAddressLbl: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var confirmBtn: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.bind(view: self, router: router)
        viewModel.partner.accept(partner)
        firstSetup()

        getBranches()
        
    }
    

    
    @IBAction func actionConfirm(_ sender: Any) {
        aassignBrach()
    }
    
    @IBAction func actionBack(_ sender: Any) {
        viewModel.makePopViewController()
    }
    
    
    
}


extension AssignToBranchViewController{
    
    func firstSetup() {
        bindTableViewAndRegisterCell()
        branchAvatarImg.kf.setImage(with: URL(string: Utils.getFullMediaLink(string: ManageCacheObject.getCurrentBranch().image_logo)), placeholder: UIImage(named: "image_defauft_medium"))
        branchNameLbl.text = Constants.branch.name
        branchAddressLbl.text = Constants.branch.address
        
        
        var slotNumber = 0
        switch viewModel.partner.value.code {
            case .shoppee:
                slotNumber = Constants.branch.setting.maximum_shf_slot
            
            case .grabfood:
                slotNumber = Constants.branch.setting.maximum_grf_slot
            
            case .gofood:
                break
            
            case .befood:
                slotNumber = Constants.branch.setting.maximum_bef_slot
        }
        var slot:[(slotNumber:Int,branch:BranchOfFoodApp?)] = []
        
        for i in (1...slotNumber){
            slot.append((i,nil))
        }
        
        viewModel.slots.accept(slot)
        

    }
     
    func bindTableViewAndRegisterCell(){
        registerCell()
        bindTableViewData()
    }
    
    private func registerCell() {
        let cell = UINib(nibName: "AssignToBranchTableViewCell", bundle: .main)
        tableView.register(cell, forCellReuseIdentifier: "AssignToBranchTableViewCell")
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    
    private func bindTableViewData() {
        viewModel.slots.bind(to: tableView.rx.items(cellIdentifier: "AssignToBranchTableViewCell", cellType: AssignToBranchTableViewCell.self))
           {  (row, item, cell) in
               cell.viewModel = self.viewModel
               dLog(item)
               cell.slot = item
           }.disposed(by: rxbag)
       }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }


}
 

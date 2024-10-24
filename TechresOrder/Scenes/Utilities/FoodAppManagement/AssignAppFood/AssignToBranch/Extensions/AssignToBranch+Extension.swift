//
//  AssignToBranch+Extension.swift
//  TECHRES-ORDER
//
//  Created by Huynh Quang Huy on 26/8/24.
//


import ObjectMapper
extension AssignToBranchViewController {
    
    func getBranches() {
        appServiceProvider.rx.request(.getBranchesOfChannelOrderFood(
            brand_id: Constants.brand.id,
            branch_id: Constants.branch.id,
            channel_order_food_id:viewModel.partner.value.id
        ))
        .filterSuccessfulStatusCodes()
        .mapJSON().asObservable()
        .showAPIErrorToast()
        .mapObject(type: APIResponse.self).subscribe(onNext: { [weak self] response in
            guard let self = self else { return }
            
            if(response.code == RRHTTPStatusCode.ok.rawValue){
                if var list  = Mapper<BranchOfFoodApp>().mapArray(JSONObject: response.data){
                    var firstElement = BranchOfFoodApp()
                    firstElement.branch_name = "Vui lòng chọn"
                    firstElement.channel_order_food_token_id = -1
                    list.insert(firstElement, at: 0)
                    self.viewModel.branches.accept(list)
                    self.getAssignedBranches()
                }
            }else{
                self.showWarningMessage(content: response.message ?? "")
            }
           

        }).disposed(by: rxbag)
        
    }
    
    
    func getAssignedBranches() {
        appServiceProvider.rx.request(.getAssignedBranchOfFoodApp(branch_id: Constants.branch.id, channel_order_food_id: viewModel.partner.value.id))
        .mapJSON().asObservable()
        .showAPIErrorToast()
        .mapObject(type: APIResponse.self).subscribe(onNext: { [weak self] response in
            guard let self = self else { return }
            
            if(response.code == RRHTTPStatusCode.ok.rawValue){
                if let list  = Mapper<BranchOfFoodApp>().mapArray(JSONObject: response.data){
                    
                    var branchList = self.viewModel.branches.value
                    
                    var slots = self.viewModel.slots.value
                    
                    for (i,branch) in branchList.enumerated(){
                        for (j,assignBranch) in list.enumerated(){
                             
                            
                            if branch.channel_order_food_token_id == assignBranch.channel_order_food_token_id{
                                branchList[i].isSelect = true
                                slots[j].branch =  branchList[i]
                            }
                           
                        }
                    }
                    
                    viewModel.branches.accept(branchList)
                    
                    viewModel.slots.accept(slots)
                    
                }
            }else{
                self.showWarningMessage(content: response.message ?? "")
            }
            
            
        }).disposed(by: rxbag)
        
    }
    
    func aassignBrach() {
        var seletedBranch:[[String:Any]] = []
            
        for branch in viewModel.branches.value.filter{$0.isSelect && $0.channel_order_food_token_id > 0}{
            seletedBranch.append([
                "channel_branch_id": branch.branch_id,
                "channel_order_food_token_id": branch.channel_order_food_token_id
            ])
        }
        
        appServiceProvider.rx.request(.postAssignBrachOfFoodApp(
            branch_id: Constants.branch.id,
            channel_order_food_id: partner.id,
            branch_maps: seletedBranch)
        )
        .mapJSON().asObservable()
        .showAPIErrorToast()
        .mapObject(type: APIResponse.self).subscribe(onNext: { [weak self] response in
            guard let self = self else { return }
            self.showSuccessMessage(content: "Gán chi nhánh thành công")
            self.actionBack("")

        }).disposed(by: rxbag)
        
    }
}

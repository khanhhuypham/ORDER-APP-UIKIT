//
//  AssignToBranch+Extension.swift
//  TECHRES-ORDER
//
//  Created by Huynh Quang Huy on 26/8/24.
//

import UIKit
import ObjectMapper
import JonAlert

extension AssignToBranchViewController {
    func getBranch() {
        viewModel.getBranch().subscribe(onNext: { [weak self] response in
            guard let self = self else { return }
            
            if (response.code == RRHTTPStatusCode.ok.rawValue) {
                if let dataFromServer = Mapper<BranchMapsFoodApp>().mapArray(JSONObject: response.data) {
                    self.listOptions = dataFromServer.map { $0.channel_branch_name }
                    self.viewModel.dataArray.accept(dataFromServer)
                    self.viewModel.branch_maps.accept(dataFromServer)
                    if let p = dataFromServer.firstIndex(where: {$0.branch_id > 0}){
                        selectAt(pos: p)
                    }
                    
                } else {
                    dLog(response.message ?? "Có lỗi xảy ra trong quá trình kết nối tới máy chủ. Vui lòng thử lại")
                }
            } else if (response.code == RRHTTPStatusCode.badRequest.rawValue) {
                branchNameTxt.text = response.message ?? ""
                JonAlert.show(message: response.message ?? "", andIcon: UIImage(named: "icon-warning"), duration: 2.5)
                dLog(response.message ?? "")
            } else {
                dLog(response.message ?? "")
            }
        })
        .disposed(by: rxbag)
    }
    
    func postAssignBranch() {
        viewModel.postAssignBranchFoodApp().subscribe(onNext: { [weak self] response in
            guard let self = self else { return }
            
            if (response.code == RRHTTPStatusCode.ok.rawValue) {
                JonAlert.showSuccess(message: "Đã cập nhật thành công")
                viewModel.makePopViewController()
            } else {
                JonAlert.showError(message: response.message ?? "Cập nhật không thành công")
                dLog(response.message ?? "")
            }
        })
        .disposed(by: rxbag)
    }

}

extension AssignToBranchViewController: ArrayChooseViewControllerDelegate {
    func showFilter() {
        listIcons.append("icon-split-food")
        let controller = ArrayChooseViewController(Direction.allValues)
        controller.listString = listOptions
        controller.list_icons = listIcons
        controller.preferredContentSize = CGSize(width: 250, height: setHeightForDropDown(listOptions.count) ?? 70)
        controller.delegate = self
        showPopup(controller, sourceView: self.showFilterBtn)
    }
    
    private func setHeightForDropDown(_ listCount: Int) -> Int? {
        var height = 0
        if listCount == 0 {
            height = 70
        } else if listCount > 5 {
            height = 350
        } else {
            height = listCount * 70
        }
        return height
    }
    
    private func showPopup(_ controller: UIViewController, sourceView: UIView) {
        let presentationController = AlwaysPresentAsPopover.configurePresentation(forController: controller)
        presentationController.sourceView = sourceView
        presentationController.sourceRect = sourceView.bounds
        presentationController.permittedArrowDirections = [.up]
        self.present(controller, animated: true)
    }
  
    func selectAt(pos: Int) {
        branchNameTxt.text = listOptions[pos]
        var dataPos = viewModel.dataArray.value[pos]
        var dataBranchMaps = viewModel.branch_maps.value
        let isContain = dataBranchMaps.contains(where: { $0.branch_id > 0 })

        if isContain {
            dataBranchMaps.enumerated().forEach{ (index, value) in
                if index == pos {
                    dataBranchMaps[index].branch_id = ManageCacheObject.getCurrentBranch().id
                } else {
                    dataBranchMaps[index].branch_id = 0
                }
            }
        } else {
            viewModel.branch_maps.accept([])
            dataPos.branch_id = ManageCacheObject.getCurrentBranch().id
            dataBranchMaps.append(dataPos)
        }
        
        viewModel.branch_maps.accept(dataBranchMaps)
    }

    
}

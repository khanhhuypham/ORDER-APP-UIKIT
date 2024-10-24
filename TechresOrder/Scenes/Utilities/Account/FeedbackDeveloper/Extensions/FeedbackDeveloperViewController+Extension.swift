//
//  FeedbackDeveloperViewController+Extension.swift
//  TechresOrder
//
//  Created by Kelvin on 15/02/2023.
//

import UIKit
import JonAlert
extension FeedbackDeveloperViewController {
    func showChooseFeedbackType(){
        var listName = [String]()
        var listIcon = [String]()
           
        for feedback_type_name in self.feedback_type_names {
            listName.append(feedback_type_name)
            listIcon.append("baseline_account_balance_black_48pt")
        }
           
        let controller = ArrayChooseViewController(Direction.allValues)
        
        controller.list_icons = listIcon
        controller.listString = listName
        controller.preferredContentSize = CGSize(width: 300, height: 300)
        controller.delegate = self
        
        showPopup(controller, sourceView: btnChooseFeedbackType)
    }
    private func showPopup(_ controller: UIViewController, sourceView: UIView) {
        let presentationController = AlwaysPresentAsPopover.configurePresentation(forController: controller)
        presentationController.sourceView = sourceView
        presentationController.sourceRect = sourceView.bounds
        presentationController.permittedArrowDirections = [.down, .up]
        self.present(controller, animated: true)
    }
    
}
extension FeedbackDeveloperViewController: ArrayChooseViewControllerDelegate{
    func selectAt(pos: Int) {
        dLog(self.feedback_type_names[pos])
        lbl_feedback_type.text = self.feedback_type_names[pos]
//        viewModel.kitchen_id.accept(self.kitchense[pos].id)
        
        //hien set bằng true khi người dùng chọn loại góp ý
        self.ischoose = true
    }
    
}
extension FeedbackDeveloperViewController{
    func feedbackDeveloper(){
        viewModel.feedbackDeveloper().subscribe(onNext: { (response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){
                dLog("Feedback Success...")
//                Toast.show(message: "Feedback Success...", controller: self)
                JonAlert.showSuccess(message: "Feedback Success...", duration: 2.0)
                self.navigationController?.popViewController(animated: true)
            }else{
//                Toast.show(message: response.message ?? "Feedback có lỗi xảy ra", controller: self)
                dLog(response.message)
                JonAlert.showError(message: response.message ?? "Có lỗi xảy ra trong quá trình kết nối tới máy chủ.", duration: 2.0)
            }
        }).disposed(by: rxbag)
}
}


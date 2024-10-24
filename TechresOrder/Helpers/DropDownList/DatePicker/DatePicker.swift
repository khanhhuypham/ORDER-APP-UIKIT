//
//  DatePicker.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 07/12/2023.
//

import UIKit


class DatePicker{
   
//    func showDatePicker() {
//        
//        if parentView != nil {
//            parentView.removeFromSuperview()
//        }
//        
//        let datePicker = UIDatePicker()
//        datePicker.date = Date()
//        datePicker.backgroundColor = .white
//        datePicker.locale = Locale.init(identifier: "vi") //Xem danh sách locale của ngôn ngữ các nước tại https://gist.github.com/jacobbubu/1836273
//        datePicker.preferredDatePickerStyle = .wheels
//        datePicker.datePickerMode = .date
//        datePicker.tintColor = ColorUtils.orange_brand_900()
//        datePicker.addTarget(self, action: #selector(handler(sender:)), for: UIControl.Event.valueChanged)
//        
//        // Give the background Blur Effect
//        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.light)
//        let blurView = UIVisualEffectView(effect: blurEffect)
//        blurView.cornerRadius = 15
//        blurView.clipsToBounds = true
//        
//        parentView = UIView()
//        parentView.layer.shadowColor = UIColor.black.cgColor
//        parentView.layer.masksToBounds = false
//        parentView.layer.shadowOffset = CGSize(width: 1.5, height: 1.5)
//        parentView.layer.shadowRadius = 10
//        parentView.layer.shadowOpacity = 0.3
//
//        parentView.addSubview(blurView)
//        parentView.addSubview(datePicker)
//        parentView.translatesAutoresizingMaskIntoConstraints = false
//        blurView.translatesAutoresizingMaskIntoConstraints = false
//        view.addSubview(parentView)
//        
//        NSLayoutConstraint.activate([
//            parentView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            parentView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
//            parentView.heightAnchor.constraint(equalToConstant: datePicker.frame.height),
//            parentView.widthAnchor.constraint(equalToConstant: datePicker.frame.width),
//            blurView.heightAnchor.constraint(equalToConstant: datePicker.frame.height),
//            blurView.widthAnchor.constraint(equalToConstant: datePicker.frame.width),
//        ])
//        view.bringSubviewToFront(parentView)
//        view.layoutIfNeeded()
//        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
//        panGesture.delegate = self
//        
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapOutSide(_:)))
//        tapGesture.cancelsTouchesInView = false
//        tapGesture.delegate = self
//        view.gestureRecognizers = [panGesture,tapGesture]
//        
//      
//        // animate to show contentView
//        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.4, options: .curveLinear, animations: {
//            self.parentView.frame = CGRect(
//                                    x: -self.parentView.frame.width,
//                                    y:  self.view.frame.height - self.parentView.frame.height,
//                                    width: self.view.frame.width,
//                                    height: self.parentView.frame.height)
//            
//        }, completion: nil)
//      
//        
//     }
//
//    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
//        return true
//    }
//    
// 
//    @objc private func handlePanGesture(_ panGesture:UIPanGestureRecognizer) {
//        let panLocation = panGesture.location(in: parentView)
//        if !parentView.bounds.contains(panLocation){
//            parentView.removeFromSuperview()
//            parentView.removeFromSuperview()
//        }
//    }
//    
//    @objc private func handleTapOutSide(_ tapGesture:UITapGestureRecognizer){
//        let tapLocation = tapGesture.location(in: parentView)
//        if !parentView.bounds.contains(tapLocation){
//            parentView.removeFromSuperview()
//            parentView.removeFromSuperview()
//        }
//    }
//    
//    @objc func handler(sender: UIDatePicker) {
//        let timeFormatter = DateFormatter()
//        timeFormatter.dateFormat = "MM/yyyy"
//        let strDate = timeFormatter.string(from: sender.date)
//        var report = viewModel.revenueCostProfitReport.value
//        report.dateString = strDate
//        report.fromDate = strDate
//        report.reportType = REPORT_TYPE_THIS_MONTH
//        viewModel.revenueCostProfitReport.accept(report)
//        self.getRevenueCostProfitReport()
//        
//    }
}

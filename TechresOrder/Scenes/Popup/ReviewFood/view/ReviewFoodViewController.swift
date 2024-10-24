//
//  ReviewFoodViewController.swift
//  TechresOrder
//
//  Created by Kelvin on 22/01/2023.
//

import UIKit
import RxSwift
import JonAlert

class ReviewFoodViewController: BaseViewController {
    var viewModel = ReviewFoodViewModel()
    var order_id = 0
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var view_nodata: UIView!
    @IBOutlet weak var root_view: UIView!

    var delegate:TechresDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        viewModel.bind(view: self)
        registerCell()
        bindTableViewData()
        Utils.isHideAllView(isHide: true, view: self.view_nodata)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.order_id.accept(self.order_id)
        getFoodsNeedReview()
    }

    @IBAction func actionReview(_ sender: Any) {
        var data_reviews = [Review]()
    

        for food in viewModel.dataArray.value.filter{$0.review_score != 0} {
            var reviewData = Review.init()
            reviewData?.note = food.note
            reviewData?.score = food.review_score
            reviewData?.order_detail_id = food.id
            data_reviews.append(reviewData!)
            
            print(food.name, " ", food.note, " ", food.review_score)
        }
        
        if(data_reviews.count > 0){
            self.reviewFood(reViewData: data_reviews)
        }else{
            JonAlert.showError(message: "Bạn hãy chọn mức độ hài lòng của món ăn trước khi thực hiện việc đánh giá", duration: 3.0)
        }
    }
    
    @IBAction func actionCancel(_ sender: Any) {
        dismiss(animated: true)
    }
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            let adjustedKeyboardFrame = view.convert(keyboardFrame, from: nil)
            let intersection = view.frame.intersection(adjustedKeyboardFrame)
            let keyboardHeight = intersection.size.height

            // Thay đổi vị trí của root_view để nó di chuyển lên trên bàn phím
            root_view.frame.origin.y = view.frame.height - keyboardHeight * 0.85 - root_view.frame.height
        }
    }

    @objc func keyboardWillHide(_ notification: Notification) {
        // Đặt lại vị trí ban đầu của root_view khi bàn phím ẩn đi
        root_view.center = CGPoint(x: view.bounds.midX, y: view.bounds.midY)
    }
}
extension ReviewFoodViewController{
    func registerCell() {
        let reviewFoodTableViewCell = UINib(nibName: "ReviewFoodTableViewCell", bundle: .main)
        tableView.register(reviewFoodTableViewCell, forCellReuseIdentifier: "ReviewFoodTableViewCell")
        self.tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.singleLine

    }
 
    private func bindTableViewData() {
        viewModel.dataArray.bind(to: tableView.rx.items(cellIdentifier: "ReviewFoodTableViewCell", cellType: ReviewFoodTableViewCell.self)){ [weak self]  (row, data, cell) in
            cell.viewModel = self?.viewModel
            cell.data = data
           
    
            
        }.disposed(by: rxbag)
    }
}


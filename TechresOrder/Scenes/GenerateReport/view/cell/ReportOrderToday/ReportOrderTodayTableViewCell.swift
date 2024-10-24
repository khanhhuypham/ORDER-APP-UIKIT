//
//  ReportOrderTodayTableViewCell.swift
//  TechresOrder
//
//  Created by macmini_techres_03 on 16/01/2023.
//

import UIKit
import RxSwift

class ReportOrderTodayTableViewCell: UITableViewCell {

    @IBOutlet weak var lbl_amount_paid: UILabel!
    
    @IBOutlet weak var lbl_servicing: UILabel!
    
    
    private(set) var disposeBag = DisposeBag()
        override func prepareForReuse() {
            super.prepareForReuse()
            disposeBag = DisposeBag()
        }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    var viewModel: GenerateReportViewModel? {
           didSet {
               bindViewModel()
           }
    }

}
extension ReportOrderTodayTableViewCell{
    private func bindViewModel() {
        if let viewModel = viewModel {
            viewModel.dailyOrderReport.subscribe( // Thực hiện subscribe Observable data food
              onNext: { [weak self] orderReportDaily in
                  self?.lbl_servicing.text = String(format: "%d", orderReportDaily.order_serving )
                  self?.lbl_amount_paid.text = String(format: "%d", orderReportDaily.order_served )
              }).disposed(by: disposeBag)
            
        }
    }
}

//
//  ReportCustomerTodayTableViewCell.swift
//  TechresOrder
//
//  Created by macmini_techres_03 on 16/01/2023.
//

import UIKit
import RxSwift
class ReportCustomerTodayTableViewCell: UITableViewCell {

    @IBOutlet weak var lbl_ready_service: UILabel!
    
    @IBOutlet weak var lbl_customer_servicing: UILabel!
    
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
extension ReportCustomerTodayTableViewCell{
    private func bindViewModel() {
            if let viewModel = viewModel {
                viewModel.dailyOrderReport.subscribe( // Thực hiện subscribe Observable data food
                  onNext: { [weak self] (dailyOrderReport) in
                      self?.lbl_customer_servicing.text = Utils.stringVietnameseMoneyFormatWithNumberInt(amount: dailyOrderReport.customer_slot_serving)
                      self?.lbl_ready_service.text = Utils.stringVietnameseMoneyFormatWithNumberInt(amount: dailyOrderReport.customer_slot_served)
                  }).disposed(by: disposeBag)
                
            }
            
     }
        
}

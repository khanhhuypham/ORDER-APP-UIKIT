//
//  ReportTotalAmountTempTodayTableViewCell.swift
//  TechresOrder
//
//  Created by macmini_techres_03 on 16/01/2023.
//

import UIKit
import RxSwift
class ReportTotalAmountTempTodayTableViewCell: UITableViewCell {

    @IBOutlet weak var lbl_total_amout_in_day: UILabel!
    @IBOutlet weak var lbl_total_cash: UILabel!
    @IBOutlet weak var lbl_total_atm: UILabel!
    @IBOutlet weak var lbl_total_transfer: UILabel!
    @IBOutlet weak var lbl_total_point_used: UILabel!
    @IBOutlet weak var lbl_total_sell: UILabel!
    @IBOutlet weak var lbl_total_debit: UILabel!
    
    
    @IBOutlet weak var total_amount_GRF: UILabel!
    @IBOutlet weak var total_amount_SHF: UILabel!
    @IBOutlet weak var total_amount_GOF: UILabel!
    @IBOutlet weak var total_amount_BEF: UILabel!

    
    
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
    
    
    var viewModel:GenerateReportViewModel? {
       didSet {
           guard let viewModel = self.viewModel else {return}
            viewModel.dailyOrderReport.subscribe(onNext: { [self] (dailyOrderReport) in
                lbl_total_amout_in_day.text =  Utils.stringVietnameseMoneyFormatWithNumberInt(amount: dailyOrderReport.total_amount)
                lbl_total_cash.text =  Utils.stringVietnameseMoneyFormatWithNumberInt(amount: dailyOrderReport.cash_amount)
                lbl_total_atm.text = Utils.stringVietnameseMoneyFormatWithNumberInt(amount: dailyOrderReport.bank_amount)
                lbl_total_transfer.text = Utils.stringVietnameseMoneyFormatWithNumberInt(amount: dailyOrderReport.transfer_amount)

                lbl_total_sell.text =  Utils.stringVietnameseMoneyFormatWithNumberInt(amount: dailyOrderReport.revenue_paid)
                lbl_total_debit.text =  Utils.stringVietnameseMoneyFormatWithNumberInt(amount: dailyOrderReport.deposit_amount)
            }).disposed(by: disposeBag)
           
           
           
           viewModel.foodAppReport.subscribe(onNext: { [self] (report) in
          
               total_amount_GOF.text = Utils.stringVietnameseMoneyFormatWithNumberInt(amount: report.total_revenue_GOF)
               total_amount_BEF.text = Utils.stringVietnameseMoneyFormatWithNumberInt(amount: report.total_revenue_BEF)
               total_amount_GRF.text = Utils.stringVietnameseMoneyFormatWithNumberInt(amount: report.total_revenue_GRF)
               total_amount_SHF.text = Utils.stringVietnameseMoneyFormatWithNumberInt(amount: report.total_revenue_SHF)
              
           }).disposed(by: disposeBag)
           
       }
    }

}


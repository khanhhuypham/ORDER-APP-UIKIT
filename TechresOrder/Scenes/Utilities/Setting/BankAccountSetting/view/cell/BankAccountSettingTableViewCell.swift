//
//  BankAccountSettingTableViewCell.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 16/04/2024.
//

import UIKit

class BankAccountSettingTableViewCell: UITableViewCell {

    @IBOutlet weak var lbl_order: UILabel!
    @IBOutlet weak var lbl_bank: UILabel!
    @IBOutlet weak var lbl_bank_account: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    var viewModel: BankAccountSettingViewModel?

    var data: BankAccount?{
        didSet {
            lbl_bank.text = data?.bank_name
            lbl_bank_account.text = String(format: "%@\n%@", data?.bank_number ?? "", data?.bank_account_name ?? "")
        }
    }
    
}

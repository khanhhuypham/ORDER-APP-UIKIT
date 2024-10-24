//
//  EmployeeSelectedCollectionViewCell.swift
//  TechresOrder
//
//  Created by macmini_techres_03 on 30/01/2023.
//

import UIKit
import RxSwift

class EmployeeSelectedCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var lbl_name: UILabel!
    
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var btnDeleted: UIButton!
    
    private(set) var disposeBag = DisposeBag()
        override func prepareForReuse() {
            super.prepareForReuse()
            disposeBag = DisposeBag()
        }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    public var data: Account? = nil{
        didSet{
            lbl_name.text = data?.name
            
//            avatar.kf.setImage(with: URL(string: Utils.getFullMediaLink(string: (data!.avatar))), placeholder: UIImage(named: "image_defauft_medium"))
            
           avatar.kf.setImage(with: URL(string: Utils.getFullMediaLink(string: data!.avatar)), placeholder:  UIImage(named: "image_defauft_medium"))
            
        }
    }
}

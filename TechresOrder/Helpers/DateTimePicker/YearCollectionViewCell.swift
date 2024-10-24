//
//  YearCollectionViewCell.swift
//  ORDER
//
//  Created by Pham Khanh Huy on 02/07/2023.
//

import UIKit

class YearCollectionViewCell: UICollectionViewCell {
    var yearLabel:UILabel!
    var darkColor = UIColor(red: 0, green: 22.0/255.0, blue: 39.0/255.0, alpha: 1)
    var highlightColor = UIColor(red: 0/255.0, green: 199.0/255.0, blue: 194.0/255.0, alpha: 1)
    
    override init(frame: CGRect) {
        yearLabel = UILabel(frame: CGRect(x: 5, y: 10, width: frame.width - 10, height: 20))
        yearLabel.font = UIFont.systemFont(ofSize: 15)
        yearLabel.textAlignment = .center
        yearLabel.textColor = darkColor
        
        super.init(frame: frame)
        
        contentView.addSubview(yearLabel)
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 3
        contentView.layer.masksToBounds = true
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = darkColor.withAlphaComponent(0.2).cgColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var isSelected: Bool {
        didSet {
            yearLabel.textColor = isSelected == true ? .white : darkColor
            contentView.backgroundColor = isSelected == true ? highlightColor : .white
            contentView.layer.borderWidth = isSelected == true ? 0 : 1
        }
    }
}

//
//  DialogSelectMonthViewController.swift
//  TechresOrder
//
//  Created by Kelvin on 04/02/2023.
//

import UIKit


class DialogSelectMonthViewController: BaseViewController {
    var viewModel = DialogSelectMonthViewModel()
    
    @IBOutlet weak var containView: UIView!
    @IBOutlet weak var containView_height: NSLayoutConstraint!
    
    var month = 1
    var year = 2023
    var delegate:MonthSelectDelegate?
    
   var data = [1,2,3,4,5,6,7,8,9,10,11,12]
    
    @IBOutlet weak var year_lbl: UILabel!
    @IBOutlet weak var month_collectionView: UICollectionView!
    
    
    
    @IBAction func btn_next(_ sender: Any) {
        if (year == 12) {
            year = 1
        }
        else {
            year += 1
        }
        
        year_lbl.text = "NĂM \(year)"
    }
    
    @IBAction func btn_prev(_ sender: Any) {
        if (year == 1) {
            year = 12
        }
        else {
            year -= 1
        }
        
        year_lbl.text = "NĂM \(year)"
    }
    
    @IBAction func btn_cancle(_ sender: Any) {
        delegate?.selected(month: month, year: year)
        self.dismiss(animated: false, completion: nil)
    }
    

    
    override func viewDidLoad() {
        super.viewDidLoad()

//        self.month_collectionView.register(MonthSelectCollectionViewCell.self, forCellWithReuseIdentifier: "MonthSelectCollectionViewCell")
        
        containView_height.constant = 350
//        title_height.constant = 60
        
        year_lbl.text = "NĂM \(year)"
        
 
        registerCell()
        binđDataCollectionView()
//        month_collectionView.reloadData()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.dataArray.accept(data)
    }
    
}

class MonthSelectCollectionViewCell : UICollectionViewCell {
    
    @IBOutlet weak var month_lbl: UILabel!

    public var data: Int? = 0{
        didSet{
            month_lbl.text = String(format: "%d", data!)
        }
    }
    
}

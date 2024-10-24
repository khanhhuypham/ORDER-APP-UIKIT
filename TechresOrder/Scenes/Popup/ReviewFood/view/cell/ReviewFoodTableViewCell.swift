//
//  ReviewFoodTableViewCell.swift
//  TechresOrder
//
//  Created by Kelvin on 22/01/2023.
//

import UIKit
import RxSwift
class ReviewFoodTableViewCell: UITableViewCell {

    @IBOutlet weak var lbl_food_name: UILabel!
    @IBOutlet weak var food_avatar: UIImageView!
    @IBOutlet weak var btn_very_good: UIButton!
    @IBOutlet weak var btn_good: UIButton!
    @IBOutlet weak var btn_normal: UIButton!
    @IBOutlet weak var btn_bad: UIButton!
    @IBOutlet weak var btn_very_bad: UIButton!
    @IBOutlet weak var textfield_comment: UITextField!
    
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var scrollView: UIScrollView!
    private(set) var disposeBag = DisposeBag()
    
    var btnArray:[UIButton] = []
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        btnArray = [btn_very_bad,btn_bad,btn_normal,btn_good,btn_very_good]

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(false, animated: false)
        // Configure the view for the selected state
    }
        
    var viewModel: ReviewFoodViewModel? = nil
    
    
    // MARK: - Variable -
    public var data: OrderItem? = nil {
      
        willSet(newValue){
            
        }
        
        didSet {
            guard let data = self.data, let viewModel = self.viewModel  else {return}
            
            lbl_food_name.text = data.name
            let link_image = Utils.getFullMediaLink(string: data.food_avatar)
            food_avatar.kf.setImage(with: URL(string: link_image), placeholder: UIImage(named: "image_defauft_medium"))
            textfield_comment.isHidden = data.review_score == -2 || data.review_score == -3  ? false : true
            textfield_comment.text = data.note
            
            textfield_comment.rx.controlEvent(.editingDidEnd)
            .throttle(.milliseconds(1000), scheduler: MainScheduler.instance)
            .withLatestFrom(textfield_comment.rx.text)
            .subscribe(onNext:{ query in
                var array = viewModel.dataArray.value
                if let position = array.firstIndex(where: {$0.id == data.id}){
                    array[position].note = query ?? ""
                }
                viewModel.dataArray.accept(array)
            }).disposed(by: disposeBag)
            
            
            switch data.review_score{
                case 3: // Rất ngon
                    Utils.changeBgBtn(btn:btn_very_good, btnArray: btnArray)
                case 2: // khá
                    Utils.changeBgBtn(btn: btn_good, btnArray: btnArray)
                case 1: // Tạm
                    Utils.changeBgBtn(btn: btn_normal, btnArray: btnArray)
                case -2: // Dở
                    Utils.changeBgBtn(btn: btn_bad, btnArray: btnArray)
                case -3: // Rất Dở
                    Utils.changeBgBtn(btn: btn_very_bad, btnArray: btnArray)
                default:
                    Utils.changeBgBtn(btn: UIButton(), btnArray: btnArray)
                    
            }
        }
    }
    
    @IBAction func actionChooseOption(_ sender: UIButton) {

        guard let viewModel = self.viewModel else {return}
        var array = viewModel.dataArray.value
        if let position = array.firstIndex(where: {$0.id == data?.id}){
            array[position].review_score = sender.tag
            array[position].note = ""
            textfield_comment.text = ""
        }
        viewModel.dataArray.accept(array)
    
    }
   
}

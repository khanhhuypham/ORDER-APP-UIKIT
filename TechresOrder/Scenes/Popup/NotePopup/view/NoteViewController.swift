//
//  NoteViewController.swift
//  TechresOrder
//
//  Created by Kelvin on 15/01/2023.
//

import UIKit
import RxSwift
import TagListView
import ObjectMapper

class NoteViewController: BaseViewController, TagListViewDelegate {
    var viewModel = NoteViewModel()

    @IBOutlet weak var tagListView: TagListView!
    @IBOutlet weak var height_of_tagListView: NSLayoutConstraint!
    
    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var textview_note: UITextView!
    @IBOutlet weak var root_view: UIView!
    @IBOutlet weak var lbl_number_character_note: UILabel!
    
    
    var delegate: NotFoodDelegate?
    var pos:Int = 0
    var food_note = ""
    var notes_str = ""
    var food_id = 0

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        _ = textview_note.rx.text.map { $0 ?? "" }.bind(to: viewModel.note)

        _ = viewModel.isValid.subscribe({ [weak self] isValid in
            dLog(isValid)
            guard let strongSelf = self, let isValid = isValid.element else { return }
            strongSelf.btnSubmit.isEnabled = isValid
            strongSelf.btnSubmit.backgroundColor = isValid ? ColorUtils.orange_brand_900() : .systemGray2

        })

        textview_note.rx.text.subscribe(onNext: {
                   self.lbl_number_character_note.text = String(format: "%d/%d", $0!.count, 50)
                   
                   if self.textview_note.text!.count > 50 {
                       self.textview_note.text = String(self.textview_note.text.prefix(50))
                   }
        }).disposed(by: rxbag)
        
  
        textview_note.withDoneButton()
        textview_note.text = food_note
        tagListView.delegate = self
       
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.order_detail_id.accept(self.food_id)

        permissionUtils.GPBH_1 ? notes() : notesByFood()
     
    }
    @IBAction func actionAddNote(_ sender: Any) {
        
        if textview_note.text!.count > 50 {
            textview_note.text = String(textview_note.text.prefix(50))
            
        }
        
        dismiss(animated: true,completion: {
            self.delegate?.callBackNoteFood(
                pos:self.pos,
                id:self.food_id,
                note:self.textview_note.text
            )
        })
    }
    @IBAction func actionCanCel(_ sender: Any) {
        dismiss(animated: true)
    }
    
    
    // MARK: TagListViewDelegate
    func tagPressed(_ title: String, tagView: TagView, sender: TagListView) {
        print("Tag pressed: \(title), \(sender)")

        if(notes_str.count>0){
            if(!notes_str.contains(title)){
                notes_str.append(contentsOf: String(format: ", %@", title))
            }
        }else{
            notes_str.append(contentsOf: title)
        }

        if textview_note.text.count > 50 {
            return
        } else {

            textview_note.text = notes_str
        }
        
    }
        
    func tagRemoveButtonPressed(_ title: String, tagView: TagView, sender: TagListView) {
        sender.removeTagView(tagView)
    }


}
extension NoteViewController{
    func notes(){
        viewModel.notes().subscribe(onNext: { (response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){
              
                if let notes  = Mapper<Note>().mapArray(JSONObject: response.data){
    
                    self.tagListView.addTags(notes.map{$0.content})
                    
                    self.height_of_tagListView.constant = self.tagListView.intrinsicContentSize.height

                }
            }else{
                dLog(response.message)
            }
        }).disposed(by: rxbag)
        
    }
    
    func notesByFood(){
        viewModel.notesByFood().subscribe(onNext: { (response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){
             
                if let notes  = Mapper<Note>().mapArray(JSONObject: response.data){
                    self.tagListView.addTags(notes.map{$0.note})
                    self.height_of_tagListView.constant = self.tagListView.intrinsicContentSize.height
                }
            }
        }).disposed(by: rxbag)

    }
}

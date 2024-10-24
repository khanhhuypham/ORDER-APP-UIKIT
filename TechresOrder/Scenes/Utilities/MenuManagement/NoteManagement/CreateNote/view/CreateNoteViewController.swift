//
//  CreateNoteViewController.swift
//  TechresOrder
//
//  Created by Kelvin on 24/01/2023.
//

import UIKit
import JonAlert
import RxSwift
class CreateNoteViewController: BaseViewController {
    var viewModel = CreateNoteViewModel()
    var delegate:TechresDelegate?
    @IBOutlet weak var lbl_header: UILabel!
    @IBOutlet weak var lbl_count_text: UILabel!
    @IBOutlet weak var root_view: UIView!

    @IBOutlet weak var textview_note: UITextView!
    @IBOutlet weak var btnCreate: UIButton!
    
    var note = Note()!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
    
        // Do any additional setup after loading the view.
        viewModel.bind(view: self)
        textview_note.withDoneButton()
        textview_note.becomeFirstResponder()
        viewModel.note.accept(note)
        firstSetup()
    }
    
    
    

    @IBAction func actionCreate(_ sender: Any) {
      
        self.createUpdateNote()
    }
    
    @IBAction func actionCancel(_ sender: Any) {
        dismiss(animated: true)
    }
    
  
}

//
//  ManagerCategoryFoodNoteViewController.swift
//  TechresOrder
//
//  Created by Kelvin on 23/01/2023.
//

import UIKit

class ManagerCategoryFoodNoteViewController: BaseViewController {
    var viewModel = ManagerCategoryFoodNoteViewModel()
    var router = ManagerCategoryFoodNoteRouter()

    
    @IBOutlet weak var btn_management_category: UIButton!
    
    @IBOutlet weak var btn_management_food: UIButton!
    
    @IBOutlet weak var btn_management_note: UIButton!
    
    @IBOutlet weak var btnBack: UIButton!
    
    @IBOutlet weak var view_management_category: UIView!
    @IBOutlet weak var view_management_food: UIView!
    @IBOutlet weak var view_management_note: UIView!
    
    @IBOutlet weak var lbl_header: UILabel!
    

    static var isCheckDataFood = false
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        viewModel.bind(view: self, router: router)
        actionManagementCategory()
        // action btn_management_category
        btn_management_category.rx.tap.asDriver()
                       .drive(onNext: { [weak self] in
                           self!.actionManagementCategory()
                       }).disposed(by: rxbag)
        
        btn_management_food.rx.tap.asDriver()
                       .drive(onNext: { [weak self] in
                           self!.actionManagementFood()
                        //day
                       }).disposed(by: rxbag)
        
        btn_management_note.rx.tap.asDriver()
                       .drive(onNext: { [weak self] in
                           self!.actionManagementNote()
                       }).disposed(by: rxbag)
        
        btnBack.rx.tap.asDriver()
                       .drive(onNext: { [weak self] in
                           self?.viewModel.makePopViewController()
                       }).disposed(by: rxbag)
    
        
    }
    override func viewWillAppear(_ animated: Bool) {
 
    }
    
    

    private func actionManagementCategory() {
        changeBtnBackground(btn: btn_management_category, underlineView: view_management_category)

        // add order proccessing when load view
        let categoryManagementViewController = CategoryManagementViewController(nibName: "CategoryManagementViewController", bundle: Bundle.main)
        addViewController(categoryManagementViewController)
     
        let FoodManagementViewController = FoodManagementViewController(nibName: "FoodManagementViewController", bundle: Bundle.main)
        FoodManagementViewController.remove()
        
        let noteManagementViewController = NoteManagementViewController(nibName: "NoteManagementViewController", bundle: Bundle.main)
        noteManagementViewController.remove()
        
    }
    
    private func actionManagementFood() {

        changeBtnBackground(btn: btn_management_food, underlineView: view_management_food)
        
        let FoodManagementViewController = FoodManagementViewController(nibName: "FoodManagementViewController", bundle: Bundle.main)
        addViewController(FoodManagementViewController)
        
        
        let categoryManagementViewController = CategoryManagementViewController(nibName: "CategoryManagementViewController", bundle: Bundle.main)
        categoryManagementViewController.remove()

        
        let noteManagementViewController = NoteManagementViewController(nibName: "NoteManagementViewController", bundle: Bundle.main)
        noteManagementViewController.remove()
        
    }
  
    private func actionManagementNote() {

        changeBtnBackground(btn: btn_management_note, underlineView: view_management_note)

        // add order proccessing when load view
        let categoryManagementViewController = CategoryManagementViewController(nibName: "CategoryManagementViewController", bundle: Bundle.main)
        categoryManagementViewController.remove()


        let FoodManagementViewController = FoodManagementViewController(nibName: "FoodManagementViewController", bundle: Bundle.main)
        FoodManagementViewController.remove()
        
        let noteManagementViewController = NoteManagementViewController(nibName: "NoteManagementViewController", bundle: Bundle.main)
        addViewController(noteManagementViewController)
        
    }
    
    
    private func changeBtnBackground(btn:UIButton,underlineView:UIView){
        btn_management_food.titleLabel?.textColor = ColorUtils.green_200()
        btn_management_category.titleLabel?.textColor = ColorUtils.green_200()
        btn_management_note.titleLabel?.textColor = ColorUtils.green_200()

        view_management_category.isHidden = true
        view_management_food.isHidden = true
        view_management_note.isHidden = true
        
        btn.titleLabel?.textColor = ColorUtils.green_600()
        underlineView.isHidden = false
    }

}

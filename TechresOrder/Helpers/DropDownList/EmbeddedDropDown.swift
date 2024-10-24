//
//  EmbeddedDropDown.swift
//  TECHRES-SUPPLIER
//
//  Created by pham khanh huy on 30/09/2023.
//  Copyright © 2023 OVERATE-VNTECH. All rights reserved.
//

import UIKit

@IBDesignable
open class embeddedDropDown: UIView {

    var stackView = UIStackView()
    var tableView = UIView()
    var lbl_no_data = UILabel()
    var table = UITableView()
    var textField = UITextField()
    var toggleBtn = UIButton()
    var horizontalStack = UIStackView()
    public var selectedId: Int?
  
    
    
    // Init
    override public init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        setupUI()
    }
    
    
    // MARK: IBInspectable
    @IBInspectable public var rowBackgroundColor: UIColor = .white
    @IBInspectable public var itemsColor: UIColor = .darkGray
    @IBInspectable public var selectedRowColor: UIColor = .systemGray6
    @IBInspectable public var hideOptionsWhenSelect = true
    @IBInspectable public var showTextAfterSelect = true
    @IBInspectable public var multiSelection = false
    @IBInspectable public var isSearchEnable: Bool = true {
        didSet {
            addGesture()
        }
    }

    @IBInspectable public var searchBarHeight: CGFloat = 45{
        didSet{
            horizontalStack.translatesAutoresizingMaskIntoConstraints = false
            horizontalStack.heightAnchor.constraint(equalToConstant: searchBarHeight).isActive = true
        }
    }
    
    
    @IBInspectable public var listHeight: CGFloat = 100{
        didSet{
            table.translatesAutoresizingMaskIntoConstraints = false
            table.heightAnchor.constraint(equalToConstant: listHeight).isActive = true
        }
    }
    
    

    @IBInspectable public var ImageOfBtnDropDown:UIImage?{
        didSet {
            toggleBtn.setImage(ImageOfBtnDropDown, for: .normal)
        }
    }

  

    


    fileprivate var dataArray:[(id:Int,name:String,isSelected:Int)] = []
    fileprivate var fullDataArray:[(id:Int,name:String,isSelected:Int)] = []
    fileprivate var imageArray = [String]()
    fileprivate var keyboardHeight: CGFloat = 0
    fileprivate var tableSwitcher: Bool = false

    public var optionArray:[(name:String,id:Int)] = [] {
        didSet {
            dataArray = optionArray.map{(id:$0.id,name:$0.name,isSelected:DEACTIVE)}
            fullDataArray = optionArray.map{(id:$0.id,name:$0.name,isSelected:DEACTIVE)}
            
            stickSelectedData()
        }
    }

    public var optionImageArray = [String]() {
        didSet {
            imageArray = optionImageArray
        }
    }
    
    public var selectedIds: [Int]?{
        didSet{
            dataArray = optionArray.map{(id:$0.id,name:$0.name,isSelected:DEACTIVE)}
            fullDataArray = optionArray.map{(id:$0.id,name:$0.name,isSelected:DEACTIVE)}
            stickSelectedData()
        }
    }
    
    
    private func stickSelectedData(){
        if multiSelection{
            if selectedIds != nil {
             
                for id in selectedIds ?? []{
                    
                    if let pos = dataArray.firstIndex(where: {$0.id == id}){
                        dataArray[pos].isSelected = ACTIVE
                    }
                    
                    if let pos = fullDataArray.firstIndex(where: {$0.id == id}){
                        fullDataArray[pos].isSelected = ACTIVE
                    }
                }
            }
            
        }else{
            if selectedId != nil{
                if let pos = dataArray.firstIndex(where: {$0.id == selectedId}){
                    dataArray[pos].isSelected = ACTIVE
                }
                
                if let pos = fullDataArray.firstIndex(where: {$0.id == selectedId}){
                    fullDataArray[pos].isSelected = ACTIVE
                }
            }
        }
        table.reloadData()
    }
    


    @IBInspectable public var checkMarkEnabled: Bool = true {
        didSet {
        }
    }

    @IBInspectable public var handleKeyboard: Bool = true {
        didSet {
        }
    }

    // MARK: Closures

    fileprivate var didSelectCompletion: (String, Int, Int) -> Void = { _, _, _ in }
    fileprivate var TableWillAppearCompletion: () -> Void = { }
    fileprivate var TableDidAppearCompletion: () -> Void = { }
    fileprivate var TableWillDisappearCompletion: () -> Void = { }
    fileprivate var TableDidDisappearCompletion: () -> Void = { }
    fileprivate var GetStackViewHeight: (CGFloat) -> Void = { _ in }

    func setupUI() {
        registerCell()
        toggleBtn.addTarget(self, action: #selector(pressed), for: .touchUpInside)
//        textField.paddingLeftCustom = 10
        textField.clearButtonMode = .whileEditing
        textField.addDoneButtonOnKeyboard()
        textField.font = UIFont.systemFont(ofSize: 14)
        textField.delegate = self

   
        horizontalStack.axis = .horizontal
        horizontalStack.distribution = .fill
        horizontalStack.alignment = .fill
        horizontalStack.frame.size = CGSize(width: self.frame.size.width, height: searchBarHeight)
        horizontalStack.addArrangedSubview(textField)
        horizontalStack.addArrangedSubview(toggleBtn)
        
        
        lbl_no_data.text = "Không có dữ liệu"
        lbl_no_data.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        lbl_no_data.textAlignment = .center
        tableView.addSubview(table)
        tableView.addSubview(lbl_no_data)
        
        
            
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.frame.origin = self.bounds.origin
        stackView.frame.size = self.frame.size
        stackView.addArrangedSubview(horizontalStack)
        stackView.addArrangedSubview(tableView)

        stackView.layoutSubviews()
        self.addSubview(stackView)
        tableView.isHidden = tableSwitcher ? false : true
        
        table.translatesAutoresizingMaskIntoConstraints = false
        lbl_no_data.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor,constant: 0),
            stackView.topAnchor.constraint(equalTo: self.topAnchor,constant: 0),
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor,constant: 0),
            stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor,constant: 0),
            toggleBtn.widthAnchor.constraint(equalToConstant: 50),
            
            table.leadingAnchor.constraint(equalTo: tableView.leadingAnchor,constant: 0),
            table.topAnchor.constraint(equalTo: tableView.topAnchor,constant: 0),
            table.trailingAnchor.constraint(equalTo: tableView.trailingAnchor,constant: 0),
            table.bottomAnchor.constraint(equalTo: tableView.bottomAnchor,constant: 0),
            
            lbl_no_data.leadingAnchor.constraint(equalTo: tableView.leadingAnchor,constant: 0),
            lbl_no_data.topAnchor.constraint(equalTo: tableView.topAnchor,constant: 0),
            lbl_no_data.trailingAnchor.constraint(equalTo: tableView.trailingAnchor,constant: 0),
            lbl_no_data.bottomAnchor.constraint(equalTo: tableView.bottomAnchor,constant: 0),
            
        ])
        
        
        super.layoutSubviews()
        
        let tapTextField = UITapGestureRecognizer(target: self, action: #selector(tapTextField(_:)))
        textField.addGestureRecognizer(tapTextField)
        textField.addTarget(self, action: #selector(UITextFieldDelegate.textFieldShouldEndEditing(_:)), for: .editingChanged)
        
        
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapOutSide(_:)))
        tapGesture.cancelsTouchesInView = false
        UIApplication.shared.windows.first?.addGestureRecognizer(tapGesture) // Attach to the window
        
        addGesture()

//        if isSearchEnable && handleKeyboard {
//            NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: nil) { notification in
//                if self.isFirstResponder {
//                    let userInfo: NSDictionary = notification.userInfo! as NSDictionary
//                    let keyboardFrame: NSValue = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
//                    let keyboardRectangle = keyboardFrame.cgRectValue
//                    self.keyboardHeight = keyboardRectangle.height
//
////                    if !self.isSelected {
//                    self.transform = CGAffineTransform(translationX: 0, y: -self.keyboardHeight)
//                    self.showList()
////                    }
//                }
//            }
//            NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: nil) { _ in
//                if self.isFirstResponder {
//                    self.keyboardHeight = 0
//                    self.transform = .identity
//                }
//            }
//        }
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    fileprivate func addGesture() {
//        let gesture = UITapGestureRecognizer(target: self, action: #selector(touchAction))
//        if isSearchEnable {
//            rightView?.addGestureRecognizer(gesture)
//        } else {
//            addGestureRecognizer(gesture)
//        }
//        let gesture2 = UITapGestureRecognizer(target: self, action: #selector(touchAction))
//        backgroundView.addGestureRecognizer(gesture2)
    }

    @objc func handleTapOutSide(_ gesture: UITapGestureRecognizer) {
        let tapLocation = gesture.location(in: self)

        if !self.bounds.contains(tapLocation){
            tableSwitcher = false
            tableView.isHidden = tableSwitcher ? false : true
            GetStackViewHeight(tableSwitcher ? listHeight + searchBarHeight : searchBarHeight)
        }

    }
    
    @objc private func pressed(sender: UIButton!) {
        tableSwitcher = !tableSwitcher
        tableView.isHidden = tableSwitcher ? false : true
        table.reloadData()
        stackView.layoutSubviews()
        GetStackViewHeight(tableSwitcher ? listHeight + searchBarHeight : searchBarHeight)
    }
  
    @objc func tapTextField(_ sender: UITapGestureRecognizer) {
        tableView.isHidden = false
        textField.becomeFirstResponder()
        tableSwitcher = true
        GetStackViewHeight(tableSwitcher ? listHeight + searchBarHeight : searchBarHeight)
    }

    @objc public func touchAction() {
//        if isSelected {self.resignFirstResponder()}
//        isSelected ? hideList() : showList()
    }



    // MARK: Actions Methods
    public func didSelect(completion: @escaping (_ selectedText: String, _ index: Int, _ id: Int) -> Void) {
        didSelectCompletion = completion
    }

    public func listWillAppear(completion: @escaping () -> Void) {
        TableWillAppearCompletion = completion
    }

    public func listDidAppear(completion: @escaping () -> Void) {
        TableDidAppearCompletion = completion
    }

    public func listWillDisappear(completion: @escaping () -> Void) {
        TableWillDisappearCompletion = completion
    }

    public func listDidDisappear(completion: @escaping () -> Void) {
        TableDidDisappearCompletion = completion
    }
    
    public func getViewHeight(completion: @escaping (_ listHeight:CGFloat) -> Void) {
        GetStackViewHeight = completion
    }
    
}

// MARK: registerCell
extension embeddedDropDown {
    private func registerCell(){
        table.register(itemTableViewCell.self, forCellReuseIdentifier: "itemTableViewCell")
        table.separatorStyle = .singleLine
        table.dataSource = self
        table.delegate = self
        table.separatorInset = .zero
    }
}


// MARK: UITextFieldDelegate
extension embeddedDropDown:UITextFieldDelegate {
    public func textFieldShouldClear(_ textField: UITextField) -> Bool {
        dataArray = fullDataArray
        table.reloadData()
        return true
    }
    
    
    
    public func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        let cloneFullDataArray = fullDataArray
        if textField.text! != ""{
            let filteredDataArray = cloneFullDataArray.filter({
                (value) -> Bool in
                let str1 = textField.text!.uppercased().applyingTransform(.stripDiacritics, reverse: false)!
                let str2 = value.name.uppercased().applyingTransform(.stripDiacritics, reverse: false)!
                return str2.contains(str1)
            })
            dataArray = filteredDataArray
     
            tableView.isHidden = false
        }else{
            dataArray = cloneFullDataArray
        }
        
        table.reloadData()
        return true
    }
    
}



// MARK: UITableViewDataSource, UITableDelegate
extension embeddedDropDown: UITableViewDataSource,UITableViewDelegate {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        lbl_no_data.isHidden = dataArray.count > 0 ? true : false
        return dataArray.count
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = table.dequeueReusableCell(withIdentifier: "itemTableViewCell", for: indexPath) as! itemTableViewCell
        cell.name = dataArray[indexPath.row].name
        cell.lbl_name.textColor = itemsColor
        cell.checkMarkImage.isHidden = dataArray[indexPath.row].isSelected == ACTIVE && checkMarkEnabled ? false : true
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let id = dataArray[indexPath.row].id
        
        if multiSelection{
            
            if let position = dataArray.firstIndex(where: {$0.id == id}){
                dataArray[position].isSelected = dataArray[position].isSelected == ACTIVE ? DEACTIVE : ACTIVE
            }
            
            //Update date fullDataArray
            if let position = fullDataArray.firstIndex(where: {$0.id == id}){
                fullDataArray[position].isSelected = fullDataArray[position].isSelected == ACTIVE ? DEACTIVE : ACTIVE
            }
        }else {
            dataArray = dataArray.map{(id:$0.id,name:$0.name,isSelected:DEACTIVE)}
            if let position = dataArray.firstIndex(where: {$0.id == id}){
                dataArray[position].isSelected = ACTIVE
            }
            
            //Update date fullDataArray
            fullDataArray = fullDataArray.map{(id:$0.id,name:$0.name,isSelected:DEACTIVE)}
            if let position = fullDataArray.firstIndex(where: {$0.id == id}){
                fullDataArray[position].isSelected = ACTIVE
            }
        }
    
        
        table.reloadData()


        
        if let position = fullDataArray.firstIndex(where: { $0.id == id }) {
            var data = fullDataArray[position]
            didSelectCompletion(data.name,position,data.id)
        }
    }

 
    
    
    class itemTableViewCell: UITableViewCell {
        let view = UIView()
        let checkMarkImage = UIImageView(frame: CGRect(origin: .zero, size: CGSize(width: 18, height: 18)))
        let lbl_name = UILabel()

        override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
               super.init(style: style, reuseIdentifier: reuseIdentifier)
                self.selectionStyle = .none
                checkMarkImage.translatesAutoresizingMaskIntoConstraints = false
                checkMarkImage.image = UIImage(named: "icon-check-green-200")
            
                lbl_name.translatesAutoresizingMaskIntoConstraints = false
                lbl_name.font = UIFont.systemFont(ofSize: 12,weight: .semibold)
                lbl_name.numberOfLines = 0
                lbl_name.textAlignment = .left
                lbl_name.lineBreakMode = .byWordWrapping
                
                view.translatesAutoresizingMaskIntoConstraints = false
                view.addSubview(checkMarkImage)
                view.addSubview(lbl_name)
                contentView.addSubview(view)

        
                NSLayoutConstraint.activate([
                    view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
                    view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0),
                    view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0),
                    view.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
                    
       
                    checkMarkImage.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
                    checkMarkImage.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        
                    
                    lbl_name.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
                    lbl_name.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -15),
                    lbl_name.trailingAnchor.constraint(equalTo: checkMarkImage.leadingAnchor, constant: 0),
                    lbl_name.topAnchor.constraint(equalTo: view.topAnchor, constant: 15),
                ])

                contentView.layoutIfNeeded()
           }

           required init?(coder aDecoder: NSCoder) {
               fatalError("init(coder:) has not been implemented")
           }
        
        var name:String?{
            didSet{
                lbl_name.text = name
            }
        }
        

    }
    
    
    
}





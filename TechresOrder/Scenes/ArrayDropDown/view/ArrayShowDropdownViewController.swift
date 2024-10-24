//
//  ArrayChooseEmployeeViewController.swift
//  Techres-Seemt
//
//  Created by Kelvin on 14/04/2023.
//  Copyright © 2023 OVERATE-VNTECH. All rights reserved.
//

import UIKit

class ArrayShowDropdownViewController<Element> : UITableViewController {
    
    typealias SelectionHandler = (Element) -> Void
    typealias LabelProvider = (Element) -> String
    
    private let values : [Element]
    private let labels : LabelProvider
    private let onSelect : SelectionHandler?
    var index:Int = 0
    
    var delegate : ArrayShowDropdownViewControllerDelegate?
    
    var listString = [String]()
    var list_icons = [String]()
    
    override func viewDidLoad() {
        let nib = UINib.init(nibName: "CustomActionTableViewCell", bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: "CustomActionTableViewCell")
    }
    
    init(_ values : [Element], labels : @escaping LabelProvider = String.init(describing:), onSelect : SelectionHandler? = nil) {
        self.values = values
        self.onSelect = onSelect
        self.labels = labels
        super.init(style: .plain)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listString.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomActionTableViewCell", for: indexPath) as! CustomActionTableViewCell
        
        cell.lbl_action_name.text = listString[indexPath.row]
//               cell.textLabel?.text = listString[indexPath.row]
//        cell.icon_action.image = UIImage(named: self.list_icons[0])
//        cell.icon_action.tintColor = ColorUtils.main_color()
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.dismiss(animated: true)
        delegate?.selectAt(pos: indexPath.row)
    }
    
}

//
//  DropDownViewController.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 01/10/2024.
//

import UIKit

class DropDownViewController<Element>: UITableViewController {
    private let values : [Element]
    var delegate : chooseItemDelegate?
    
    var list:[(id:Int,name:String,icon:String?)] = []

    
    override func viewDidLoad() {
        let nib = UINib.init(nibName: "DropDownTableViewCell", bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: "DropDownTableViewCell")
    }
    
    init(_ values:[Element]) {
        self.values = values
        super.init(style: .plain)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "DropDownTableViewCell", for: indexPath) as! DropDownTableViewCell
        let item = list[indexPath.row]
        cell.lbl_name.text = item.name
        if let icon = item.icon{
            //        cell.textLabel?.text = listString[indexPath.row]
        }
        
       
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.dismiss(animated: true,completion: {
            self.delegate?.selectItem(id: self.list[indexPath.row].id)
        })
      
    }
    

}

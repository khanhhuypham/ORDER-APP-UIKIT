//
//  mothyearpicker.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 07/12/2023.
//

import UIKit


public protocol mothyearpickerDelegate {
//    func dateTimePicker(_ picker: mothyearpicker, didSelectDate: Date)
}

@objc public class mothyearpicker:UIView {
    public var picker = MonthYearWheelPicker()
    public var stackView = UIStackView()
    public var completionHandler: ((Date)->Void)?
    public var dismissHandler: (() -> Void)?
    public var delegate: DateTimePickerDelegate?
    private var contentHeight: CGFloat = 250

    
    /// date locale (language displayed), default to American English
    public var locale = Locale(identifier: "en_US") {
        didSet {
            configureView()
        }
    }
    
    /// selected date when picker is displayed, default to current date
    public var selectedDate = Date() {
        didSet {
//            self.delegate?.dateTimePicker(self, didSelectDate: selectedDate)
        }
    }


    @objc open class func show(selected: Date? = nil, minimumDate: Date? = nil, maximumDate: Date? = nil) -> mothyearpicker {
        var dateTimePicker = mothyearpicker()
        dateTimePicker.configureView(selected: selected,minDate: minimumDate,maxDate: maximumDate)
        UIApplication.shared.keyWindow?.addSubview(dateTimePicker)
        
        return dateTimePicker
    }
    
    
    
    private func configureView(selected: Date? = nil, minDate: Date? = nil, maxDate: Date? = nil) {
        let screenSize = UIScreen.main.bounds.size
        

        self.frame = CGRect(x: 0,y: frame.height,width: screenSize.width,height: screenSize.height)
        
        
        
        //setup toolbar
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 45))
        doneToolbar.barStyle = .default

        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancel:UIBarButtonItem = UIBarButtonItem(title: "Huỷ", style: .plain, target: self, action: #selector(self.cancelButtonAction))
        let done:UIBarButtonItem = UIBarButtonItem(title: "Xong", style: .plain, target: self, action: #selector(self.doneButtonAction))

        let items = [cancel,flexSpace,done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        
        
        //setup datePicker
        picker.frame = CGRect(origin: CGPoint.zero, size: CGSize(width: screenSize.width, height: 200))
        picker.date = selected!
        if minDate != nil{
            picker.minimumDate = minDate ?? Date()
        }
        
        if maxDate != nil{
            picker.maximumDate = maxDate ?? Date()
        }
       
       
        picker.onDateSelected = {(month, year) in
            var dateComponents = DateComponents()
            dateComponents.year = year
            dateComponents.month = month
            // Create date from components
            let calendar = Calendar(identifier: .gregorian) // since the components above (like year 1980) are for Gregorian

            self.selectedDate = calendar.date(from: dateComponents)!
        }
        
        

        
        //setup stackView
        stackView = UIStackView(frame: CGRect(x: 0, y: frame.height, width: frame.width, height: contentHeight))
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.frame.origin = self.bounds.origin
        stackView.frame.size = self.frame.size
        stackView.addArrangedSubview(doneToolbar)
        stackView.addArrangedSubview(picker)
        stackView.layoutSubviews()
        
    
        //setup VisualEffect view
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.systemThinMaterial)
    
        let blurredEffectView = UIVisualEffectView(effect: blurEffect)
        self.addSubview(blurredEffectView)
        self.addSubview(stackView)
        
        
        

        blurredEffectView.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            blurredEffectView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0),
            blurredEffectView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
            blurredEffectView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0),
            blurredEffectView.heightAnchor.constraint(equalToConstant: contentHeight),
            stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0),
            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0)
        ])
        self.bringSubviewToFront(stackView)
        self.layoutIfNeeded()
        
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.4, options: .curveEaseIn, animations: {
            self.stackView.frame = CGRect(x: 0,
                                    y: self.frame.height - self.contentHeight,
                                    width: self.frame.width,
                                    height: self.contentHeight)
        }, completion: nil)
    
    }
    
  
    
    @objc private func cancelButtonAction(sender: UIBarButtonItem?=nil){
        UIView.animate(withDuration: 0.3, animations: {
            // animate to show contentView
            self.frame = CGRect(x: 0,y: self.frame.height,width: self.frame.width,height: self.frame.height)
        }) {[weak self] (completed) in
            guard let `self` = self else {
                return
            }
            self.removeFromSuperview()
        }
    }
   
     @objc private func doneButtonAction(sender: UIBarButtonItem?=nil){
         UIView.animate(withDuration: 0.3, animations: {
             // animate to show contentView
             self.frame = CGRect(x: 0,y: self.frame.height,width: self.frame.width,height: self.frame.height)
         }) {[weak self] (completed) in
             guard let `self` = self else {
                 return
             }
             self.completionHandler?(self.selectedDate)
             self.removeFromSuperview()
         }
     }

}




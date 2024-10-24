//
//  SambagYearPickerViewController.swift
//  Techres-Seemt
//
//  Created by macmini_techres_04 on 19/05/2023.
//  Copyright © 2023 OVERATE-VNTECH. All rights reserved.
//


import UIKit

public protocol SambagYearPickerViewControllerDelegate: AnyObject {
    
    func sambagYearPickerDidSet(_ viewController: SambagYearPickerViewController, result: SambagYearPickerResult)
    func sambagYearPickerDidCancel(_ viewController: SambagYearPickerViewController)
}

@objc protocol SambagYearPickerViewControllerInteraction: AnyObject {
    
    func didTapSet()
    func didTapCancel()
}

public class SambagYearPickerViewController: UIViewController {
    
    lazy var alphaTransition = AlphaTransitioning()
    
    var contentView: UIView!
    var titleLabel: UILabel!
    var strip1: UIView!
    var strip2: UIView!
    var strip3: UIView!
    
    var okayButton: UIButton!
    var cancelButton: UIButton!

    var yearWheel: WheelViewController!
    
    var result: SambagYearPickerResult {
        var result = SambagYearPickerResult()
        result.year = Int(yearWheel.items[yearWheel.selectedIndexPath.row])!
        return result
    }
    
    public weak var delegate: SambagYearPickerViewControllerDelegate?
    public var theme: SambagTheme = .light
    public var suggestor: SambagYearPickerResultSuggestor = SambagYearPickerResult.Suggestor()
    public var limit: SambagSelectionLimit?
    public var hasDayOfWeek: Bool = false
    
    public convenience init() {
        self.init(nibName: nil, bundle: nil)
    }
    
    override public init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        initSetup()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initSetup()
    }
    
    public override func loadView() {
        super.loadView()
        
        let attrib = theme.attribute
        
        view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        
        contentView = UIView()
        contentView.backgroundColor = attrib.contentViewBackgroundColor
        contentView.layer.cornerRadius = 3
        contentView.layer.masksToBounds = true
        
        titleLabel = UILabel()
        titleLabel.text = "CHỌN THỜI GIAN"
        titleLabel.textColor = .white
        titleLabel.font = UIFont (name: "Roboto", size: 20)
        titleLabel.textAlignment = NSTextAlignment.center
        titleLabel.backgroundColor = UIColor(hex: "0071BB")
    
        
        okayButton = UIButton()
        okayButton.setTitleColor(attrib.buttonTextColor, for: .normal)
        okayButton.setTitle("CHỌN", for: .normal)
        okayButton.addTarget(self, action: #selector(self.didTapSet), for: .touchUpInside)
        okayButton.titleLabel?.font = attrib.buttonFont
        okayButton.setTitleColor(UIColor(hex: "0071BB"), for: .normal)
        okayButton.backgroundColor = ColorUtils.blueTransparent()
        okayButton.titleLabel?.font =  UIFont(name: "Roboto", size: 20)
  
        
        cancelButton = UIButton()
        cancelButton.setTitleColor(attrib.buttonTextColor, for: .normal)
        cancelButton.setTitle("HUỶ", for: .normal)
        cancelButton.addTarget(self, action: #selector(self.didTapCancel), for: .touchUpInside)
        cancelButton.titleLabel?.font = attrib.buttonFont
        cancelButton.setTitleColor(UIColor(hex: "F7002E"), for: .normal)
        cancelButton.backgroundColor = UIColor(hex: "F1F2F5")
        cancelButton.titleLabel?.font =  UIFont(name: "Roboto", size: 20)
        
        
        strip1 = UIView()
        strip1.backgroundColor = attrib.stripColor
        
        strip2 = UIView()
        strip2.backgroundColor = UIColor.gray.withAlphaComponent(0.2)
        
        strip3 = UIView()
        strip3.backgroundColor = strip2.backgroundColor
        
        let now = Date()
        let calendar = Calendar.current
        let year = calendar.component(.year, from: now)
        
        var items = [String]()
        let offset: Int = 101
        for i in 1..<offset {
            items.append("\(year - (offset - i))")
        }
        for i in 0..<offset {
            items.append("\(year + i)")
        }
        
        yearWheel = WheelViewController()
        yearWheel.delegate = self
        yearWheel.items = items
        yearWheel.gradientColor = attrib.contentViewBackgroundColor
        yearWheel.stripColor = attrib.stripColor
        yearWheel.cellTextFont = attrib.wheelFont
        yearWheel.cellTextColor = attrib.wheelTextColor
        yearWheel.selectedIndexPath.row = offset - 1

        guard
            let selectionLimit = limit,
            let minDate = selectionLimit.minDate,
            let maxDate = selectionLimit.maxDate,
            selectionLimit.isValid else {
            return
        }
        
        let selectedDate = selectionLimit.selectedDate
        let minYear = calendar.component(.year, from: minDate)
        let maxYear = calendar.component(.year, from: maxDate)
        let selectedYear = calendar.component(.year, from: selectedDate)
        
        let years: [Int] = (minYear...maxYear).map { $0 }
        yearWheel.items = years.map { "\($0)" }
        if let index = years.firstIndex(of: selectedYear) {
            yearWheel.selectedIndexPath.row = index
        }
    }
    
    public override func viewDidLayoutSubviews() {
        var rect = CGRect.zero
        
        let contentViewHorizontalMargin: CGFloat = 20
        let contentViewWidth: CGFloat = min(368, view.frame.width - contentViewHorizontalMargin * 2)
        
        rect.origin.x = 0
        rect.size.width = contentViewWidth
        rect.origin.y = 0
        rect.size.height = 50
        titleLabel.frame = rect 
        
        rect.origin.x = 0
        rect.origin.y = rect.maxY + rect.origin.y
        rect.size.width = contentViewWidth
        rect.size.height = 2
        strip1.frame = rect
        
        let wheelWidth: CGFloat = 72
      
        rect.origin.y = rect.maxY + 20
        rect.size.width = wheelWidth
        rect.size.height = 210
        rect.origin.x = (contentViewWidth - 244) / 2
        
dLog(contentViewWidth)
dLog(wheelWidth)
        rect.origin.x = view.frame.size.width  / 3
        dLog( rect.origin.x)
        rect.size.width = wheelWidth
        yearWheel.itemHeight = 70
        yearWheel.view.frame = rect
        
        rect.origin.y = rect.maxY + 20
        rect.origin.x = 0
        rect.size.width = strip1.frame.width
        rect.size.height = 1
        strip2.frame = rect
        
        rect.origin.y = rect.maxY
        rect.size.width = (contentViewWidth / 2) - 1
        rect.size.height = 48
        cancelButton.frame = rect
        
        rect.origin.x = rect.maxX
        rect.size.width = 1
        strip3.frame = rect
        
        rect.origin.x = rect.maxX
        rect.size.width = cancelButton.frame.width
        okayButton.frame = rect
        
        rect.size.height = rect.maxY
        rect.size.width = contentViewWidth
        rect.origin.x = (view.frame.width - rect.width) / 2
        rect.origin.y = (view.frame.height - rect.height) / 2
        contentView.frame = rect
        contentView.bounds.size = rect.size
        
        if view.frame.height < rect.height + 10 {
            let scale = view.frame.height / (rect.height + 10)
            contentView.transform = CGAffineTransform(scaleX: scale, y: scale)
            
        } else {
            contentView.transform = CGAffineTransform.identity
        }
        
        if(contentView.superview == nil) {
            view.addSubview(contentView)
            contentView.addSubview(titleLabel)
            contentView.addSubview(strip1)
            contentView.addSubview(strip2)
            contentView.addSubview(strip3)
            contentView.addSubview(okayButton)
            contentView.addSubview(cancelButton)
            contentView.addSubview(yearWheel.view)
            
            addChild(yearWheel)
            yearWheel.didMove(toParent: self)
        }
    }
    
    func initSetup() {
        transitioningDelegate = alphaTransition
        modalPresentationStyle = .custom
    }
}

extension SambagYearPickerViewController: SambagYearPickerViewControllerInteraction {
    
    func didTapSet() {
        delegate?.sambagYearPickerDidSet(self, result: result)
    }
    
    func didTapCancel() {
        delegate?.sambagYearPickerDidCancel(self)
    }
}

extension SambagYearPickerViewController: WheelViewControllerDelegate {
    
    func wheelViewController(_ wheel: WheelViewController, didSelectItemAtRow row: Int) {
        let suggested = suggestor.suggestedResult(from: result)
        
        guard suggested != result else {
            return
        }
        
        if suggested.year != result.year {
            yearWheel.selectedIndexPath.row = suggested.year - 1
        }
    }
}

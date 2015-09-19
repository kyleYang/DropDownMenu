//
//  KYDownMenu.swift
//  DropDownMenu
//
//  Created by 杨志赟 on 15/9/19.
//  Copyright © 2015年 xiaoluuu. All rights reserved.
//

import UIKit

// MARK: KYDropdownMenu
public class KYDropdownMenu: UIView {
    
    private var titleString : String?
    private var titleItems : [String]?
    
    private var configuration = KYConfiguration()
    private var isShow : Bool!
    //MARK: subviews
    private var menuButton : UIButton!
    private var titleLabel : UILabel!
    private var arrowImageView : UIImageView!
    
    //MARK: LayoutConstraint
    private var arrowTitlePaddConstraint : NSLayoutConstraint!
    
    public init(title:String?,items:[String]) {
        
        var tempTitle : String!
        if title == nil {
            tempTitle = items[0]
        }else{
            tempTitle = title
            self.configuration.changeTitleText = false
        }
       
        let titleSize = (tempTitle as NSString).sizeWithAttributes([NSFontAttributeName:self.configuration.titleFont])
        
        let frame = CGRectMake(0, 0, titleSize.width + (self.configuration.arrowPadding + self.configuration.arrowImage!.size.width)*2, self.configuration.dropDownMenuHeight)
        
        super.init(frame:frame)
        
        self.isShow = false
        self.titleItems = items
        self.titleString = title
        
        self.menuButton = UIButton(frame: frame)
        self.menuButton.backgroundColor = UIColor.clearColor()
        self.menuButton.addTarget(self, action: "menuButtonTap:", forControlEvents: .TouchUpInside)
        addSubview(self.menuButton)
        
        self.titleLabel = UILabel(frame: CGRectZero)
        self.titleLabel.font = self.configuration.titleFont
        self.titleLabel.textColor = self.configuration.titleColor
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.menuButton.addSubview(self.titleLabel)
        
        self.arrowImageView = UIImageView(frame: CGRectZero)
        self.arrowImageView.translatesAutoresizingMaskIntoConstraints = false
        self.arrowImageView.image = self.configuration.arrowImage
        self.menuButton.addSubview(self.arrowImageView)
        
        self.menuButton.addConstraint(NSLayoutConstraint(item: self.titleLabel, attribute: .CenterX, relatedBy: .Equal, toItem: self.menuButton, attribute: .CenterX, multiplier: 1.0, constant: 0))
        self.menuButton.addConstraint(NSLayoutConstraint(item: self.titleLabel, attribute: .CenterY, relatedBy: .Equal, toItem: self.menuButton, attribute: .CenterY, multiplier: 1.0, constant: 0))
        
        self.arrowTitlePaddConstraint = NSLayoutConstraint(item: self.arrowImageView, attribute: .Leading, relatedBy: .Equal, toItem: self.titleLabel, attribute: .Trailing, multiplier: 1.0, constant: self.configuration.arrowPadding)
        self.menuButton.addConstraint(self.arrowTitlePaddConstraint)
        
    
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func menuButtonTap(sender : UIButton){
        
    }
    
}

// MARK: BTConfiguration

public let defaultFontName = "HiraginoSans-W3"

class KYConfiguration {
    
    
    var titleFont : UIFont!
    var titleColor : UIColor!
    var cellTitleFont : UIFont!
    var changeTitleText : Bool!
    var dropDownMenuHeight : CGFloat!
    var arrowPadding : CGFloat!
    var arrowImage : UIImage?
    var arrowWidth : CGFloat! = 20
    
    
    init(){
        
        defaultValue()
    }
    
    func defaultValue(){
        
        titleFont = UIFont(name: defaultFontName, size: 15)
        cellTitleFont = UIFont(name: defaultFontName, size: 13)
        titleColor = UIColor.whiteColor()
        changeTitleText = true
        arrowPadding = 15
        dropDownMenuHeight = 44
        
    }
    
    
}

// MARK: Table View
class KYTableView: UITableView, UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    
}

// MARK: Table view cell
class KYTableViewCell: UITableViewCell {
    
    var checkmarkIcon: UIImageView!
    var cellContentFrame: CGRect!
    var configuration: KYConfiguration!
    
    init(style: UITableViewCellStyle, reuseIdentifier: String?, configuration: KYConfiguration) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        self.bounds = cellContentFrame
        self.contentView.frame = self.bounds
    }
}

// Content view of table view cell
class KYTableCellContentView: UIView {
    var separatorColor: UIColor = UIColor.blackColor()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.initialize()
    }
    
    func initialize() {
        self.backgroundColor = UIColor.clearColor()
    }
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        let context = UIGraphicsGetCurrentContext()
        
        // Set separator color of dropdown menu based on barStyle
        CGContextSetStrokeColorWithColor(context, self.separatorColor.CGColor)
        CGContextSetLineWidth(context, 1)
        CGContextMoveToPoint(context, 0, self.bounds.size.height)
        CGContextAddLineToPoint(context, self.bounds.size.width, self.bounds.size.height)
        CGContextStrokePath(context)
    }
}

extension UIViewController {
    // Get ViewController in top present level
    var topPresentedViewController: UIViewController? {
        var target: UIViewController? = self
        while (target?.presentedViewController != nil) {
            target = target?.presentedViewController
        }
        return target
    }
    
    // Get top VisibleViewController from ViewController stack in same present level.
    // It should be visibleViewController if self is a UINavigationController instance
    // It should be selectedViewController if self is a UITabBarController instance
    var topVisibleViewController: UIViewController? {
        if let navigation = self as? UINavigationController {
            if let visibleViewController = navigation.visibleViewController {
                return visibleViewController.topVisibleViewController
            }
        }
        if let tab = self as? UITabBarController {
            if let selectedViewController = tab.selectedViewController {
                return selectedViewController.topVisibleViewController
            }
        }
        return self
    }
    
    // Combine both topPresentedViewController and topVisibleViewController methods, to get top visible viewcontroller in top present level
    var topMostViewController: UIViewController? {
        return self.topPresentedViewController?.topVisibleViewController
    }
}


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
    
    private var _titleString : String?
    private var titleString : String?{
        get{
            return _titleString
        }
        set(newValue){
            
            _titleString = newValue
            
            let titleSize = _titleString!.sizeWithAttributes([NSFontAttributeName:self.configuration.titleFont])
            let frame = CGRectMake(0, 0, titleSize.width + (self.configuration.arrowPadding + self.configuration.arrowImage!.size.width)*2, self.configuration.dropDownMenuHeight)
            self.width = frame.size.width
            self.titleLabel.text = _titleString
        }
    }
    private var _width : CGFloat!
    private var width : CGFloat!{
        get{
            return _width
        }
        set(newValue){
            _width = newValue;
            let center = self.center
            var frame = self.frame;
            frame.size.width = _width
            self.frame = frame
            self.center = center
        }
    }
    private var titleItems : [String]?
    private var isShown : Bool = false
    private var hasSetupViews : Bool = false
    
    public var backOffset : CGFloat = 64
    
    private var configuration : KYConfiguration!
    private var isShow : Bool!
    //MARK: subviews
    private var menuButton : UIButton!
    private var titleLabel : UILabel!
    private var arrowImageView : UIImageView!
    private var menuWrapper: UIView!
    private var backgroundView : UIView!
    private var tableView: KYTableView!
    private var topSeparator: UIView!
  
    
    //MARK: LayoutConstraint
    private var arrowTitlePaddConstraint : NSLayoutConstraint!
    
    
    public convenience init(title:String?,items:[String]){
        
        self.init(title: title,items: items, config: KYConfiguration())
    }
    
    
    public init(title:String?,items:[String],config:KYConfiguration!) {
        
        self.configuration = config
        
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
        _titleString = tempTitle
        
        self.menuButton = UIButton(frame: CGRectZero)
        self.menuButton.translatesAutoresizingMaskIntoConstraints = false
        self.menuButton.backgroundColor = UIColor.clearColor()
        self.menuButton.addTarget(self, action: "menuButtonTap:", forControlEvents: .TouchUpInside)
        addConstraint(NSLayoutConstraint(item: self.menuButton, attribute: .Width, relatedBy: .Equal, toItem: self, attribute: .Width, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: self.menuButton, attribute: .Height, relatedBy: .Equal, toItem: self, attribute: .Height, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: self.menuButton, attribute: .CenterX, relatedBy: .Equal, toItem: self, attribute: .CenterX, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: self.menuButton, attribute: .CenterY, relatedBy: .Equal, toItem: self, attribute: .CenterY, multiplier: 1.0, constant: 0))
        addSubview(self.menuButton)
        
        self.titleLabel = UILabel(frame: CGRectZero)
        self.titleLabel.font = self.configuration.titleFont
        self.titleLabel.textColor = self.configuration.titleColor
        self.titleLabel.text = tempTitle
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
        self.menuButton.addConstraint(NSLayoutConstraint(item: self.arrowImageView, attribute: .CenterY, relatedBy: .Equal, toItem: self.titleLabel, attribute: .CenterY, multiplier: 1.0, constant: 0))
        
    
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
   private func setUpViews(){
        
        let window = UIApplication.sharedApplication().keyWindow!
        window.makeKeyAndVisible()
        window.backgroundColor = UIColor.redColor()
        let menuWrapperBounds = window.bounds
        // Set up DropdownMenu
        self.menuWrapper = UIView(frame: CGRectMake(menuWrapperBounds.origin.x, 0, menuWrapperBounds.width, menuWrapperBounds.height))
        self.menuWrapper.clipsToBounds = true
        self.menuWrapper.backgroundColor = UIColor.redColor()
        self.menuWrapper.autoresizingMask = UIViewAutoresizing.FlexibleWidth.union(UIViewAutoresizing.FlexibleHeight)
        
        // Init background view (under table view)
        self.backgroundView = UIView(frame: menuWrapperBounds)
        self.backgroundView.backgroundColor = self.configuration.maskBackgroundColor
        self.backgroundView.autoresizingMask = UIViewAutoresizing.FlexibleWidth.union(UIViewAutoresizing.FlexibleHeight)
        
        // Init table view
        self.tableView = KYTableView(frame: CGRectMake(menuWrapperBounds.origin.x, menuWrapperBounds.origin.y + 0.5, menuWrapperBounds.width, menuWrapperBounds.height + 300), items: self.titleItems!, configuration: self.configuration)
        self.tableView.selectRowAtIndexPathHandler = { (indexPath: Int) -> () in
//            self.didSelectItemAtIndexHandler!(indexPath: indexPath)
            self.titleString = self.titleItems![indexPath]
            self.hideMenu()
            self.isShown = false
            
        }

    
        // Table view header
        let headerView = UIView(frame: CGRectMake(0, 0, self.frame.width, 300))
        headerView.backgroundColor = self.configuration.cellBackgroundColor
        self.tableView.tableHeaderView = headerView

    
        // Add background view & table view to container view
        self.menuWrapper.addSubview(self.backgroundView)
        self.menuWrapper.addSubview(self.tableView)
        
        // Add Line on top
        self.topSeparator = UIView(frame: CGRectMake(0, 0, menuWrapperBounds.size.width, 0.5))
        self.topSeparator.autoresizingMask = UIViewAutoresizing.FlexibleWidth
        self.menuWrapper.addSubview(self.topSeparator)
        
        // Add Menu View to container view
        window.addSubview(self.menuWrapper)
        window.bringSubviewToFront(self.menuWrapper)
        
        // By default, hide menu view
        self.menuWrapper.hidden = false

    }
    
    
    func showMenu() {
        
        self.menuWrapper.frame.origin.y = self.frame.origin.y + self.frame.size.height
        self.topSeparator.backgroundColor = self.configuration.cellSeparatorColor
        
        // Rotate arrow
        self.rotateArrow()
        
        // Visible menu view
        self.menuWrapper.hidden = false
        
        // Change background alpha
        self.backgroundView.alpha = 0
        
        // Animation
        self.tableView.frame.origin.y = -CGFloat(self.titleItems!.count) * self.configuration.cellHeight - 300
        
        // Reload data to dismiss highlight color of selected cell
        self.tableView.reloadData()
        
        UIView.animateWithDuration(
            self.configuration.animationDuration * 1.5,
            delay: 0,
            usingSpringWithDamping: 0.7,
            initialSpringVelocity: 0.5,
            options: [],
            animations: {
                self.tableView.frame.origin.y = CGFloat(-300)
                self.backgroundView.alpha = self.configuration.maskBackgroundOpacity
            }, completion: nil
        )
    }
    
    func hideMenu() {
        // Rotate arrow
        self.rotateArrow()
        
        // Change background alpha
        self.backgroundView.alpha = self.configuration.maskBackgroundOpacity
        
        UIView.animateWithDuration(
            self.configuration.animationDuration * 1.5,
            delay: 0,
            usingSpringWithDamping: 0.7,
            initialSpringVelocity: 0.5,
            options: [],
            animations: {
                self.tableView.frame.origin.y = CGFloat(-200)
            }, completion: nil
        )
        
        // Animation
        UIView.animateWithDuration(self.configuration.animationDuration, delay: 0, options: UIViewAnimationOptions.TransitionNone, animations: {
            self.tableView.frame.origin.y = -CGFloat(self.titleItems!.count) * self.configuration.cellHeight - 300
            self.backgroundView.alpha = 0
            }, completion: { _ in
                self.menuWrapper.hidden = true
        })
    }
    
    func rotateArrow() {
        UIView.animateWithDuration(self.configuration.animationDuration, animations: {[weak self] () -> () in
            if let selfie = self {
                selfie.arrowImageView.transform = CGAffineTransformRotate(selfie.arrowImageView.transform, 180 * CGFloat(M_PI/180))
            }
            })
    }
    
    func setMenuTitle(title: String) {
        self.titleLabel.text = title
    }
    
    func menuButtonTap(sender: UIButton) {
        self.isShown = !self.isShown
        if self.isShown == true {
            
            if !self.hasSetupViews {
                self.setUpViews()
                self.hasSetupViews = true
            }
            
            self.showMenu()
        } else {
            self.hideMenu()
        }
    }


    
}

// MARK: BTConfiguration

public let defaultFontName = "HiraginoSans-W3"

public class KYConfiguration {
    
    
    var titleFont : UIFont!
    var titleColor : UIColor!
    var cellTitleFont : UIFont!
    var changeTitleText : Bool!
    var dropDownMenuHeight : CGFloat!
    var arrowPadding : CGFloat!
    var arrowImage : UIImage? = UIImage(named: "arrow_down_icon")
    var arrowWidth : CGFloat! = 20
    var maskBackgroundColor : UIColor!
    var cellHeight : CGFloat!
    var cellBackgroundColor : UIColor = UIColor.whiteColor()
    var cellSelectionColor : UIColor = UIColor.lightGrayColor()
    var cellTextLabelColor : UIColor = UIColor.darkGrayColor()
    var cellTextLabelFont = UIFont(name: defaultFontName, size: 15)
    var checkMarkImage = UIImage(named:"ss")
    var cellSeparatorColor : UIColor? = UIColor.darkGrayColor()
    var animationDuration : NSTimeInterval = 0.5
    var maskBackgroundOpacity : CGFloat = 0.3
    
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
        maskBackgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7)
        cellHeight = 30.0
        
    }
    
    
}

// MARK: Table View
class KYTableView: UITableView, UITableViewDelegate, UITableViewDataSource {
    
    // Public properties
    var configuration: KYConfiguration!
    var selectRowAtIndexPathHandler: ((indexPath: Int) -> ())?
    
    // Private properties
    private var items: [String]!
    private var selectedIndexPath: Int!
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(frame: CGRect, items: [String], configuration: KYConfiguration) {
        super.init(frame: frame, style: UITableViewStyle.Plain)
        
        self.items = items
        self.selectedIndexPath = 0
        self.configuration = configuration
        
        // Setup table view
        self.delegate = self
        self.dataSource = self
        self.backgroundColor = UIColor.clearColor()
        self.separatorStyle = UITableViewCellSeparatorStyle.None
        self.autoresizingMask = UIViewAutoresizing.FlexibleWidth
        self.tableFooterView = UIView(frame: CGRectZero)
    }


    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return self.configuration.cellHeight
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = KYTableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "Cell", configuration: self.configuration)
        cell.textLabel?.text = self.items[indexPath.row]
        cell.checkmarkIcon.hidden = (indexPath.row == selectedIndexPath) ? false : true
        
        return cell
    }
    
    // Table view delegate
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        selectedIndexPath = indexPath.row
        self.selectRowAtIndexPathHandler!(indexPath: indexPath.row)
        self.reloadData()
        let cell = tableView.cellForRowAtIndexPath(indexPath) as? KYTableViewCell
        cell?.contentView.backgroundColor = self.configuration.cellSelectionColor
    }
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath) as? KYTableViewCell
        cell?.checkmarkIcon.hidden = true
        cell?.contentView.backgroundColor = self.configuration.cellBackgroundColor
    }

    
    
}

// MARK: Table view cell
class KYTableViewCell: UITableViewCell {
    
    var checkmarkIcon: UIImageView!
    var cellContentFrame: CGRect!
    var configuration: KYConfiguration!
    
    init(style: UITableViewCellStyle, reuseIdentifier: String?, configuration: KYConfiguration) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.configuration = configuration
        
        // Setup cell
        cellContentFrame = CGRectMake(0, 0, (UIApplication.sharedApplication().keyWindow?.frame.width)!, self.configuration.cellHeight)
        self.contentView.backgroundColor = self.configuration.cellBackgroundColor
        self.selectionStyle = UITableViewCellSelectionStyle.None
        self.textLabel!.textAlignment = NSTextAlignment.Left
        self.textLabel!.textColor = self.configuration.cellTextLabelColor
        self.textLabel!.font = self.configuration.cellTextLabelFont
        self.textLabel!.frame = CGRectMake(20, 0, cellContentFrame.width, cellContentFrame.height)
        
        
        // Checkmark icon
        self.checkmarkIcon = UIImageView(frame: CGRectMake(cellContentFrame.width - 50, (cellContentFrame.height - 30)/2, 30, 30))
        self.checkmarkIcon.hidden = true
        self.checkmarkIcon.image = self.configuration.checkMarkImage
        self.checkmarkIcon.contentMode = UIViewContentMode.ScaleAspectFill
        self.contentView.addSubview(self.checkmarkIcon)
        
        // Separator for cell
        let separator = KYTableCellContentView(frame: cellContentFrame)
        if let cellSeparatorColor = self.configuration.cellSeparatorColor {
            separator.separatorColor = cellSeparatorColor
        }
        self.contentView.addSubview(separator)
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


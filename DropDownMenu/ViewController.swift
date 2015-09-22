//
//  ViewController.swift
//  DropDownMenu
//
//  Created by 杨志赟 on 15/9/19.
//  Copyright © 2015年 xiaoluuu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
//        view.backgroundColor = UIColor.clearColor()
        
        let items = ["Most Popular", "Latest", "Trending", "Nearest", "Top Picks"]
        
        let menuView = KYDropdownMenu(title: items.first!, items: items)
        menuView.backgroundColor = UIColor.redColor()
        
        menuView.center = CGPointMake(CGRectGetWidth(self.view.bounds)/2, 20+22.0)
        
        view.addSubview(menuView)

        
        
    }
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    

}


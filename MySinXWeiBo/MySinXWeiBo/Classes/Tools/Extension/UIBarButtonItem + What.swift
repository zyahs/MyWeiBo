//
//  UIBarButtonItem + What.swift
//  MySinXWeiBo
//
//  Created by 飞奔的羊 on 16/5/11.
//  Copyright © 2016年 itcast. All rights reserved.
//

import UIKit


	extension UIBarButtonItem {
//使用便利构造函数创建 UIBarButtonItem 对象
		convenience init(title: String, fontSize: CGFloat, target: AnyObject?, action: Selector) {
		
		self.init()
			
			let button = UIButton()
			button.addTarget(target, action: action, forControlEvents: .TouchUpInside)
			button.setTitle(title, forState: .Normal)
			
			//设置文字颜色
			button.setTitleColor(UIColor.darkGrayColor(), forState: .Normal)
			button.titleLabel?.font = UIFont.systemFontOfSize(fontSize)
			button.sizeToFit()
			customView = button
		
		
		
		
		}


}

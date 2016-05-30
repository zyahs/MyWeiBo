//
//  UILabel + extension.swift
//  MySinXWeiBo
//
//  Created by 飞奔的羊 on 16/5/13.
//  Copyright © 2016年 itcast. All rights reserved.
//

import UIKit

extension UILabel {

	convenience init(textColor: UIColor, fontSize: CGFloat) {
	self.init()
		self.textColor = textColor
		self.font = UIFont.systemFontOfSize(fontSize)
	
	
	
	}


}
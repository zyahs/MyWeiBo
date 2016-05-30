//
//  UIView+Extension.swift
//  MySinXWeiBo
//
//  Created by 飞奔的羊 on 16/5/19.
//  Copyright © 2016年 itcast. All rights reserved.
//

import UIKit
extension UIView {
	//获取和设置 x 坐标
	var x: CGFloat {
		get {
			return frame.origin.x
		}
		set {
			frame.origin.x = newValue
		}
	}
	//获取和设置  y 坐标
	var y: CGFloat {
		get {
			return frame.origin.y
		}
		set {
			frame.origin.y = newValue
		}
	}
	//获取和设置 size
	var size: CGSize {
		get {
			return frame.size
		}
		set {
			frame.size = newValue
		}
	}
	//获取和设置  width
	var width: CGFloat {
		get {
			return frame.size.width
		}
		set {
			frame.size.width = newValue
		}
	}
	//获取和设置  height 坐标
	var height: CGFloat {
		get {
			return frame.size.height
		}
		set {
			frame.size.height = newValue
		}
	}
	//Cenx
	var centerX: CGFloat {
		get {
			return center.x
		}
		set {
			center.x = newValue
		}
	}
	//Ceny
	var centerY: CGFloat {
		get {
			return center.y
		}
		set {
			center.y = newValue
		}
	}
	
	
}


//
//  ZYStatusPictureInfo.swift
//  MySinXWeiBo
//
//  Created by 飞奔的羊 on 16/5/16.
//  Copyright © 2016年 itcast. All rights reserved.
//

import UIKit
///配图模型
class ZYStatusPictureInfo: NSObject {
///图片地址
	var thumbnail_pic: String?
	init(dic: [String: AnyObject]) {
	super.init()
		setValuesForKeysWithDictionary(dic)
	
	}
	
	//防止键值不匹配
	override func setValue(value: AnyObject?, forUndefinedKey key: String) {
		
	}
	
}

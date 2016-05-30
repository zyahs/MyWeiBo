//
//  ZYEmoticon.swift
//  MySinXWeiBo
//
//  Created by 飞奔的羊 on 16/5/21.
//  Copyright © 2016年 itcast. All rights reserved.
//

import UIKit
///表情模型
class ZYEmoticon: NSObject {
///表情描述
	var chs: String?
	///图片名称
	var png : String?
	///表情类型 0 - 图片, 1 - emoji
	var type: String?
	
	///emoji 表情16进制字符串
	var code: String?
	///图片路径拼接
	var path: String?
	//kvc 构造函数
	init(dic: [String: AnyObject]) {
		super.init()
		setValuesForKeysWithDictionary(dic)
	}
	//防止崩溃
	override func setValue(value: AnyObject?, forUndefinedKey key: String) {
		
	}
	
}

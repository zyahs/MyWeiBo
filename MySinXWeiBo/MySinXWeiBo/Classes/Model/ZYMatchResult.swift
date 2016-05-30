//
//  ZYMatchResult.swift
//  MySinXWeiBo
//
//  Created by 飞奔的羊 on 16/5/23.
//  Copyright © 2016年 itcast. All rights reserved.
//

import UIKit
///匹配结果模型
class ZYMatchResult: NSObject {
///表情字符串
	var string: String
	///匹配的范围
	var range: NSRange
	///提供构造函数
	init(string: String, range: NSRange) {
		self.string = string
		self.range = range
		super.init()
	}
}

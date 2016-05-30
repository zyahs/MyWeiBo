//
//  ZYUser.swift
//  MySinXWeiBo
//
//  Created by 飞奔的羊 on 16/5/13.
//  Copyright © 2016年 itcast. All rights reserved.
//

import UIKit

class ZYUser: NSObject {
 /**
	*  昵称
	*/
	var screen_name: String?
	/**
	*  头像地址
	*/
	var profile_image_url: String?
	/**
	*  会员等级 1-6
	*/
	var mbrank: Int = 0
	/**
	*  认证类型 -1 没有认证 ，0 认证用户，2，3，5 企业认证 ， 220 达人
	*/
	var verified_type: Int = 0
	///发布微博时间
	var created_at: String? 
	
	/**
	*  kvc 构造函数
	*/
	
	init(dic: [String: AnyObject]) {
		super.init()
		setValuesForKeysWithDictionary(dic)
	}
	
	override func setValue(value: AnyObject?, forUndefinedKey key: String) {
		
	}
	
	
}

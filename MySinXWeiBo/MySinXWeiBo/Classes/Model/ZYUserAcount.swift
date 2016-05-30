//
//  ZYUserAcount.swift
//  MySinXWeiBo
//
//  Created by 飞奔的羊 on 16/5/13.
//  Copyright © 2016年 itcast. All rights reserved.
//

import UIKit

class ZYUserAcount: NSObject, NSCoding {
//用户授权的唯一票据
	var access_token: String?
	//access_token的生命周期,单位是秒数
	var expires_in: NSTimeInterval = 0 {
		didSet {
		
		//过期时间 = 当前时间 + 过期秒数
			expiresDate = NSDate().dateByAddingTimeInterval(expires_in)
		
		}
		
	
	}
	
	/**
	*  过期时间
	*/
	var expiresDate: NSDate?
	/**
	*  版权用户的 UID
	*/
	var uid: Int64 = 0
	/**
	*  用户名
	*/
	var name: String?
	/**
	*  用户头像
	
	*/
	var avatar_large: String?
	/**
	*  kvc 构造函数
	*/
	init(dic: [String: AnyObject]) {
		super.init()
		//设置属性赋值
		setValuesForKeysWithDictionary(dic)
	}
	//防止不崩溃
	override func setValue(value: AnyObject?, forUndefinedKey key: String) {
		
	}
	//重写 description 属性
	override var description: String {
		let keys = [
		"access_token",
		"expires_in",
		"uid",
		"name",
		"avatar_large"
			]
		
		return dictionaryWithValuesForKeys(keys).description
		
	
	}
	
	// MARK: ------归档和接档------
	//归档
	func encodeWithCoder(aCoder: NSCoder) {
		aCoder.encodeObject(access_token, forKey: "access_token")
		aCoder.encodeObject(expiresDate, forKey: "expiresDate")
		aCoder.encodeInt64(uid, forKey: "uid")
		aCoder.encodeObject(name, forKey: "name")
		aCoder.encodeObject(avatar_large, forKey: "avatar_large")
	}
	
	//解档
	required init?(coder aDecoder: NSCoder) {
		access_token = aDecoder.decodeObjectForKey("access_token") as? String
		expiresDate = aDecoder.decodeObjectForKey("expiresDate") as? NSDate
		uid = aDecoder.decodeInt64ForKey("uid")
		name = aDecoder.decodeObjectForKey("name") as? String
		avatar_large = aDecoder.decodeObjectForKey("avatar_large") as? String
	}
	/**
	保存用户对象
	
	- returns:
	*/
	func saveUserAccount() -> Bool {
	//归档路径
		let path = (NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).last! as NSString).stringByAppendingPathComponent("userAccount.archiver")
		return NSKeyedArchiver.archiveRootObject(self, toFile: path)
		
	
	
	}
	//解档
	class func loadUserAccount() -> ZYUserAcount? {
	//归档路径
		let path = (NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).last! as NSString).stringByAppendingPathComponent("userAccount.archiver")
		return NSKeyedUnarchiver.unarchiveObjectWithFile(path) as? ZYUserAcount
	
	}
}




























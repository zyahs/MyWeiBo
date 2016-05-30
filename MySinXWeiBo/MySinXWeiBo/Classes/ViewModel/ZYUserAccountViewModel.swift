//
//  ZYUserAccountViewModel.swift
//  MySinXWeiBo
//
//  Created by 飞奔的羊 on 16/5/13.
//  Copyright © 2016年 itcast. All rights reserved.
//

import UIKit

class ZYUserAccountViewModel: NSObject {

//单例的全局访问点
	static let sharedUserAccount: ZYUserAccountViewModel = ZYUserAccountViewModel()
	
	override init(){
	super.init()
		//获取归档对象
		userAccount = ZYUserAcount.loadUserAccount()
	}
	
	//只读属性
	var isLogin: Bool {
	//判断 accesstoken 不为 nil 带便登录,否则就是没有登录
	return accessToken != nil
	
	}
	//判断 accessToken 是否过期,如果没有过期直接返回可用 的 token'
	var accessToken: String? {
	//1.判断 accesstoken 是否存在,如果不存在就去登录
		//2.如果存在判断 accesstoken 是否过期,过期需要重新登录
		guard let token = userAccount?.access_token else {
		return nil
		}
		
		//token 一定幼稚,判断叉车伤身体坑是否过期
		let resule = userAccount?.expiresDate?.compare(NSDate())
		if resule == NSComparisonResult.OrderedDescending {
			//代表没有过期
			return token
		} else {
		
		return nil
		}
		
	}
	
	
	
	//保存用户对象
	var userAccount: ZYUserAcount?
	//封装网络接口
	//获取 accesstoken
	func requestAccessToken(code: String, complete: (isSuccess: Bool)-> ()	) {
	
		ZYNetWorkTools.sharedTools.requestAccessToken(code) { (response, error) in
			if error != nil {
			print(error)
				complete(isSuccess: false)
				return
			}
			//代码执行到此 网络请求成功
			guard let dic = response as? [String: AnyObject] else {
			print("非正确的 json 格式")
				complete(isSuccess: false)
				return
			}
			//代码执行到此,一定是字典
			let userAccount = ZYUserAcount(dic: dic)
			print(userAccount)
			self.requestUserInfo(userAccount, complete: complete)
		}
	}
	
	//获取用户信息
	 func requestUserInfo(userAccount: ZYUserAcount, complete: (isSuccess: Bool)->()) {
		ZYNetWorkTools.sharedTools.requestUserInfo(userAccount) { (response, error) in
			if error != nil {
			print("网络请求异常")
				complete(isSuccess: false)
				return
			
			}
			//判断 json 格式
			guard let dic = response as? [String: AnyObject] else {
			print("非争取的 json 数据")
				complete(isSuccess: false)
				return
			}
			//代码执行到此是一个正确的字典格式
			userAccount.name = dic["name"] as? String
			userAccount.avatar_large = dic["avatar_large"] as? String
			//设置用户数据
			self.userAccount = userAccount
			//归档数据
			let result = userAccount.saveUserAccount()
			//代表登录成功
			if result {
			//登录 chengg
				complete(isSuccess: true)
			
			} else {
			complete(isSuccess: false)
			}
		}
	
	}
	
	
}














































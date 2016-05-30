//
//  ZYNetWorkTools.swift
//  MySinXWeiBo
//
//  Created by 飞奔的羊 on 16/5/12.
//  Copyright © 2016年 itcast. All rights reserved.
//

import UIKit
import AFNetworking

//  请求方式
enum RequestType: Int {
	//  get请求
	case GET = 0
	//  post请求
	case POST = 1
}

 class ZYNetWorkTools: AFHTTPSessionManager {
	static let sharedTools: ZYNetWorkTools = {
	let tools = ZYNetWorkTools()
		//设置可以接受的响应类型
		tools.responseSerializer.acceptableContentTypes?.insert("text/plain")
	
	
	return tools
	}()
	//封装上传请求
	func requestUpLoad(url: String, params: AnyObject?, data:NSData, name: String, callBack: (response: AnyObject?, error: NSError?)-> ()) {
		POST(url, parameters: params, constructingBodyWithBlock: { (formData) in
	  //  image/jpeg.) For a list of valid MIME types, see http://www.iana.org/assignments/media-types/
			//  data 图片对应二进制数据
			//  name 服务端需要的参数
			//  filename 服务端获取你传入图片的名字,一般服务端不会使用,它们自己会随机生成一个唯一标记的图片名
			//  mimeType 资源类型 application/octet-stream  不确定类型的数据
			formData.appendPartWithFileData(data, name: name, fileName: "test", mimeType: "application/octet-stream")
			
			}, progress: nil, success: { (_, response) -> Void in
				callBack(response: response, error: nil)
		}) { (_, error) -> Void in
			callBack(response: nil, error: error)
		}
	}
	
	//网络请求封装 get/post
	func request(requestType: RequestType, url: String, params: AnyObject?, callBack: (response: AnyObject?, error: NSError?) -> ()) {
	//定义一个成功闭包
		let successClosure = {
			(dataTask: NSURLSessionDataTask, response: AnyObject?)  in
			//成功的回调
			callBack(response: response, error: nil)
		
		
		}
	//定义一个失败的闭包
		let failureClosure = {
			(dataTask: NSURLSessionDataTask?, error: NSError) in
			
			//失败的回调
			callBack(response: nil, error: error)
		
		
		}
		
	//方式
		if requestType == .GET {
			GET(url, parameters: params, progress: nil, success: successClosure, failure: failureClosure)
		} else {
		POST(url, parameters: params, progress: nil, success: successClosure, failure: failureClosure)
		
		}
	
	
	}
	
	
}

//发微博相关接口
extension ZYNetWorkTools {
	///发送图片微博接口
	func upload(access_token: String, status: String, image:UIImage, callBack: (response: AnyObject?, error: NSError?)-> ()) {
		let url = "https://upload.api.weibo.com/2/statuses/upload.json"
		let params = [
		"access_token": access_token,
		"status": status
		]
		//图片转成二进制
		let data = UIImageJPEGRepresentation(image, 0.6)!
		requestUpLoad(url, params: params, data: data, name: "pic", callBack: callBack)
	
	}
	
//发送文字微博接口
	func update(access_token: String, status: String, callBack: (response: AnyObject?, error: NSError?) -> ()) {
		let url = "https://api.weibo.com/2/statuses/update.json"
		let params = [
		"access_token": access_token,
		"status": status
		]
		request(.POST, url: url, params: params, callBack: callBack)
	
	
	}

}



//首页相关接口
extension ZYNetWorkTools {
//请求微博首页数据
	func requestStatus(accessToken: String, maxId: Int64 = 0, sinceId: Int64 = 0, callBack: (response: AnyObject?, error: NSError?) -> ()) {
	//创建 url
		let url = "https://api.weibo.com/2/statuses/friends_timeline.json"
		//设置参数
		let params = [
		"access_token": accessToken,
			"max_id": "\(maxId)",
			"since_id": "\(sinceId)"
		]
		
		request(.GET, url: url, params: params, callBack: callBack)
	
	}

}

//OAuth 相关接口
extension ZYNetWorkTools {
//获取 accesstoken 的接口
	func requestAccessToken(code: String, callBack: (response: AnyObject?, error: NSError?) -> ()) {
	//创建 url
		let url = "https://api.weibo.com/oauth2/access_token"
		//设置参数
		let params = [
		
		"client_id": WeiBoAppKey,
		"client_secret": WeiBoAppSecret,
		"grant_type": "authorization_code",
		"code": code,
		"redirect_uri": WeiBoRedirect_URL
		
		
		
		]
		
		request(.POST, url: url, params: params, callBack: callBack)
	
	
	
	}

	//获取用户信息
	func requestUserInfo(userAccount: ZYUserAcount, callBack: (response: AnyObject?, error: NSError?) -> ()) {
	
	//url
		let url = "https://api.weibo.com/2/users/show.json"
//设置参数
		let params = [
		"access_token":userAccount.access_token!,
		"uid": "\(userAccount.uid)"
		
		]
		request(.GET, url: url, params: params, callBack: callBack)
		
	}
	



}























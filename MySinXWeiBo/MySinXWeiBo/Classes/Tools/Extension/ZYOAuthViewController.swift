//
//  ZYOAuthViewController.swift
//  MySinXWeiBo
//
//  Created by 飞奔的羊 on 16/5/11.
//  Copyright © 2016年 itcast. All rights reserved.
//

import UIKit
import SVProgressHUD
import AFNetworking


//新浪微博的 appkey
let WeiBoAppKey = "1690635982"
//授权回调页
let WeiBoRedirect_URL = "http://www.baidu.com"

//AppSecret 获取 accesstoken
let WeiBoAppSecret = "99ff60c349159f2144490f9b1bb985b3"
class ZYOAuthViewController: UIViewController {

	// MARK: ------懒加载------
	//创建 webView
	private lazy var webView: UIWebView = UIWebView()
	
	//自定义 view
	override func loadView() {
		webView.delegate = self
		view = webView
	}
    override func viewDidLoad() {
        super.viewDidLoad()
		setUpNavUI()
		//请求登录地址
		let url = "https://api.weibo.com/oauth2/authorize?client_id=\(WeiBoAppKey)&redirect_uri=\(WeiBoRedirect_URL)"
		let request = NSURLRequest(URL: NSURL(string: url)!)
  
	//加载登录界面
		webView.loadRequest(request)
	
	
	}
	
	private func setUpNavUI() {
	
	navigationItem.leftBarButtonItem = UIBarButtonItem(title: "取消", fontSize: 15, target: self, action: #selector(ZYOAuthViewController.cancaleAction))
		
		navigationItem.rightBarButtonItem = UIBarButtonItem(title: "自动登录", fontSize: 15, target: self, action: #selector(ZYOAuthViewController.autoFillAction))
		navigationItem.title = "微博登录"
	
	}
	// MARK: ------点击事件------
	@objc private func cancaleAction() {
	dismissViewControllerAnimated(true, completion: nil)
	
	}
	
	@objc private func autoFillAction() {
	
	webView.stringByEvaluatingJavaScriptFromString("document.getElementById('userId').value = '452239611@qq.com'; document.getElementById('passwd').value = 'zy__++7222948'")
	
	}
	
	
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
// MARK: ------实现 UIWebView 代理方法------



extension ZYOAuthViewController: UIWebViewDelegate {

//将要加载函数请求方法
	func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
		print(request.URL?.absoluteString)
		
		guard let url = request.URL else {
		
		//加入地址为 nil, 就不执行加载
			return false
		}
		//取反就是不是我们关心的 url
		if !url.absoluteString.hasPrefix(WeiBoRedirect_URL){
		return true
		}
		//代码执行到此,就是我们需要关心的这个 url
		//query 就是我们请求指定里面的参数
		//以我们 code 打头我们采取截取
		if let query = url.query where query.hasPrefix("code=") {
			
			let code = query.substringFromIndex("code=".endIndex)
			
			ZYUserAccountViewModel.sharedUserAccount.requestAccessToken(code, complete: { (isSuccess) in
				if isSuccess {
				
				print("成功登陆")
					//dismiss 当前控制器
					//需要当前控制 diusmiss 完成以后才发送通知切换根视图控制器
					
					self.dismissViewControllerAnimated(false, completion: { 
						//进入欢迎界面
						NSNotificationCenter.defaultCenter().postNotificationName(SwitchRootVCNotification, object: self)
						
					})
				} else {
				
					
					
				SVProgressHUD.showErrorWithStatus("登陆失败")
				}
			})
			
			
		} else {
		//取消回调页
			dismissViewControllerAnimated(true, completion: nil)
		
		}
		
		
		
		return false
	}

	//开始加载请求
	func webViewDidStartLoad(webView: UIWebView) {
		SVProgressHUD.show()
	}
	//加载请求完成
	func webViewDidFinishLoad(webView: UIWebView) {
		SVProgressHUD.dismiss()
	}
	//加载失败
	func webView(webView: UIWebView, didFailLoadWithError error: NSError?) {
		SVProgressHUD.dismiss()
	}

}




























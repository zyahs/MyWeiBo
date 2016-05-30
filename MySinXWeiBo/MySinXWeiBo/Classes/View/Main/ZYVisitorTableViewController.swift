//
//  ZYVisitorTableViewController.swift
//  MySinXWeiBo
//
//  Created by 飞奔的羊 on 16/5/12.
//  Copyright © 2016年 itcast. All rights reserved.
//

import UIKit

class ZYVisitorTableViewController: UITableViewController {

	var userLogin = ZYUserAccountViewModel.sharedUserAccount.isLogin
	
	//访客视图
	var visitorView: ZYVisitorView?
	
	
    override func loadView() {
		if userLogin {
			
			super.loadView()
		} else {
		//没有登录的情况下,我们需要提供自定义的访客视图
			visitorView = ZYVisitorView()
			
			visitorView!.callBackClosure = {
			[weak self] in
				
				self?.requestOAuthLogin()
			
			}
		view = visitorView
			
			//创建按钮
			setUpNavUI()
		
		}
 
    }

	override func viewDidLoad() {
	super.viewDidLoad()
	
	}

	
	private func setUpNavUI() {
	navigationItem.leftBarButtonItem = UIBarButtonItem(title: "注册", fontSize: 15, target: self, action: #selector(ZYVisitorTableViewController.registerAction))
	
	navigationItem.rightBarButtonItem = UIBarButtonItem(title: "登录", fontSize: 15, target: self, action: #selector(ZYVisitorTableViewController.loginAction))
	
	}
	
	// MARK: ------点击事件------
	@objc private func registerAction() {
	requestOAuthLogin()
	
	}
	
	@objc private func loginAction() {
	requestOAuthLogin()
	
	}
	
	private func requestOAuthLogin() {
		let oauthVC = ZYOAuthViewController()
		let nav = UINavigationController(rootViewController: oauthVC)
		
		presentViewController(nav, animated: true, completion: nil)
		
		
	
	}
	
	
	
}



















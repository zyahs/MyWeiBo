//
//  ZYMainViewController.swift
//  MySinXWeiBo
//
//  Created by 飞奔的羊 on 16/5/11.
//  Copyright © 2016年 itcast. All rights reserved.
//

import UIKit
import SVProgressHUD

class ZYMainViewController: UITabBarController {
      override func viewDidLoad() {
  super.viewDidLoad()
		
		//创建自定义 tabbar
		let zyTabBar = ZYTabBar()
		zyTabBar.zyDelegate = self
		//使用[weak self] 闭包的循环引用
		zyTabBar.composeButtonClouser = {
		[weak self] in
//			print("嘎嘎?")
			//判断用户是否登录
			if  ZYUserAccountViewModel.sharedUserAccount.isLogin {
    
				self?.showComposeVC()
			} else {
			SVProgressHUD.showErrorWithStatus("请您先登录")
				
			}
		}
		
		//使用 kvc 的设置只读属性,设置自定义 tabbar
		setValue(zyTabBar, forKey: "tabBar")
		
		
		
		
							//添加控制器
       addChildViewController(ZYHomeTableViewController(), title: "首页", imageName: "tabbar_home")
							addChildViewController(ZYMessageTableViewController(), title: "消息", imageName: "tabbar_message_center")
							addChildViewController(ZYDiscoverTableViewController(), title: "发现", imageName:  "tabbar_discover")
							addChildViewController(ZYProfileTableViewController(), title: "我的", imageName: "tabbar_profile")
							
       
       
 }

 func addChildViewController(childController: UIViewController, title: String, imageName: String) {
  
  //设置全局统一的 tabbar 选中颜色,越早设置越好
     UITabBar.appearance().tintColor = UIColor.orangeColor()
  //统一文字
  childController.title = title
  //设置他把文字
  childController.tabBarItem.image = UIImage(named: imageName)
  
  childController.tabBarItem.selectedImage = UIImage(named: imageName + "_selected")
  
						//修改渲染模式
		childController.tabBarItem.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.orangeColor()], forState: .Selected)
		
		let nav = UINavigationController(rootViewController: childController)
		
		addChildViewController(nav)
	
 }
	//进入发微博界面
	private func showComposeVC() {
		let composeVC = ZYComposeViewController()
		let composeNav = UINavigationController(rootViewController: composeVC)
		
		presentViewController(composeNav, animated: true, completion: nil)
	}

	
}


extension ZYMainViewController: ZYTabBarDelegate {
	func didSelectedComposeButton() {
		print("代理~")
	}
	
}



//
//  AppDelegate.swift
//  MySinXWeiBo
//
//  Created by 飞奔的羊 on 16/5/11.
//  Copyright © 2016年 itcast. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

 var window: UIWindow?


 func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
	//监听通知
	NSNotificationCenter.defaultCenter().addObserver(self, selector:#selector(AppDelegate.switchRootVC(_:)), name: SwitchRootVCNotification, object: nil)
	
  //创建 window
  window = UIWindow(frame: UIScreen.mainScreen().bounds)
	
	if  ZYUserAccountViewModel.sharedUserAccount.isLogin {
		window?.rootViewController = ZYWelcomeViewController()
	} else  {
		 window?.rootViewController = ZYMainViewController()
	}
  //创建根视图控制器
 
  //设置主窗口并显示
  window?.makeKeyAndVisible()
  
  return true
 }
//监听通知的方法
	func switchRootVC(noti: NSNotification) {
		let object = noti.object
		//从 oauth 登录页面发送的通知,要进入欢迎页面的控制器
		if object is ZYOAuthViewController {
		window?.rootViewController = ZYWelcomeViewController()
		} else {
		//进入首页
			window?.rootViewController = ZYMainViewController()
		}
		
	
	
	}
 func applicationWillResignActive(application: UIApplication) {
  // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
  // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
 }

 func applicationDidEnterBackground(application: UIApplication) {
ZYStatusDAL.clearCacheData()
 }

 func applicationWillEnterForeground(application: UIApplication) {
  // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
 }

 func applicationDidBecomeActive(application: UIApplication) {
  // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
 }

 func applicationWillTerminate(application: UIApplication) {
  // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
 }


}


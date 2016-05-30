//
//  ZYWelcomeViewController.swift
//  MySinXWeiBo
//
//  Created by 飞奔的羊 on 16/5/13.
//  Copyright © 2016年 itcast. All rights reserved.
//

import UIKit
import SDWebImage

class ZYWelcomeViewController: UIViewController {
// MARK: ------懒加载控件------
	//背景图片
	private lazy var bgImageView: UIImageView = UIImageView(image: UIImage(named: "ad_background"))

	//头像
	private lazy var headImageView: UIImageView = {
		let view = UIImageView(image: UIImage(named: "avatar_default_big"))
		
		view.layer.cornerRadius = 45
		view.layer.masksToBounds = true
		//设置头像 url
		if let url = ZYUserAccountViewModel.sharedUserAccount.userAccount?.avatar_large {
			view.sd_setImageWithURL(NSURL(string: url), placeholderImage: UIImage(named: "avatar_default_big"))
		
		}
		
		return view
	}()
	
	//欢迎信息
	private lazy var messageLabeel: UILabel = {
	let label = UILabel()
	//设置名字
		if let name = ZYUserAccountViewModel.sharedUserAccount.userAccount?.name {
		label.text = name + ",欢迎回来!!!"
		} else {
		label.text = "欢迎回来"
		}
		label.font = UIFont.systemFontOfSize(14)
		label.textColor = UIColor.darkGrayColor()
		
	return label
	}()
	
	/**
	自定义 view
	*/
	override func loadView() {
	view = bgImageView
	}
	
	
	override func viewDidLoad() {
        super.viewDidLoad()
setUpUI()
		
    }

	override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated)
		startAnimation()
	}
 //添加子视图设置约束
	private func setUpUI() {
	view.addSubview(headImageView)
		view.addSubview(messageLabeel)
		
		//设置约束
		headImageView.snp_makeConstraints { (make) in
			make.centerX.equalTo(view)
			make.top.equalTo(200)
			make.size.equalTo(CGSize(width: 90, height: 90))
		}
		
		messageLabeel.snp_makeConstraints { (make) in
			make.top.equalTo(headImageView.snp_bottom).offset(10)
			make.centerX.equalTo(headImageView)
		}
		
	}
	
	private func startAnimation() {
	//改变约束
		self.headImageView.snp_updateConstraints { (make) in
			make.top.equalTo(self.view).offset(100)
		}
		//usingSpringWithDamping  阻尼   0 - 1   阻尼越大弹性效果越小
		//initialSpringVelocity 初始速度
		//枚举类型什么也不传 直接[]
		messageLabeel.alpha = 0
		UIView.animateWithDuration(1, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: [], animations: { 
			//让子视图重写布局
			self.view.layoutIfNeeded()
			
			}) { (_) in
			UIView.animateWithDuration(1, animations: { 
				self.messageLabeel.alpha = 1
				}, completion: { (_) in
					//进入首页
					NSNotificationCenter.defaultCenter().postNotificationName(SwitchRootVCNotification, object: nil)
			})
				
				
		}
		
	
	}
	
	
	
	
}












































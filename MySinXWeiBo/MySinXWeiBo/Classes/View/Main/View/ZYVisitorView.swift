//
//  ZYVisitorView.swift
//  MySinXWeiBo
//
//  Created by 飞奔的羊 on 16/5/11.
//  Copyright © 2016年 itcast. All rights reserved.
//

import UIKit
import SnapKit

class ZYVisitorView: UIView {
				//设置个闭包()
					var callBackClosure:			(() ->())?
						// MARK: ------懒加载控件------
								//旋转图片
	
	private lazy var cycleImageView: UIImageView = UIImageView(image: UIImage(named: "visitordiscover_feed_image_smallicon"))
	//罩子
	private	lazy var maskImageView: UIImageView = UIImageView(image: UIImage(named: "visitordiscover_feed_mask_smallicon"))
	
	//icon
	private lazy var iconImageView: UIImageView = UIImageView(image: UIImage(named: "visitordiscover_feed_image_house"))
	
	//文本信息
	private lazy var messageLabel: UILabel = {
		let label = UILabel()
		label.textColor = UIColor.darkGrayColor()
		label.text = "关注一些人,回这里看看有什么惊喜~~你猜呢,会有小礼物赠送哟"
		label.font = UIFont.systemFontOfSize(14)
		label.textAlignment = .Center
	//多行显示
		label.numberOfLines = 0
		
	
	return label
	}()
	
	//注册按钮
	private lazy var registerButton: UIButton = {
	let button = UIButton()
	button.setTitle("注册", forState: .Normal)
		
	button.addTarget(self, action: #selector(ZYVisitorView.registerAction), forControlEvents: .TouchUpInside)
		
		button.titleLabel?.font = UIFont.systemFontOfSize(14)
		
	button.setBackgroundImage(UIImage(named: "common_button_white_disable"), forState: .Normal)
		
		button.setTitleColor(UIColor.darkGrayColor(), forState: .Normal)
		button.setTitleColor(UIColor.orangeColor(), forState: .Highlighted)
		
		
	return button
	}()
	
	//登录按钮
	private lazy var loginButton: UIButton = {
	let button = UIButton()
		button.setTitle("登录", forState: .Normal)
		button.addTarget(self, action: #selector(ZYVisitorView.loginAction), forControlEvents: .TouchUpInside)
		button.setBackgroundImage(UIImage(named: "common_button_white_disable"), forState: .Normal)
		
		button.setTitleColor(UIColor.darkGrayColor(), forState: .Normal)
		
	
		return button
	}()
	
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		setUpUI()
		
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	private func setUpUI(){
	backgroundColor = UIColor(white: 237 / 255, alpha: 1)
		addSubview(cycleImageView)
		addSubview(maskImageView)
		addSubview(iconImageView)
		addSubview(messageLabel)
		addSubview(registerButton)
		addSubview(loginButton)
		
		//使用第三方框架设置约束
		
		cycleImageView.snp_makeConstraints { (make) in
			//中心
			make.center.equalTo(self)
		}
		
		maskImageView.snp_makeConstraints { (make) in
			make.center.equalTo(cycleImageView)
		}
		
		iconImageView.snp_makeConstraints { (make) in
			make.center.equalTo(cycleImageView)
		}
		
		messageLabel.snp_makeConstraints { (make) in
			make.centerX.equalTo(cycleImageView)
			make.top.equalTo(cycleImageView.snp_bottom)
			make.size.equalTo(CGSize(width: 224, height: 40))
		
		}
		
		registerButton.snp_makeConstraints { (make) in
			make.top.equalTo(messageLabel.snp_bottom).offset(10)
			make.leading.equalTo(messageLabel)
			make.size.equalTo(CGSize(width: 100, height: 35))
			
		}
		
		loginButton.snp_makeConstraints { (make) in
			make.top.equalTo(registerButton)
			make.trailing.equalTo(messageLabel)
			make.size.equalTo(registerButton)
			
			
		}
		
		
	
	
	}
	
	
	
	// MARK: ------点击事件------
	
	
	@objc private func loginAction(){
	callBackClosure?()
	
	}
	
	@objc private func registerAction(){
		callBackClosure?()
		
	}
	
	//动画
	private func startAnimation(){
		let animation = CABasicAnimation(keyPath: "transform.rotation")
		//目的地
		animation.toValue = 2 * M_PI
		//时长
		animation.duration = 20
		//重复次数
		
		animation.repeatCount = MAXFLOAT
		
		//防止动画在 切换控制器时释放掉
		animation.removedOnCompletion = false
		cycleImageView.layer.addAnimation(animation, forKey: nil)
	
	
	}
	
	func setVistorInfo(title: String?, imageName: String?){
	
		if let t = title, imgName = imageName {
		
		//进入不是首页,而是别的界面
			messageLabel.text = t
			iconImageView.image = UIImage(named: imgName)
			//旋转的图片隐藏起来
			cycleImageView.hidden = true
		
		}else {
		//通过首页进入的
			cycleImageView.hidden = false
			
			startAnimation()
		
		
		
		}
	
	
	
	}
	
	
	
	
}

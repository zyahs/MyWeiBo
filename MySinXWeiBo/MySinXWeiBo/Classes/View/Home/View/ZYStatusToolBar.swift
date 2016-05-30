//
//  ZYStatusToolBar.swift
//  MySinXWeiBo
//
//  Created by 飞奔的羊 on 16/5/13.
//  Copyright © 2016年 itcast. All rights reserved.
//

import UIKit

//微博底部的 toolBar
class ZYStatusToolBar: UIView {
	///  转发button
	private lazy var retweetButton: UIButton = self.addChildButton("timeline_icon_retweet", title: "转发")
	///  评论button
	private lazy var commentButton: UIButton = self.addChildButton("timeline_icon_comment", title: "评论")
	///  赞button
	private lazy var unlikeButton: UIButton = self.addChildButton("timeline_icon_unlike", title: "赞")
	
	var statusViewModel: ZYStatusViewModel? {
		didSet {
		
		retweetButton.setTitle(statusViewModel?.retweetCountContent, forState: .Normal)
			commentButton.setTitle(statusViewModel?.commentCountContent, forState: .Normal)
			
			unlikeButton.setTitle(statusViewModel?.unlikeCountContent, forState: .Normal)
			
			
		}
	}
	//手写代码创建 view
	override init(frame: CGRect) {
		super.init(frame: frame)
		setUpUI()
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	//添加控件约束
	private func setUpUI() {
		let firstLineView = addChildLineView()
		let secondLineView = addChildLineView()
		
		//设置约束
		retweetButton.snp_makeConstraints { (make) in
			make.leading.equalTo(self)
			make.top.equalTo(self)
			make.bottom.equalTo(self)
			make.width.equalTo(commentButton)
		}
		
		commentButton.snp_makeConstraints { (make) in
			make.leading.equalTo(retweetButton.snp_trailing)
			make.top.equalTo(self)
			make.bottom.equalTo(self)
			make.width.equalTo(unlikeButton)
			
		}
		
		unlikeButton.snp_makeConstraints { (make) in
			make.trailing.equalTo(self)
			make.top.equalTo(self)
			make.bottom.equalTo(self)
			make.leading.equalTo(commentButton.snp_trailing)
		}
		
		firstLineView.snp_makeConstraints { (make) in
			make.centerX.equalTo(retweetButton.snp_trailing)
			make.centerY.equalTo(self)
		}
		
		secondLineView.snp_makeConstraints { (make) in
			make.centerY.equalTo(self)
			make.centerX.equalTo(commentButton.snp_trailing)
			
		}
	
	}
///创建子视图按钮 imageName: 图片名字  title: 文字
	private func addChildButton(imageName: String, title: String) -> UIButton {
		let button = UIButton()
		
		button.setImage(UIImage(named: imageName), forState: .Normal)
		button.setBackgroundImage(UIImage(named: "timeline_card_bottom_background"), forState: .Normal)
		//去掉点击效果方法1
//		button.backgroundColor = UIColor(patternImage: UIImage(named: "timeline_card_bottom_background"))
		
		//去掉点击效果2
		button.adjustsImageWhenHighlighted = false
	button.titleLabel?.font = UIFont.systemFontOfSize(15)
		button.setTitle(title, forState: .Normal)
		button.setTitleColor(UIColor.grayColor(), forState: .Normal)
		addSubview(button)
		
	return button
	}
	///创建线
	private func addChildLineView() -> UIView {
		let view = UIImageView(image: UIImage(named: "timeline_card_bottom_line"))
		addSubview(view)
		return view
	
	}

}
























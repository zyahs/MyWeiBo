//
//  ZYStatusRetweetView.swift
//  MySinXWeiBo
//
//  Created by 飞奔的羊 on 16/5/13.
//  Copyright © 2016年 itcast. All rights reserved.
//

import UIKit
import SnapKit

///转发微博视图
class ZYStatusRetweetView: UIView {
	//记录底部约束
	var retweetViewBottom: Constraint?
	var statusViewModel: ZYStatusViewModel? {
		didSet{
		contentLabel.text = statusViewModel?.retweetContent
		
			//卸载约束
			retweetViewBottom?.uninstall()
			//判断转发微博的里面配图信息是否存在而且是否大于0
			if let picUrls = statusViewModel?.status?.retweeted_status!.pic_urls where picUrls.count > 0 {
    //显示配图
				pictureView.hidden = false
				//设置配图信息
				pictureView.picUrls = picUrls
				//更新约束
				self.snp_updateConstraints(closure: { (make) in
					self.retweetViewBottom = make.bottom.equalTo(pictureView).offset(StatusTableViewCellMargin).constraint
				})
			} else {
			//隐藏配图视图
			pictureView.hidden = true
				//更新约束
				self.snp_updateConstraints(closure: { (make) in
					self.retweetViewBottom = make.bottom.equalTo(contentLabel).offset(StatusTableViewCellMargin).constraint
				})
			}
		}
	}
// MARK: ------懒加载控件------
///转发微博内容
	private lazy var contentLabel: UILabel = {
	let label = UILabel(textColor: UIColor.grayColor(), fontSize: 14)
		//多行显示
		label.numberOfLines = 0
		label.text = "哈哈"
		return label
	
	}()
	
	//配图
	private lazy var pictureView: ZYStatusPictureView = {
	let view = ZYStatusPictureView()
		view.backgroundColor = self.backgroundColor
		return view
	}()
	
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		setUpUI()
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	private func setUpUI() {
	self.backgroundColor = UIColor(white: 0.95, alpha: 1)
		addSubview(contentLabel)
		addSubview(pictureView)
	//设置约束
		contentLabel.snp_makeConstraints { (make) in
			make.leading.equalTo(self).offset(StatusTableViewCellMargin)
			make.top.equalTo(self).offset(StatusTableViewCellMargin)
			make.trailing.equalTo(self).offset(-StatusTableViewCellMargin)
		}
		//图片约束
		pictureView.snp_makeConstraints { (make) in
			make.top.equalTo(contentLabel.snp_bottom).offset(StatusTableViewCellMargin)
			make.leading.equalTo(contentLabel)
		}
		//当前视图的约束
		self.snp_makeConstraints { (make) in
			self.retweetViewBottom = make.bottom.equalTo(pictureView).offset(StatusTableViewCellMargin).constraint
		}
	}
	
	
}

































//
//  ZYStatusTableViewCell.swift
//  MySinXWeiBo
//
//  Created by 飞奔的羊 on 16/5/13.
//  Copyright © 2016年 itcast. All rights reserved.
//

import UIKit
import SnapKit
///包括: 原创微博视图  转发微博视图   底部 toolBar

//  子控件之间的间距
let StatusTableViewCellMargin: CGFloat = 10

//首页微博的字体带下
let HomeFontSize: CGFloat = 14
class ZYStatusTableViewCell: UITableViewCell {
	
	var toolBarTop: Constraint?
//设置数据
	var statusViewModel: ZYStatusViewModel? {
		didSet{
		originalView.statusViewModel = statusViewModel
			
			//卸载约束
			toolBarTop?.uninstall()
			
			if statusViewModel?.status?.retweeted_status != nil {
    //显示转发微博视图 ,绑定数据
				//给转发微博视图绑定数据
			retweetView.statusViewModel = statusViewModel
				//显示转发微博
				retweetView.hidden = false
				toolBar.snp_makeConstraints(closure: { (make) in
					self.toolBarTop = make.top.equalTo(retweetView.snp_bottom).constraint
				})
			} else {
			//隐藏转发微博视图
				retweetView.hidden = true
			
				//更新约束
				toolBar.snp_updateConstraints(closure: { (make) in
					self.toolBarTop = make.top.equalTo(originalView.snp_bottom).constraint
				})
			}
			//绑定 toolBar 数据
			toolBar.statusViewModel = statusViewModel
		}
	
	}
	//原创微博视图
	private lazy var originalView: ZYStatusOriginalView = ZYStatusOriginalView()
	//微博底部 toolBar
	private lazy var toolBar: ZYStatusToolBar = ZYStatusToolBar()
	//转发微博视图
	private lazy var retweetView: ZYStatusRetweetView = ZYStatusRetweetView()
	
	override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
	setUpUI()
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	//添加子控件设置约束
	private func setUpUI() {
	contentView.backgroundColor = UIColor(white: 0.95, alpha: 1)
		//添加控件
		contentView.addSubview(originalView)
		contentView.addSubview(retweetView)
		contentView.addSubview(toolBar)
		//设置约束
		originalView.snp_makeConstraints { (make) in
			make.top.equalTo(contentView).offset(8)
			make.leading.equalTo(contentView)
			make.trailing.equalTo(contentView)
			
		}
		
		retweetView.snp_makeConstraints { (make) in
			make.top.equalTo(originalView.snp_bottom)
			make.leading.equalTo(contentView)
			make.trailing.equalTo(contentView)
		}
		toolBar.snp_makeConstraints { (make) in
			self.toolBarTop = make.top.equalTo(retweetView.snp_bottom).constraint
			make.leading.equalTo(contentView)
			make.trailing.equalTo(contentView)
			make.height.equalTo(40)
		}
		//关键的约束,约束要健全
		contentView.snp_makeConstraints { (make) in
			make.bottom.equalTo(toolBar)
			make.leading.equalTo(self)
			make.trailing.equalTo(self)
			make.top.equalTo(self)
		}
		
	}


}

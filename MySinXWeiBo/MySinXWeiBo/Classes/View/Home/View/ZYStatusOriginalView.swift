//
//  ZYStatusOriginalView.swift
//  MySinXWeiBo
//
//  Created by 飞奔的羊 on 16/5/13.
//  Copyright © 2016年 itcast. All rights reserved.
//

import UIKit
import SnapKit

/// 原创微博视图
class ZYStatusOriginalView: UIView {
//记录当前视图上一次底部约束
	var originalViewBottom: Constraint?
	
	//设置子控件数据
	var statusViewModel: ZYStatusViewModel? {
		didSet {
		//设置用户头像
			if let url = statusViewModel?.status?.user?.profile_image_url {
			userImageView.sd_setImageWithURL(NSURL(string: url), placeholderImage: UIImage(named: "avatar_default_big"))
			}
			screenNameLabel.text = statusViewModel?.status?.user?.screen_name
			contentLabel.text = statusViewModel?.status?.text
			contentLabel.numberOfLines = 0
			timeLabel.text = statusViewModel?.timeContent
			//设置数据来源
			sourceLabel.text =  statusViewModel?.sourceContent
			
			//卸载约束
			originalViewBottom?.uninstall()
			//判断原创微博是否有图片
			if let picUrls = statusViewModel?.status?.pic_urls where picUrls.count > 0 {
    //设置数据,显示配图,更新约束
				pictureView.hidden = false
				//设置数据
				pictureView.picUrls = picUrls
				//更新约束
				self.snp_updateConstraints(closure: { (make) in
					self.originalViewBottom = make.bottom.equalTo(pictureView).offset(StatusTableViewCellMargin).constraint
				})
			} else {
			//隐藏配图,更新约束
				pictureView.hidden = true
				//更新约束
			self.snp_updateConstraints(closure: { (make) in
				self.originalViewBottom = make.bottom.equalTo(contentLabel).offset(StatusTableViewCellMargin).constraint
			})
			}
			
			//设置会员等级图片
			mbrankImageView.image = statusViewModel?.mbrankImage
			//设置认证等级类型图片
			verifiedTypeImageView.image = statusViewModel?.verifiedTypeImage
		}
	
	}

	// MARK: ------懒加载控件------
	/**
	*  用户头像
	*/
	private lazy var userImageView: UIImageView = UIImageView(image: UIImage(named: "avatar_default_big"))
	/**
	*  认证类型等级
	*/
	private lazy var verifiedTypeImageView: UIImageView = UIImageView(image: UIImage(named: "avatar_vip"))
	/**
	*  会员等级
	*/
	private lazy var mbrankImageView: UIImageView = UIImageView(image: UIImage(named: "common_icon_membership"))
	/**
	*  昵称
	*/
	private lazy var screenNameLabel: UILabel = UILabel(textColor: UIColor.darkGrayColor(), fontSize: 15)
	/**
	*  时间
	*/

	private lazy var timeLabel: UILabel = UILabel(textColor: UIColor.orangeColor(), fontSize: 12)
	/**
	*  来源
	*/
	private lazy var sourceLabel: UILabel = UILabel(textColor: UIColor.lightGrayColor(), fontSize: 12)
	/**
	*  微博内容
	*/
	private lazy var contentLabel: UILabel = {
		let label = UILabel(textColor: UIColor.darkGrayColor(), fontSize: 14)
		label.numberOfLines = 0
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
	contentLabel.backgroundColor = UIColor.whiteColor()
		
		//添加控件
		addSubview(userImageView)
		addSubview(verifiedTypeImageView)
		addSubview(screenNameLabel)
		addSubview(mbrankImageView)
		addSubview(timeLabel)
		addSubview(sourceLabel)
		addSubview(contentLabel)
		addSubview(pictureView)
		//设置约束
		userImageView.snp_makeConstraints { (make) in
			make.top.equalTo(self).offset(StatusTableViewCellMargin)
		make.leading.equalTo(self).offset(StatusTableViewCellMargin)
			make.size.equalTo(CGSize(width: 35, height: 35))
		
		}
		
		verifiedTypeImageView.snp_makeConstraints { (make) in
			make.centerX.equalTo(userImageView.snp_trailing)
			make.centerY.equalTo(userImageView.snp_bottom)
		}
		
		screenNameLabel.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(userImageView)
			make.leading.equalTo(userImageView.snp_trailing).offset(StatusTableViewCellMargin)
		}
		mbrankImageView.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(screenNameLabel)
			make.leading.equalTo(screenNameLabel.snp_trailing).offset(StatusTableViewCellMargin)
		}
		timeLabel.snp_makeConstraints { (make) -> Void in
			make.bottom.equalTo(userImageView.snp_bottom)
			make.leading.equalTo(userImageView.snp_trailing).offset(StatusTableViewCellMargin)
		}
		sourceLabel.snp_makeConstraints { (make) -> Void in
			make.bottom.equalTo(timeLabel)
			make.leading.equalTo(timeLabel.snp_trailing).offset(StatusTableViewCellMargin)
		}
		contentLabel.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(userImageView.snp_bottom).offset(StatusTableViewCellMargin)
			make.leading.equalTo(userImageView)
			make.trailing.equalTo(self).offset(-StatusTableViewCellMargin)
		}
		pictureView.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(contentLabel.snp_bottom).offset(StatusTableViewCellMargin)
			make.leading.equalTo(contentLabel)
			
		}
		//给当前视图创建一个底部约束
		self.snp_makeConstraints { (make) in
			self.originalViewBottom = make.bottom.equalTo(pictureView.snp_bottom).offset(StatusTableViewCellMargin).constraint
		}
	
	}
	
}




















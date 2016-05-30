//
//  ZYProfileTableViewController.swift
//  MySinXWeiBo
//
//  Created by 飞奔的羊 on 16/5/11.
//  Copyright © 2016年 itcast. All rights reserved.
//

import UIKit

class ZYProfileTableViewController: ZYVisitorTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
		if userLogin {
			
		} else {
			//未登录情况下
			//  访客视图信息
			visitorView?.setVistorInfo("登录后，你的微博、相册、个人资料会显示在这里，展示给别人", imageName: "visitordiscover_image_profile")
		}
		
		
    }


}

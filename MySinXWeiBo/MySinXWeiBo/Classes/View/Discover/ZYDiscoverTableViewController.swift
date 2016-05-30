//
//  ZYDiscoverTableViewController.swift
//  MySinXWeiBo
//
//  Created by 飞奔的羊 on 16/5/11.
//  Copyright © 2016年 itcast. All rights reserved.
//

import UIKit

class ZYDiscoverTableViewController: ZYVisitorTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
		if userLogin {
			
		} else {
			//未登录情况下
			//  访客视图信息
			visitorView?.setVistorInfo("登录后，最新、最热微博尽在掌握，不再会与实事潮流擦肩而过", imageName: "visitordiscover_image_profile")
		}
		
    }

}

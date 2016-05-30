//
//  ZYEmoticonButton.swift
//  MySinXWeiBo
//
//  Created by 飞奔的羊 on 16/5/21.
//  Copyright © 2016年 itcast. All rights reserved.
//

import UIKit

class ZYEmoticonButton: UIButton {

///保存表情模型
	var emoticon: ZYEmoticon? {
		didSet {
			guard let etn = emoticon else {
			return
			}
			//让其显示
			self.hidden = false
			if etn.type == "0" {
    //如果是图片,则不用设置 title
				self.setImage(UIImage(named: etn.path!), forState: .Normal)
				self.setTitle(nil, forState: .Normal)
			} else {
	//emoji
				//如果是 emoji, 这不用设置 image
				self.setImage(nil, forState: .Normal)
				self.setTitle((etn.code! as NSString).emoji(), forState: .Normal)
			
			}
		}
	}
}

//
//  UITabbarItem-Extension.swift
//  DBZB
//
//  Created by lgh on 16/10/23.
//  Copyright © 2016年 lgh. All rights reserved.
//

import UIKit
import Foundation

extension UIBarButtonItem {
    
    // 不晓得这种写法在swift3.0不行???
    convenience init(name : String, highName : String = "", size : CGSize = CGSize.zero) {
//        self.init()
        let btn = UIButton(type: .custom)

        btn.setImage(UIImage(named: "name"), for: .normal)
        
        if size == CGSize.zero{
            btn.sizeToFit()
        }else{
            
            btn.setImage(UIImage(named: "highName"), for: .highlighted)
            btn.frame = CGRect(origin: CGPoint.zero, size: size)
        }
        self.init(customView : btn)
    }
    
    class func createBtn(name : String, highName : String = "", size : CGSize = CGSize.zero) -> UIBarButtonItem{
        
        let btn = UIButton()
        btn.setImage(UIImage(named : name), for: .normal)
        if size == CGSize.zero {
            btn.sizeToFit()
        }else{
            btn.setImage(UIImage(named : highName), for: .highlighted)
            btn.frame = CGRect(origin: CGPoint.zero, size: size)
        }
        return UIBarButtonItem(customView: btn)
    }
    
}










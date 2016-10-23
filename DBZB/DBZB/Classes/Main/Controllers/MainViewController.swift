//
//  MainViewController.swift
//  DBZB
//
//  Created by lgh on 16/10/23.
//  Copyright © 2016年 lgh. All rights reserved.
//

import UIKit

class MainViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        addChildVCWithName("Home")
        addChildVCWithName("Live")
        addChildVCWithName("follow")
        addChildVCWithName("profile")
    }

    
    private func addChildVCWithName(_ name : String){
        let vc = UIStoryboard(name: name, bundle: nil).instantiateInitialViewController()!
        addChildViewController(vc)
    }
    

}

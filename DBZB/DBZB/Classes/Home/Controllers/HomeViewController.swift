//
//  HomeViewController.swift
//  DBZB
//
//  Created by lgh on 16/10/23.
//  Copyright © 2016年 lgh. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        //
        setUpUI()
    }

    

}
// MARK: 扩展
extension HomeViewController{
    
    fileprivate func setUpUI() {
        setUpItems()
    }
    
    private func setUpItems() {
        navigationController?.navigationBar.barTintColor = UIColor.orange
        navigationItem.leftBarButtonItem = UIBarButtonItem.createBtn(name: "homeLogoIcon")
        
        let size = CGSize(width: 40, height: 40)
        
        
        let viewHistoryIcon = UIBarButtonItem.createBtn(name: "viewHistoryIcon", highName: "viewHistoryIconHL", size: size)
        let scanIcon = UIBarButtonItem.createBtn(name: "scanIcon", highName: "scanIconHL", size: size)
        let searchBtnIcon = UIBarButtonItem.createBtn(name: "searchBtnIcon", highName: "searchBtnIconHL", size: size)
        
        navigationItem.rightBarButtonItems = [viewHistoryIcon, scanIcon, searchBtnIcon]
    }
    
}














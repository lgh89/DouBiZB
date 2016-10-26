//
//  HomeViewController.swift
//  DBZB
//
//  Created by lgh on 16/10/23.
//  Copyright © 2016年 lgh. All rights reserved.
//

import UIKit

let kScrollViewH : CGFloat = 40


class HomeViewController: UIViewController {

    lazy var pageTitleView : PageTitleView = {[unowned self] in
        
        let ptv = PageTitleView(frame:CGRect(x: 0, y: kStatusBar + kNavgationBar, width: kScreenW, height: kScrollViewH) , titles: ["推荐", "游戏", "娱乐", "趣玩"])
        return ptv
    }()
    
    lazy var pageContentView : PageContentView = {[unowned self] in
       
        let rect = CGRect(x: 0, y: kStatusBar + kNavgationBar + kScrollViewH, width: kScreenW, height: kScreenH - kStatusBar - kNavgationBar - kScrollViewH)
        
        var chindVC = [UIViewController]()
        
        for i in 0..<4{
            let vc = UIViewController()
            vc.view.backgroundColor = UIColor(r: CGFloat(arc4random_uniform(256)), g: CGFloat(arc4random_uniform(256)), b: CGFloat(arc4random_uniform(256)))
            chindVC.append(vc)
        }
        
        let pcv = PageContentView(frame: rect, childVC: chindVC, parentVC: self)
        return pcv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 设置UI界面
        setUpUI()
    }
}
// MARK: 扩展
extension HomeViewController{
    
    fileprivate func setUpUI() {
        self.automaticallyAdjustsScrollViewInsets = false
        setUpItems()
        pageTitleView.pageDelegate = pageContentView
        pageContentView.pageContentViewDelegate = pageTitleView
        view.addSubview(pageTitleView)
        view.addSubview(pageContentView)
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











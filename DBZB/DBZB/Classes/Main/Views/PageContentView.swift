//
//  PageContentView.swift
//  DBZB
//
//  Created by lgh on 16/10/24.
//  Copyright © 2016年 lgh. All rights reserved.
//

import UIKit

protocol pageContentViewDelegate : class {
    func pageContentViewScroll(pageContentView : PageContentView, process : CGFloat, source : Int, destination : Int)
}

class PageContentView: UIView {
    
    // MARK: 记录滚动collectionview时的起始偏移量
    var startX : CGFloat = 0.0
    var isForbit : Bool = false
    
    
    // MARK: pageContentView的代理
    weak var pageContentViewDelegate : pageContentViewDelegate?
    
    // MARK: collectionView的懒加载
    lazy var collectionView : UICollectionView = {[unowned self] in
        //1.创建布局对象
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: self.bounds.size.width, height: self.bounds.size.height)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0)
        //2.创建collectionview对象
        let cv = UICollectionView(frame: self.bounds, collectionViewLayout: layout)
        cv.backgroundColor = UIColor.white
        cv.isPagingEnabled = true
        cv.dataSource = self
        cv.delegate = self
        cv.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        return cv
    }()
    
    // MARK: 存储子控制器
    var childViewControllers : [UIViewController]?
    

    init(frame: CGRect, childVC : [UIViewController], parentVC : UIViewController) {
        super.init(frame: frame)
        self.childViewControllers = childVC
        
        //添加子控制器
        for vc in childVC {
            parentVC.addChildViewController(vc)
        }
        // 设置UI界面
        setUpUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

// MARK: 设置UI界面
extension PageContentView{
    
    fileprivate func setUpUI() {
        addSubview(collectionView)
    }
    
}

// MARK: collectionviewDataSource的代理方法
extension PageContentView : UICollectionViewDataSource{
    // 返回子控制器个数
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.childViewControllers!.count
    }
    // 返回collectionviewCell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cv = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        
        // 移除之前的view(因为复用)
        for view in cv.contentView.subviews {
            view.removeFromSuperview()
        }
        
        let vc = self.childViewControllers![indexPath.row]
        cv.contentView.addSubview(vc.view)
        return cv
    }
}

// MARK: collectionViewDelegate代理方法
extension PageContentView : UICollectionViewDelegate {
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        startX = scrollView.contentOffset.x
        isForbit = false
//        print("**** + \(startX)")
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if isForbit {
            return
        }
        
//        let offsetX = scrollView.contentOffset.x
//
//        
//        if isForbit == true || offsetX <= 0 || offsetX >= scrollView.contentSize.width - scrollView.bounds.width {return}
//        print("offsetX:" + "\(offsetX)")
//        print("width : " + "\(scrollView.contentSize.width)")
//        // 1.需要获取的内容
//        var process : CGFloat = 0.0
//        var source = 0
//        var destination = 0
//        
//        
////        print(scrollView.subviews.count)
//        let ratio = offsetX / scrollView.bounds.width
//        process = ratio - floor(ratio)
//        
//        
//        
//        // 2.偏移量
//        // 向左移动
//        if offsetX > startX {
//            destination = Int(offsetX / scrollView.bounds.width) + 1
//            source = destination - 1
//            if destination >= self.childViewControllers!.count {
//                destination = self.childViewControllers!.count - 1
//            }
//        } else if offsetX < startX {
//            
//            source = Int(startX / scrollView.bounds.width)
//            destination = source - 1
//            if destination < 0 {
//                destination = 0
//            }
//            
//            process = 1 - process
//        } else{
//            source = Int(offsetX / scrollView.bounds.width)
//            destination = source
//        }
        
        //============
        
        var process : CGFloat = 0.0
        var source : Int = 0
        var destination : Int = 0
        
        let offsetX = scrollView.contentOffset.x
        let ratio = offsetX / scrollView.bounds.width
        process = ratio - floor(ratio)
        
        
        if offsetX > startX {
            
            source = Int(offsetX / scrollView.bounds.width)
            
            destination = source + 1
            if destination >= self.childViewControllers!.count{
                destination = self.childViewControllers!.count - 1
            }
            if offsetX - startX == scrollView.bounds.width {
                destination = source
                process = 1.0
            }
//            print("........")
        }else{
            
            destination = Int(offsetX / scrollView.bounds.width)
            source = destination + 1
            if source >= self.childViewControllers!.count{
                source = self.childViewControllers!.count - 1
            }
            
            process = 1 - process
            
        }
        if offsetX < 0 {
            destination = 0
            source = 0
        }
        
        if let pageDelegate = self.pageContentViewDelegate  {
            pageDelegate.pageContentViewScroll(pageContentView: self, process: process, source: source, destination: destination)
        }
    }
}

// MARK: pageTitleViewDelegate
extension PageContentView : pageTitleViewDelegate{
    // 点击了pageTitleView代理方法
    func clickPageIndex(pageTitleView: PageTitleView, index: Int) {
        let x = kScreenW * CGFloat(index)
        self.collectionView.contentOffset = CGPoint(x: x, y: 0)
        
//        isForbit = true   
    }
}






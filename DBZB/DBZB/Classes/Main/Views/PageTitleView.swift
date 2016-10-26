//
//  PageTitleView.swift
//  DBZB
//
//  Created by lgh on 16/10/24.
//  Copyright © 2016年 lgh. All rights reserved.
//

import UIKit

private let kScrollLineH : CGFloat = 3.5
private let kNormalColor : (CGFloat, CGFloat, CGFloat) = (85, 85, 85)
private let kSelectColor : (CGFloat, CGFloat, CGFloat) = (255, 125, 0)



protocol pageTitleViewDelegate :class {
    func clickPageIndex(pageTitleView : PageTitleView, index : Int)
}

class PageTitleView: UIView {
    
    // MARK: 代理
    weak var pageDelegate : pageTitleViewDelegate?

    // MARK: 存储title文字
    var titles : [String]? = nil
    var currentIndex : Int = 0
    
    // MARK: 懒加载存储所有lable
    lazy var titlesLabels : [UILabel] = {
        let array = [UILabel]()
        return array
    }()
    
    // MARK: 滚动底线
    var scrollViewLine : UIView? = nil
    
    // MARK: 初始化方法
    init(frame: CGRect, titles : [String]) {
        super.init(frame: frame)
        self.titles = titles
        setUpUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: 设置UI界面
extension PageTitleView {
    
    fileprivate func setUpUI(){
        
        //1.添加scrollview:
        let sv = UIScrollView(frame: self.bounds)
        sv.showsHorizontalScrollIndicator = false
        sv.showsVerticalScrollIndicator = false
        sv.bounces = false
        self.addSubview(sv)
        
        //2.添加lables:
        let labelW = kScreenW / 4.0
        let labelH = bounds.size.height - kScrollLineH
        let labelY : CGFloat = 0.0
        
        sv.contentSize = CGSize(width: labelW * CGFloat(titles!.count), height: 0)
        if let t = titles {
            for (index, items) in t.enumerated() {
                
                let labelX = CGFloat(index) * labelW
                // 创建lable
                let label = UILabel(frame: CGRect(x: labelX, y: labelY, width: labelW, height: labelH))
                // 设置lable的属性
                label.textAlignment = .center
                label.textColor = UIColor(r: kNormalColor.0, g: kNormalColor.1, b: kNormalColor.2)
                label.font = UIFont.systemFont(ofSize: 16.0)
                label.text = items
                label.tag = index
                titlesLabels.append(label)
                // 添加lable到scrollview
                sv.addSubview(label)
                
                //lable添加点击手势:
                let tap = UITapGestureRecognizer(target: self, action: #selector(clickTap(tap:)))
                label.isUserInteractionEnabled = true
                label.addGestureRecognizer(tap)
            }
        }
        //3.添加底线
        let line = UIView()
        line.frame = CGRect(x: 0, y: self.bounds.size.height - 0.5, width: self.bounds.size.width, height: 0.5)
        line.backgroundColor = UIColor.lightGray
        addSubview(line)
        
        //4.添加滑动scrollviewLine
        let sl = UIView()
        sl.frame = CGRect(x: 0, y: self.bounds.size.height - kScrollLineH, width: labelW, height: kScrollLineH)
        sl.backgroundColor = UIColor(r: kSelectColor.0, g: kSelectColor.1, b: kSelectColor.2)
        scrollViewLine = sl
        sv.addSubview(sl)
        
        //5.设置第一个lable的颜色
        let currentLabel = titlesLabels[0]
        currentLabel.textColor = UIColor.orange
    }
    // 响应方法
    @objc private func clickTap(tap : UITapGestureRecognizer){
        
        guard  let _ = tap.view else {
            return
        }
        
        if let pcv : PageContentView = pageDelegate as? PageContentView{
            pcv.isForbit = true
        }
        
        
        if tap.view!.tag != currentIndex  {
            
            titlesLabels[currentIndex].textColor = UIColor(r: kNormalColor.0, g: kNormalColor.1, b: kNormalColor.2)
            currentIndex = tap.view!.tag
            titlesLabels[currentIndex].textColor = UIColor(r: kSelectColor.0, g: kSelectColor.1, b: kSelectColor.2)
            // 计算scrollviewLine的偏移量
            var rect = self.scrollViewLine!.frame
            let x = rect.size.width * CGFloat(tap.view!.tag)
            rect.origin.x = x
            // 动画
            UIView.animate(withDuration: 0.15, animations: {
                self.scrollViewLine!.frame = rect
            })
        }
        if let delegate = self.pageDelegate {
            delegate.clickPageIndex(pageTitleView: self, index: currentIndex)
        }
    }
}

extension PageTitleView : pageContentViewDelegate{
    // 滚动collectionview的代理方法
    func pageContentViewScroll(pageContentView: PageContentView, process: CGFloat, source: Int, destination: Int) {
//        print(process, source, destination)
        
        if source == destination {
            return
        }
        
        //1.获取原始label和目标lable
        let sourceLable = titlesLabels[source]
        let destinLable = titlesLabels[destination]
        
        //2.处理滑块
        let offsetX = destinLable.frame.origin.x - sourceLable.frame.origin.x
        let detalX = offsetX * process
        scrollViewLine?.frame.origin.x = sourceLable.frame.origin.x + detalX
        
        //3.label的渐变色
        let detalColr = (kSelectColor.0 - kNormalColor.0, kSelectColor.1 - kNormalColor.1, kSelectColor.2 - kNormalColor.2)
        
        destinLable.textColor = UIColor(r: kNormalColor.0 + detalColr.0 * process, g: kNormalColor.1 + detalColr.1 * process, b: kNormalColor.2 + detalColr.2 * process)
        sourceLable.textColor = UIColor(r: kSelectColor.0 - detalColr.0 * process, g: kSelectColor.1 - detalColr.1 * process, b: kSelectColor.2 - detalColr.2 * process)
        
        //4.设置curr
        currentIndex = Int(destination)
    }
}








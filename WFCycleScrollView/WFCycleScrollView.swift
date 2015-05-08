//
//  WFCycleScrollView.swift
//  WFCycleScrollView
//
//  Created by happi on 15/4/10.
//  Copyright (c) 2015年 happi. All rights reserved.
//

import UIKit

protocol WFCycleScrollViewDelegate {
    func didClickPage(scView:WFCycleScrollView, index:NSInteger)
}

protocol WFCycleScrollViewDatasource {
    func numberOfPages() -> NSInteger
    func pageAtIndex(index:NSInteger) -> UIView
}




enum UIPageControlShowStyle:NSInteger {
    case None = 0
    case Left = 1
    case Center = 2
    case Right = 3
}

class WFCycleScrollView: UIView,UIScrollViewDelegate {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    var pageControlShowStyle:UIPageControlShowStyle = UIPageControlShowStyle.None

    var UISCREENWIDTH:NSInteger!
    var UISCREENHEIGHT:NSInteger!
    
    var scrollView:UIScrollView!
    
    var pageControl:UIPageControl!
    
    var delegate:WFCycleScrollViewDelegate!
    var datasource:WFCycleScrollViewDatasource!
    
    var totalPages:NSInteger = 0
    var curPage:NSInteger = 0
    
    var curViews:NSMutableArray!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        UISCREENWIDTH = NSInteger(self.bounds.size.width)//广告的宽度
        UISCREENHEIGHT = NSInteger(self.bounds.size.height)//广告的高度
        
        scrollView = UIScrollView(frame: self.bounds)
        scrollView.delegate = self
        scrollView.contentSize = CGSizeMake(self.bounds.size.width * 3, 0)
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.contentOffset = CGPointMake(self.bounds.size.width, 0)
        scrollView.pagingEnabled = true
        self.addSubview(scrollView)
        
        pageControl = UIPageControl()
        pageControl.userInteractionEnabled = false
        self.addSubview(self.pageControl)
        
        
        
        
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func animalMoveImage() {
        self.scrollView.setContentOffset(CGPointMake(self.scrollView.frame.size.width * 2, 0), animated: true)
    }
    
    
    func reloadData() {
        self.totalPages = datasource.numberOfPages()
        if self.totalPages == 0 {
            return
        }
        
        self.pageControl.numberOfPages = self.totalPages
        self.setPageControlShowStyle(self.pageControlShowStyle, pageControlCount: self.pageControl.numberOfPages)
        
        if self.totalPages > 1 {
            var moveTime = NSTimer.scheduledTimerWithTimeInterval(3, target: self, selector: Selector("animalMoveImage"), userInfo: nil, repeats: true);
        }
        
        
        
        self.loadData()
    }
    
    func loadData() {
        
        if self.totalPages == 0 {
            return
        }
        
        self.pageControl.currentPage = self.curPage
        var subViews:NSArray = self.scrollView.subviews
        
        if subViews.count != 0 {
            for aView in subViews {
                aView.removeFromSuperview()
            }
        }
        
        self.getDisplayImagesWithCurpage(self.curPage)
        
        for (var i = 0; i < 3; i++) {
            var v:UIView = self.curViews[i] as! UIView
            v.userInteractionEnabled = true
            
            var singleTap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: Selector("handleTap:"))
            v.addGestureRecognizer(singleTap)
            v.frame = CGRectOffset(v.frame, v.frame.size.width * CGFloat(i), 0)
            self.scrollView.addSubview(v)
        }
        self.scrollView.setContentOffset(CGPointMake(self.scrollView.frame.size.width, 0), animated: false)
        
    }
    
    
    
    func getDisplayImagesWithCurpage(page:Int) {
        
        var num = self.curPage - 1
        var pre:NSInteger = self.validPageValue(&num)
        
        var num1 = self.curPage + 1
        var last:NSInteger = self.validPageValue(&num1)
        
        if (self.curViews == nil || self.curViews.count <= 0) {
            self.curViews = NSMutableArray()
        }
        
        self.curViews.removeAllObjects()
        self.curViews.addObject(self.datasource.pageAtIndex(pre))
        self.curViews.addObject(self.datasource.pageAtIndex(page))
        self.curViews.addObject(self.datasource.pageAtIndex(last))
        
    }
    
    
    func validPageValue(inout value:NSInteger) -> NSInteger {
        if value == -1 {
            value = self.totalPages - 1
        }
        if value == self.totalPages {
            value = 0
        }
        return value
    }
    
    
    func handleTap(tap:UITapGestureRecognizer) {
        self.delegate.didClickPage(self, index: self.curPage)
    }
    
    /*
    *UIScrollViewDelegate
    */
    func scrollViewDidScroll(scrollView: UIScrollView) {
        var x = scrollView.contentOffset.x
        
        if x >= (2 * self.frame.size.width) {
            var num = self.curPage + 1
            self.curPage = self.validPageValue(&num)
            self.loadData()
        }
        
        if x <= 0 {
            var num = self.curPage - 1
            self.curPage = self.validPageValue(&num)
            self.loadData()
        }
        
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        self.scrollView.setContentOffset(CGPointMake(self.scrollView.frame.size.width, 0), animated: true)
    }
    
    
    
    /*
    *pragma mark - 创建pageControl,指定其显示样式
    */
    func setPageControlShowStyle(style:UIPageControlShowStyle, pageControlCount:NSInteger) {
        
        if style == UIPageControlShowStyle.None {
            return;
        }
        
        if style == UIPageControlShowStyle.Left {
            self.pageControl.frame = CGRectMake(10, CGFloat(self.UISCREENHEIGHT - 20), CGFloat(20 * pageControlCount), 20)
        } else if style == UIPageControlShowStyle.Center {
            self.pageControl.frame = CGRectMake(0, 0, CGFloat(20 * pageControlCount), 20)
            self.pageControl.center = CGPointMake(CGFloat(self.UISCREENWIDTH / 2), CGFloat(self.UISCREENHEIGHT - 10))
        } else if style == UIPageControlShowStyle.Right {
            self.pageControl.frame = CGRectMake(CGFloat(self.UISCREENWIDTH - 20 * pageControlCount), CGFloat(self.UISCREENHEIGHT - 20), CGFloat(20 * pageControlCount), 20)
        }
        
    }
    
    
    
}

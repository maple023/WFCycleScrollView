//
//  ViewController.swift
//  WFCycleScrollView
//
//  Created by happi on 15/4/10.
//  Copyright (c) 2015年 happi. All rights reserved.
//

import UIKit

class ViewController: UIViewController,WFCycleScrollViewDatasource,WFCycleScrollViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        var cycleScroll:WFCycleScrollView = WFCycleScrollView(frame: CGRectMake(0, 64, self.view.frame.size.width, 150))
        cycleScroll.delegate = self
        cycleScroll.datasource = self
        cycleScroll.backgroundColor = UIColor.blueColor()
        cycleScroll.pageControlShowStyle = UIPageControlShowStyle.Right
        cycleScroll.pageControl.pageIndicatorTintColor = UIColor.whiteColor();
        cycleScroll.pageControl.currentPageIndicatorTintColor = UIColor.blueColor();
        self.view.addSubview(cycleScroll)
        
        
        cycleScroll.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    
    func numberOfPages() -> NSInteger {
        return 4
    }
    
    func pageAtIndex(index: NSInteger) -> UIView {
        var view = UIView(frame: CGRectMake(0, 0, self.view.frame.width, 150))
        view.backgroundColor = UIColor.redColor()
        
        var tit:UILabel = UILabel(frame: CGRectMake(100, 40, 150, 20))
        tit.text = "第\(index)页面"
        view.addSubview(tit)
        
        return view
    }
    
    func didClickPage(scView: WFCycleScrollView, index: NSInteger) {
        println("---\(index)")
    }
    
}


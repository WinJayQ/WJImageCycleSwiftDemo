//
//  WJImageCycleView.swift
//  WJImageCycleDemo
//
//  Created by jh navi on 15/9/12.
//  Copyright (c) 2015年 WJ. All rights reserved.
//

import Foundation
import UIKit

private let margin: CGFloat = 20

public protocol WJImageCycleViewDelegate: NSObjectProtocol{
    func didSelectCurrentPage(index: Int)
    func numberOfPages() -> Int
    func currentPageViewIndex(index: Int) -> String
}

class WJImageCycleView: UIView,UIScrollViewDelegate {

    var scrollView: UIScrollView!
    var pageControl: UIPageControl!
    var timer: NSTimer?
    var currentImageView = UIImageView()
    var lastImageView = UIImageView()
    var nextImageView = UIImageView()
    var totalPages: Int!
    
    weak var delegage: WJImageCycleViewDelegate? {
        didSet{
            totalPages = delegage?.numberOfPages()
            scrollView.scrollEnabled = !(totalPages == 1)
            setScrollViewOfImage()
            
            self.pageControl = UIPageControl(frame: CGRectMake((self.frame.size.width - margin * CGFloat(totalPages))/2, self.frame.size.height - 30, margin * CGFloat(totalPages), margin))
            pageControl.hidesForSinglePage = true
            pageControl.numberOfPages = totalPages
            pageControl.currentPageIndicatorTintColor = UIColor.orangeColor()
            pageControl.pageIndicatorTintColor = UIColor.blueColor()
            pageControl.backgroundColor = UIColor.clearColor()
            self.addSubview(pageControl)
            
        }
    }
    var currentPageIndex: Int! {
        didSet{
            self.pageControl.currentPage = currentPageIndex
        }
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        currentPageIndex = 0
        setUpCycleScrollView()
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpCycleScrollView() {
        self.scrollView = UIScrollView(frame: CGRectMake(0, 0, self.frame.size.width, self.frame.size.height))
        scrollView.contentSize = CGSizeMake(self.frame.size.width * 3, 0)
        scrollView.delegate = self
        scrollView.bounces = false
        scrollView.pagingEnabled = true
        scrollView.backgroundColor = UIColor.greenColor()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        self.addSubview(scrollView)
        
        self.setImageViewWithIndex(index: 1, imageView: currentImageView)
        self.setImageViewWithIndex(index: 0, imageView: lastImageView)
        self.setImageViewWithIndex(index: 2, imageView: nextImageView)
        
        scrollView.setContentOffset(CGPointMake(self.frame.size.width, 0), animated: false)
        self.timer = NSTimer.scheduledTimerWithTimeInterval(2.0, target: self, selector: "timerAction", userInfo: nil, repeats: true)
    }
    
    func timerAction() {
        scrollView.setContentOffset(CGPointMake(self.frame.size.width * 2, 0), animated: true)
    }
    private func setImageViewWithIndex(#index: Int,imageView:UIImageView!) {
        imageView.frame = CGRectMake(self.frame.size.width * CGFloat(index), 0, self.frame.size.width, self.frame.size.height)
        imageView.userInteractionEnabled = true
        imageView.contentMode = UIViewContentMode.ScaleAspectFill
        imageView.clipsToBounds = true
        scrollView.addSubview(imageView)
        
        if imageView == self.currentImageView {
            var imagesTap = UITapGestureRecognizer(target: self, action: Selector("imageTapAction"))
            currentImageView.addGestureRecognizer(imagesTap)
        }
    }
    func imageTapAction() {
        delegage?.didSelectCurrentPage(currentPageIndex)
    }
    
    private func setScrollViewOfImage() {
        currentImageView.image = UIImage(named: (delegage?.currentPageViewIndex(currentPageIndex))!)
        NSLog("%@",delegage!.currentPageViewIndex(currentPageIndex))
        lastImageView.image = UIImage(named: (delegage?.currentPageViewIndex(getLastImageIndex(currentPageIndex)))!)
        nextImageView.image = UIImage(named: (delegage?.currentPageViewIndex(getNextImageIndex(currentPageIndex)))!)
    }
    private func getLastImageIndex(currentImageIndex: Int) -> Int {
        var tempIndex = currentPageIndex - 1
        if tempIndex == -1 {
            return totalPages - 1
        }else{
            return tempIndex
        }
    }
    private func getNextImageIndex(currentImageIndex: Int) -> Int {
        var tempIndex = currentPageIndex + 1
        return tempIndex < totalPages ? tempIndex : 0
    }
    
    
    /**
    *  scrollViewDelegage
    */
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        timer?.invalidate()
        timer = nil
    }
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            self.scrollViewDidEndDecelerating(scrollView)
        }
    }
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        var offset = scrollView.contentOffset.x
        if offset == 0 {
            self.currentPageIndex = self.getLastImageIndex(self.currentPageIndex)
        }else if offset == self.frame.size.width * 2 {
            self.currentPageIndex = self.getNextImageIndex(self.currentPageIndex)
        }
        self.setScrollViewOfImage()
        scrollView.setContentOffset(CGPointMake(self.frame.size.width, 0), animated: false)
        if timer == nil {
            self.timer = NSTimer.scheduledTimerWithTimeInterval(2.0, target: self, selector: "timerAction", userInfo: nil, repeats: true)
        }
    }
    func scrollViewDidEndScrollingAnimation(scrollView: UIScrollView) {
        self.scrollViewDidEndDecelerating(scrollView)
    }
}














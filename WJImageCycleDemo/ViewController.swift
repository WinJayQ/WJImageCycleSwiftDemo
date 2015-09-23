//
//  ViewController.swift
//  WJImageCycleDemo
//
//  Created by jh navi on 15/9/12.
//  Copyright (c) 2015年 WJ. All rights reserved.
//

import UIKit

class ViewController: UIViewController,WJImageCycleViewDelegate {

    var imageArray: [String!] = ["西施.jpg","王昭君.jpg","貂蝉.jpg","杨玉环.jpg"]
    var imageLable: UILabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.view.backgroundColor = UIColor.lightGrayColor()
        
        let imageCycleView = WJImageCycleView(frame: CGRectMake(0, 0, self.view.frame.width-100, self.view.frame.height-200))
        imageCycleView.center = self.view.center
        imageCycleView.backgroundColor = UIColor.blueColor()
        imageCycleView.delegage = self
        self.view.addSubview(imageCycleView)
        imageLable.frame = CGRectMake(100, 50, 200, 50)
        imageLable.textColor = UIColor.blueColor()
        self.view.addSubview(imageLable)
    }
    
    func numberOfPages() -> Int {
        return imageArray.count
    }
    func currentPageViewIndex(index: Int) -> String {
        imageLable.text = imageArray[index]
        return imageArray[index]
    }
    func didSelectCurrentPage(index: Int) {
        print("\(index)")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


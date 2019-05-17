//
//  ZJCircleView.swift
//  InfoAPP
//
//  Created by leeco on 2019/5/17.
//  Copyright © 2019 zsw. All rights reserved.
//轮播图

import UIKit

class ZJCircleView: UIView {
    
    let scrollView: UIScrollView!
    let pageControl: UIPageControl!
    var imageNames : Array<Any>

    override init(frame: CGRect) {
        pageControl = UIPageControl()
        scrollView = UIScrollView()
        imageNames = []
        super.init(frame: frame)
        
        scrollView.frame = self.bounds
        scrollView.backgroundColor = UIColor.blue
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.delegate = self
        scrollView.bounces = false
        self.addSubview(scrollView)
        
    }
    
    func setImageNames(images:Array<Any>) {
        
        imageNames = images
        
        if imageNames.count > 0 {
            
            let first = imageNames.first
            let last = imageNames.last
            imageNames.insert(last! , at: 0)
            imageNames.append(first!)

            pageControl.frame = CGRect(x: (self.frameW-150)/2.0, y: self.frameH-50, width: 150, height: 50)
            self.addSubview(pageControl)
            pageControl.numberOfPages = imageNames.count-2
            pageControl.currentPageIndicatorTintColor = UIColor.blue
            pageControl.pageIndicatorTintColor = UIColor.black
            pageControl.addTarget(self, action: #selector(pageChange), for: .valueChanged)
            
            for i in 0..<imageNames.count {
                let imageView = UIImageView(frame: CGRect(x: CGFloat(i)*self.frameW, y: 0.0, width: self.frameW, height: self.frameH))
                scrollView.addSubview(imageView)
                
                let sub = imageNames[i]

                if sub is String{
                    let image = UIImage(named: imageNames[i] as! String)
                    imageView.image = image
                }
                if sub is UIImage{
                    imageView.image = sub as? UIImage
                }
 
            }
            scrollView.contentSize = CGSize(width: self.frameW * CGFloat(imageNames.count), height: 0);
            scrollView.setContentOffset(CGPoint(x: self.frameW, y: 0), animated: false)
        }
        
    }
    
    @objc func pageChange(pageControl:UIPageControl) {
        scrollView.setContentOffset(CGPoint(x: self.frameW * CGFloat(pageControl.currentPage), y: 0), animated: false)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ZJCircleView: UIScrollViewDelegate {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        var pageNo = scrollView.contentOffset.x/self.frameW
  
        
        if Int(pageNo) == imageNames.count - 1 {
            scrollView.setContentOffset(CGPoint(x: self.frameW, y: 0), animated: false)
            
            pageNo = 0

        }else if Int(pageNo) == 0 {
             scrollView.setContentOffset(CGPoint(x: self.frameW * CGFloat(imageNames.count - 2), y: 0), animated: false)
            
            pageNo = CGFloat(imageNames.count - 3)

        }else{
            
            pageNo -= 1

        }

        pageControl.currentPage = Int(pageNo)
        
    }
    
}

//
//  ZJCircleView.swift
//  InfoAPP
//
//  Created by leeco on 2019/5/17.
//  Copyright © 2019 zsw. All rights reserved.
//轮播图

import UIKit


public protocol ZJCircleViewDelegate: NSObjectProtocol {
    func circleViewClick(clickAtIndex:Int);
}

class ZJCircleView: UIView {
    
    let scrollView: UIScrollView!
    let pageControl: UIPageControl!
    var pageNo = 0// 0 1 2 3 ....
    var imageNames : Array<Any>
    var titles =  [String]()
    var timer: Timer?
    
    weak open var delegate: ZJCircleViewDelegate?
    
    
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
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))
        scrollView.addGestureRecognizer(tapGesture)

        timer = Timer(timeInterval: 1.5, target: self, selector: #selector(forTimer), userInfo: nil, repeats: true)
        RunLoop.current.add(timer!, forMode: .default)

    }
    @objc func forTimer(timer:Timer){

        var pageNo_ = pageNo
        pageNo_ += 1
        if pageNo_ == imageNames.count - 1 {
            scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
            pageNo_ = 0
        }
        pageNo_ += 1
        scrollView.setContentOffset(CGPoint(x:self.frameW * CGFloat(pageNo_), y: 0), animated: true)
        pageNo = pageNo_ - 1
        print("--\(pageNo)--")
        pageControl.currentPage = pageNo
  
    }
    @objc func handleTap(sender : UIGestureRecognizer) {
        let point = sender.location(in: scrollView)
        let pageIndex = Int(point.x/self.frameW) - 1
        delegate?.circleViewClick(clickAtIndex: pageIndex)
    }
    func setImageNames(images:Array<Any>) {
        
        imageNames = images
        
        if imageNames.count > 0 {

            let last = imageNames.last
            imageNames.insert(last! , at: 0)

            pageControl.frame = CGRect(x: (self.frameW-150)/2.0, y: self.frameH-50, width: 150, height: 50)
            self.addSubview(pageControl)
            pageControl.numberOfPages = imageNames.count-1
            pageControl.currentPageIndicatorTintColor = UIColor.blue
            pageControl.pageIndicatorTintColor = UIColor.black
            pageControl.addTarget(self, action: #selector(pageChange), for: .valueChanged)

            let lastTitle = titles.last
            titles.insert(lastTitle! , at: 0)

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
 
                //title
                let titleLabel = UILabel(frame: CGRect(x: CGFloat(i)*self.frameW, y: self.frameH - 30, width: self.frameW, height: 30))
                titleLabel.textAlignment = .right
                scrollView.addSubview(titleLabel)
                titleLabel.text = titles[i]
                
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
        
        pageNo = Int(scrollView.contentOffset.x/self.frameW)
        if pageNo == imageNames.count - 1  {
            scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
            pageNo -= 1
        }else if pageNo == 0 {
            scrollView.setContentOffset(CGPoint(x: self.frameW * CGFloat(imageNames.count - 1), y: 0), animated: false)
            pageNo = imageNames.count - 2
        }else{
            pageNo -= 1
        }
        pageControl.currentPage = pageNo
        print("--\(pageNo)--")
    }
    
}

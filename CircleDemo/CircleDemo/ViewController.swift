//
//  ViewController.swift
//  CircleDemo
//
//  Created by leeco on 2019/5/17.
//  Copyright © 2019 zsw. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let circle = ZJCircleView(frame: CGRect(x: 0, y: 88, width: KSCREEN_WIDTH, height: 300))
        circle.titles = ["lotus0","lotus1","lotus2","lotus3"]
        circle.setImageNames(images: ["lotus0","lotus1","lotus2","lotus3"])
        circle.delegate = self
        self.view.addSubview(circle)

    }
}

extension ViewController: ZJCircleViewDelegate {
    func circleViewClick(clickAtIndex: Int) {
        print("click index is \(clickAtIndex)")
    }
}

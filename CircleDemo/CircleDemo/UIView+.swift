//
//  UIView+.swift
//  InfoAPP
//
//  Created by leeco on 2019/5/14.
//  Copyright © 2019 zsw. All rights reserved.
//

import UIKit
extension UIView {
    var frameX : CGFloat {
        get {
            return frame.origin.x
        }
        set(newVal) {
            var temFrame: CGRect = frame
            temFrame.origin.x = newVal
            frame = temFrame
        }
    }
    var frameY : CGFloat {
        get {
            return frame.origin.y
        }
        set(newVal) {
            var temFrame: CGRect = frame
            temFrame.origin.y = newVal
            frame = temFrame
        }
    }
    var frameW : CGFloat {
        get {
            return frame.size.width
        }
        set(newVal) {
            var temFrame: CGRect = frame
            temFrame.size.width = newVal
            frame = temFrame
        }
    }
    var frameH : CGFloat {
        get {
            return frame.size.height
        }
        set(newVal) {
            var temFrame: CGRect = frame
            temFrame.size.height = newVal
            frame = temFrame
        }
    }
}

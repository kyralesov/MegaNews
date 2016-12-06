//
//  UIView+Extension.swift
//  MegaNews
//
//  Created by Eugene Kurilenko on 12/6/16.
//  Copyright © 2016 Eugene Kurilenko. All rights reserved.
//

import Foundation
import UIKit.UIView


extension UIRefreshControl {
    func beginRefreshingManually() {
        if let scrollView = superview as? UIScrollView {
            scrollView.setContentOffset(CGPoint(x: 0, y: scrollView.contentOffset.y - frame.height), animated: true)
        }
        beginRefreshing()
        sendActions(for: .valueChanged)
    }
}

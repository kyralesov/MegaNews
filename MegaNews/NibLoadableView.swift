//
//  NibLoadableView.swift
//  MegaNews
//
//  Created by Eugene Kurilenko on 11/19/16.
//  Copyright © 2016 Eugene Kurilenko. All rights reserved.
//

import Foundation
import UIKit


protocol NibLoadableView: class {
    static var nibName: String { get }
    static var defaultReuseIdentifier: String { get }
}

extension NibLoadableView where Self: UIView {
    static var nibName: String {
        return String(describing: self)
    }
    static var defaultReuseIdentifier: String {
        return String(describing: self)
    }
}

//
//  Array+Extension.swift
//  MegaNews
//
//  Created by Eugene Kurilenko on 12/1/16.
//  Copyright © 2016 Eugene Kurilenko. All rights reserved.
//

import Foundation

extension Array where Element: Equatable {
    
    // Remove first collection element that is equal to the given `object`:
    mutating func remove(object: Element) {
        if let index = index(of: object) {
            remove(at: index)
        }
    }
}

extension Array where Element: Articleable{
    
     func sortArticles() -> [Element] {
        return sorted {
            $0.publishedAt ?? Date() > $1.publishedAt ?? Date()
        }
    }
    
}

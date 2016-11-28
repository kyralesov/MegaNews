//
//  SynchronizedArray.swift
//  MegaNews
//
//  Created by Eugene Kurilenko on 11/25/16.
//  Copyright © 2016 Eugene Kurilenko. All rights reserved.
//

import Foundation

public class SynchronizedArray<T> {
    private var array: [T] = []
    private let accessQueue = DispatchQueue(label: "SynchronizedArrayAccess", attributes: .concurrent)
    
    public func append(newElement: T) {
        
        self.accessQueue.async(flags:.barrier) {
            self.array.append(newElement)
        }
    }
    
    public func removeAtIndex(index: Int) {
        
        self.accessQueue.async(flags:.barrier) {
            self.array.remove(at: index)
        }
    }
    
    public var count: Int {
        var count = 0
        
        self.accessQueue.sync {
            count = self.array.count
        }
        
        return count
    }
    
    public func first() -> T? {
        var element: T?
        
        self.accessQueue.sync {
            if !self.array.isEmpty {
                element = self.array[0]
            }
        }
        
        return element
    }
    
    public subscript(index: Int) -> T {
        set {
            self.accessQueue.async(flags:.barrier) {
                self.array[index] = newValue
            }
        }
        get {
            var element: T!
            self.accessQueue.sync {
                element = self.array[index]
            }
            
            return element
        }
    }
}

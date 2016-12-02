//
//  SourcesDefaults.swift
//  MegaNews
//
//  Created by Eugene Kurilenko on 12/1/16.
//  Copyright © 2016 Eugene Kurilenko. All rights reserved.
//

import Foundation


struct SourcesDefaults {
    
    private let kSourses =     "SourcesDefaultsAllSoursesKey"
    private let kUserSourses = "SourcesDefaultsUserSoursesKey"
    
    var sources: [Source]? {
        get {
            return getSources(forKey: kSourses)
        }
        set {
            setSources(value: newValue, forKey: kSourses)
        }
    }
    
    var userSources: [Source]? {
        get {
            return getSources(forKey: kUserSourses)
        }
        set {
            setSources(value: newValue, forKey: kUserSourses)
        }
    }
    
    
    // Private
    private func getSources(forKey: String) -> [Source]? {
        guard let dataArray = UserDefaults.standard.object(forKey: forKey) as? [Data] else {return nil}
        let sources = dataArray.map{Source.init(data: $0)!}
        return sources
    }
    
    private mutating func setSources(value: [Source]?, forKey: String) {
        if value != nil {
            let encoded = value!.map{$0.encode()}
            UserDefaults.standard.set(encoded, forKey: forKey)
        } else {
            UserDefaults.standard.removeObject(forKey: forKey)
        }
    }
}


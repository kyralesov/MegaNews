//
//  String+Extension.swift
//  MegaNews
//
//  Created by Eugene Kurilenko on 11/19/16.
//  Copyright © 2016 Eugene Kurilenko. All rights reserved.
//

import Foundation

extension String {
    
    var localTimeFromUTC: String {
        
        let formatSSS = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let formatSS  = "yyyy-MM-dd'T'HH:mm:ss.SSZ"
        let formatS   = "yyyy-MM-dd'T'HH:mm:ss.SZ"
        let format    = "yyyy-MM-dd'T'HH:mm:ssZ"
        
        let dateFormatter =  DateFormatter()
        
        switch self.characters.count {
        case formatSSS.characters.count - 2: // 'T' -> -2
            dateFormatter.dateFormat = formatSSS
        case formatSS.characters.count - 2:
            dateFormatter.dateFormat = formatSS
        case formatS.characters.count - 2:
            dateFormatter.dateFormat = formatS
        default:
            dateFormatter.dateFormat = format
        }

        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        let date = dateFormatter.date(from: self)
        
        dateFormatter.dateFormat = "EEEE, h:mm a" // "EEE, MMM d, yyyy - h:mm a"
        // return the timeZone of your device i.e. America/Los_angeles
        let timeZone = TimeZone.autoupdatingCurrent.identifier as String
        dateFormatter.timeZone = TimeZone(identifier: timeZone)
        return dateFormatter.string(from: date!)
    }
    
}

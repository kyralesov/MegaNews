//
//  String+Extension.swift
//  MegaNews
//
//  Created by Eugene Kurilenko on 11/19/16.
//  Copyright © 2016 Eugene Kurilenko. All rights reserved.
//

import Foundation
import NSDate_TimeAgo

extension String {
    
    var timeAgo: String {
        
        // "yyyy-MM-dd'T'HH:mm:ss.SSSZ" -> "yyyy-MM-dd'T'HH:mm:ssZ"
        var validTimeString: String {
            let components = self.components(separatedBy: ".")
            if components.count == 1 { return self}
            return components[0].appending("Z")
        }
        
        let dateFormatter =  DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let timeZone = TimeZone.autoupdatingCurrent.identifier as String
        dateFormatter.timeZone = TimeZone(identifier: timeZone)
        
        guard let timeInterval = dateFormatter.date(from: validTimeString)?.timeIntervalSince1970 else { return ""}
        
        return NSDate(timeIntervalSince1970: timeInterval).timeAgo() ?? ""
        
    }
    
    
    //    var localTimeFromUTC: String {
    //
    //        let timeString = self.validTimePattern
    //
    //        let dateFormatter =  DateFormatter()
    //        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
    //        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
    //        let date = dateFormatter.date(from: timeString)
    //
    //        dateFormatter.dateFormat = "EEEE, h:mm a" // "EEE, MMM d, yyyy - h:mm a"
    //        // return the timeZone of your device i.e. America/Los_angeles
    //        let timeZone = TimeZone.autoupdatingCurrent.identifier as String
    //        dateFormatter.timeZone = TimeZone(identifier: timeZone)
    //        return dateFormatter.string(from: date!)
    //    }
    
    
    
}

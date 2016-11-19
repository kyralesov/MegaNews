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
        let dateFormatter =  DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        let date = dateFormatter.date(from: self)
        
        dateFormatter.dateFormat = "EEE, MMM d, yyyy - h:mm a"
        // return the timeZone of your device i.e. America/Los_angeles
        let timeZone = TimeZone.autoupdatingCurrent.identifier as String
        dateFormatter.timeZone = TimeZone(identifier: timeZone)
        return dateFormatter.string(from: date!)
    }
}

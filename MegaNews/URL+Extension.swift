//
//  URL+Extension.swift
//  MegaNews
//
//  Created by Eugene Kurilenko on 11/19/16.
//  Copyright © 2016 Eugene Kurilenko. All rights reserved.
//

import Foundation

extension URL {
    var hostWithoutWWW: String? {
        var components = self.host?.components(separatedBy: ".")
        if components?.first == "www" {
            components!.removeFirst()
            return components!.joined(separator: ".")
        }
        return self.host
    }
}

//
//  Source.swift
//  MegaNews
//
//  Created by Eugene Kurilenko on 11/19/16.
//  Copyright © 2016 Eugene Kurilenko. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Source {
    
    let id: String
    let name: String
    let description: String
    let url: URL
    let category: String // business, entertainment, gaming, general, music, science-and-nature, sport, technology
    let language: String // en, de, fr
    let country: String  // au, de, gb, in, it, us
    let logoSmall: URL
    let logoMedium: URL
    let logoLarge: URL
    let sortBysAvailable: [String] // top, latest, popular
    
    init?(_ json: JSON) {
        guard
            let id = json["id"].string,
            let name = json["name"].string,
            let description = json["description"].string,
            let urlString = json["url"].string,
            let category = json["category"].string,
            let language = json["language"].string,
            let country = json["country"].string,
            let urlsToLogos = json["urlsToLogos"].dictionaryObject,
            let sortBysAvailable = json["sortBysAvailable"].arrayObject
        else { return nil }
        
        self.id = id
        self.name = name
        self.description = description
        self.url = URL(string: urlString)!
        self.category = category
        self.language = language
        self.country = country
        self.logoSmall = URL(string: urlsToLogos["small"] as! String)!
        self.logoMedium = URL(string: urlsToLogos["medium"] as! String)!
        self.logoLarge = URL(string: urlsToLogos["large"] as! String)!
        self.sortBysAvailable = sortBysAvailable as! [String]
    }
    
    
}


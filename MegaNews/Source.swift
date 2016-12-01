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
    let host: String?
    let url: URL?
    let category: String // business, entertainment, gaming, general, music, science-and-nature, sport, technology
    let language: String // en, de, fr
    let country: String  // au, de, gb, in, it, us
    let logoSmall: URL?
    let logoMedium: URL?
    let logoLarge: URL?
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
        self.url = URL(string: urlString)
        self.host = self.url?.hostWithoutWWW
        self.category = category
        self.language = language
        self.country = country
        self.logoSmall = URL(string: urlsToLogos["small"] as! String)
        self.logoMedium = URL(string: urlsToLogos["medium"] as! String)
        self.logoLarge = URL(string: urlsToLogos["large"] as! String)
        self.sortBysAvailable = sortBysAvailable as! [String]
    }
    
    
}

extension Source {
    
    init?(data: Data) {
        if let coding = NSKeyedUnarchiver.unarchiveObject(with: data as Data) as? Encoding{
           id = coding.id
           name = coding.name
           description = coding.sourceDescription
            host = coding.host
            url = coding.url
            category = coding.category
            language = coding.language
            country = coding.country
            logoSmall = coding.logoSmall
            logoMedium = coding.logoMedium
            logoLarge = coding.logoLarge
            sortBysAvailable = coding.sortBysAvailable       
        } else {
            return nil
        }
    }
    
    func encode() -> Data {
        return NSKeyedArchiver.archivedData(withRootObject: Encoding(self)) as Data
    }
    
    private class Encoding: NSObject, NSCoding {
        let id: String
        let name: String
        let sourceDescription: String
        let host: String?
        let url: URL?
        let category: String
        let language: String
        let country: String
        let logoSmall: URL?
        let logoMedium: URL?
        let logoLarge: URL?
        let sortBysAvailable: [String]
        
        init(_ Source: Source) {
            id = Source.id
            name = Source.name
            sourceDescription = Source.description
            host = Source.host
            url = Source.url
            category = Source.category
            language = Source.language
            country = Source.country
            logoSmall = Source.logoSmall
            logoMedium = Source.logoMedium
            logoLarge = Source.logoLarge
            sortBysAvailable = Source.sortBysAvailable
        }
        
        public required init?(coder aDecoder: NSCoder) {
            guard
                let id = aDecoder.decodeObject(forKey: "id") as? String,
                let name = aDecoder.decodeObject(forKey: "name") as? String,
                let sourceDescription = aDecoder.decodeObject(forKey: "sourceDescription") as? String,
                let category = aDecoder.decodeObject(forKey: "category") as? String,
                let language = aDecoder.decodeObject(forKey: "language") as? String,
                let country = aDecoder.decodeObject(forKey: "country") as? String,
                let sortBysAvailable = aDecoder.decodeObject(forKey: "sortBysAvailable") as? [String]
            else {
                    return nil
            }
            
            self.id = id
            self.name = name
            self.sourceDescription = sourceDescription
            self.host = aDecoder.decodeObject(forKey: "host") as? String
            self.url = aDecoder.decodeObject(forKey: "url") as? URL
            self.category = category
            self.language = language
            self.country = country
            self.logoSmall = aDecoder.decodeObject(forKey: "logoSmall") as? URL
            self.logoMedium = aDecoder.decodeObject(forKey: "logoMedium") as? URL
            self.logoLarge = aDecoder.decodeObject(forKey: "logoLarge") as? URL
            self.sortBysAvailable = sortBysAvailable
        }
        
        public func encode(with aCoder: NSCoder) {
            aCoder.encode(id, forKey: "id")
            aCoder.encode(name, forKey: "name")
            aCoder.encode(sourceDescription, forKey: "sourceDescription")
            aCoder.encode(host, forKey: "host")
            aCoder.encode(url, forKey: "url")
            aCoder.encode(category, forKey: "category")
            aCoder.encode(language, forKey: "language")
            aCoder.encode(country, forKey: "country")
            aCoder.encode(logoSmall, forKey: "logoSmall")
            aCoder.encode(logoMedium, forKey: "logoMedium")
            aCoder.encode(logoLarge, forKey: "logoLarge")
            aCoder.encode(sortBysAvailable, forKey: "sortBysAvailable")
  
        }
    }
    
    
}

extension Source: Equatable {
    public static func ==(lhs: Source, rhs: Source) -> Bool {
        return lhs.id == rhs.id
    }
}

extension Source: Hashable {
    var hashValue: Int {
        return id.hashValue
    }
}


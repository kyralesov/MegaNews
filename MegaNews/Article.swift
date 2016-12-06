//
//  Article.swift
//  MegaNews
//
//  Created by Eugene Kurilenko on 11/19/16.
//  Copyright © 2016 Eugene Kurilenko. All rights reserved.
//

import Foundation
import SwiftyJSON

protocol Articleable {
    var author: String { get }
    var description: String { get }
    var title: String { get }
    var url: URL? { get }
    var urlToImage: URL? { get }
    var publishedAt: Date? { get }
    var publishedTimeAgo: String { get }
}

struct Article: Articleable {
    
    let author: String
    let description: String
    let title: String
    let url: URL?
    let urlToImage: URL?
    let publishedAt: Date?
    let publishedTimeAgo: String
    
    init?(_ json: JSON) {
        guard
            let author = json["author"].string,
            let description = json["description"].string,
            let title = json["title"].string,
            let url = json["url"].string,
            let urlToImage = json["urlToImage"].string,
            let publishedAt = json["publishedAt"].string
        else { return nil }
        
        self.author = author
        self.description = description
        self.title = title
        self.url = URL(string: url)
        self.urlToImage = URL(string: urlToImage)
        self.publishedAt = publishedAt.toPublished
        self.publishedTimeAgo = publishedAt.toTimeAgo
    }
}

extension Article: Hashable {
    var hashValue: Int {
        return description.hashValue
    }
}

extension Article: Equatable {
    public static func ==(lhs: Article, rhs: Article) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
}

//
//  Article.swift
//  MegaNews
//
//  Created by Eugene Kurilenko on 11/19/16.
//  Copyright © 2016 Eugene Kurilenko. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Article {
    
    let author: String
    let description: String
    let title: String
    let url: URL?
    let urlToImage: URL?
    let publishedAt: String
    
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
        self.publishedAt = publishedAt.timeAgo
    }
}

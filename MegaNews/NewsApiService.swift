//
//  NewsApiService.swift
//  MegaNews
//
//  Created by Eugene Kurilenko on 11/19/16.
//  Copyright © 2016 Eugene Kurilenko. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireImage
import SwiftyJSON

protocol TargetType {
    var baseURL: URL { get }
    var path: String { get }
    var url: URL { get }
    var method: HTTPMethod { get }
    var parameters: [String: Any]? { get }
}

enum Router {
    case articles(source: String, sortBy: String?)
    case sources(category: String?, language:String?, country: String?)
}

extension Router: TargetType {
    
    var baseURL: URL { return URL(string: "https://newsapi.org")!}
    
    var path: String {
        switch self {
        case .articles:
            return "/v1/articles"
        case .sources:
            return "/v1/sources"
        }
    }
    
    var url: URL {
        return baseURL.appendingPathComponent(path)
    }
    
    var method: HTTPMethod {
        switch self {
        case .articles, .sources:
            return .get
        }
    }
    
    var parameters: [String : Any]? {
        var param: [String: Any] = [
            "apiKey":"f4c16774500c434a9a1b60bf0f7165b2"
        ]
        switch self {
        case let .sources(category, language, country):
            param["category"] = category ?? ""
            param["language"] = language ?? "en"
            param["country"] = country ?? ""
        case let .articles(source, sortBy):
            param["source"] = source
            param["sortBy"] = sortBy ?? "top"
        }
        return param
    }
}

class NewsApiService {
    
    static let shared = NewsApiService()
    
    
    public func request(router: Router, completion: @escaping ([Any]?)->Void ) {
        
        Alamofire.request(router.url, method: router.method, parameters: router.parameters)
            .responseJSON { (response) in
                switch response.result {
                case .success(let data):
                    let json = JSON(data)
                    
                    switch router {
                    case .sources:
                        guard let soursesData = json["sources"].array
                            else {
                                completion(nil)
                                return
                        }
                        
                        let sources = soursesData.flatMap(Source.init)
                        completion(sources)
                        
                    case .articles:
                        guard let articlesData = json["articles"].array
                            else {
                                completion(nil)
                                return
                        }
                        let articles = articlesData.flatMap(Article.init)
                        completion(articles)
                    }
                    
                case .failure(let error):
                    #if DEBUG
                        completion(nil)
                        fatalError(error.localizedDescription)
                    #else
                        completion(nil)
                    #endif
                }
        }
        
    }
    
    func fetchSources(completion: @escaping ([Source]?)->Void) {
        
        if let localSources = SourcesDefaults().sources {
            completion(localSources)
        }
        // check sources with localSources
        
        
        NewsApiService.shared.request(router: .sources(category: nil,
                                                       language: nil,
                                                       country: nil))
        { (data) in
            if let sources = data as? [Source] {
                let local = SourcesDefaults().sources
                if local == nil || sources != local! {

                    // Set sourses to SourcesDefaults
                    var sourcesDefaults = SourcesDefaults()
                    sourcesDefaults.sources = sources
                    
                    completion(sources)
                }
                
            }
        }
        
    }
    
    private let accessQueue = DispatchQueue(label: "SynchronizedArrayAccess", attributes: .concurrent)
    private var articles = [Article]()
    private var count = 0

    func fetchArticlesFor(sources: [Source], completion: @escaping ([Article]?)->Void) {
        
        
        for source in sources {
            self.request(router: .articles(source: source.id, sortBy: nil ))
            {[unowned self] (data) in
                self.accessQueue.async(flags:.barrier) {
                    if let articles = data as? Array<Article> {
                        self.articles += articles
                        
                        self.count += 1
                        if self.count == sources.count {
                            completion(self.articles)
                            self.count = 0
                            self.articles.removeAll()
                        }
                        
                    }
                }
            }
            
        }
    }
    
    
    
}

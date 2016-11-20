//
//  NewsArticleCell.swift
//  MegaNews
//
//  Created by Eugene Kurilenko on 11/20/16.
//  Copyright © 2016 Eugene Kurilenko. All rights reserved.
//

import UIKit

import AlamofireImage

class NewsArticleCell: UITableViewCell, NibLoadableView {
    
    //MARK: Dependency
    
    let imageCache = AutoPurgingImageCache()
    
    //MARK: Model
    
    var article: Article? {
        didSet {
            updateUI()

        }
    }
    
    //MARK: Outlets
    
    @IBOutlet weak var articleImageView: UIImageView!
    @IBOutlet weak var articleLable: UILabel!
    @IBOutlet weak var articleTimeLable: UILabel!
    @IBOutlet weak var articleHostLable: UILabel!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    internal var articleImage: UIImage? {
        get {
            return articleImageView.image
        }
        set {
            articleImageView.image = newValue
            spinner.stopAnimating()
        }
    }
    
    func updateUI() {
        articleImageView.image = nil
        articleLable.text = nil
        articleTimeLable.text = nil
        articleHostLable.text = nil
        
        if let article = self.article {
            setArticleImageView(article)
            articleLable.text = article.description
            articleTimeLable.text = article.publishedAt
        }

    }
    
    func setArticleImageView(_ article: Article) {
        
        if let articleImageURL = article.urlToImage {
            spinner.startAnimating()
            
            let cachedImage = imageCache.image(withIdentifier: articleImageURL.lastPathComponent)
            guard cachedImage == nil else {
                articleImage = cachedImage
                return
            }
            
            NewsApiService.shared.getImage(articleImageURL) {[unowned self] (imageData) in
                DispatchQueue.main.async {
                    
                    if articleImageURL == article.urlToImage {
                        if let image = imageData {
                            self.articleImage = image
                            self.imageCache.add(image, withIdentifier: articleImageURL.lastPathComponent)
                        }
                        
                    }
                    
                }
            }
            
        }
        
    }
    
}

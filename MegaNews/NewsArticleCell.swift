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

    
    //MARK: Outlets
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var descriptionLable: UILabel!
    @IBOutlet weak var timeLable: UILabel!
    @IBOutlet weak var linkLable: UILabel!
    
    func configureCell(_ article: Article, placeholderImage: UIImage) {
        
        descriptionLable.text = article.description
        timeLable.text = article.publishedTimeAgo
        linkLable.text = article.url?.hostWithoutWWW
        
        let size = imgView.bounds.size
        
        imgView.af_setImage(
            withURL: article.urlToImage!,
            placeholderImage: placeholderImage,
            filter: AspectScaledToFillSizeFilter(size: size),
            progress: nil,
            progressQueue: DispatchQueue.global(qos: .default),
            imageTransition: .noTransition,
            runImageTransitionIfCached: false,
            completion: nil
        )
    }
    
    override func prepareForReuse() {
        imgView.af_cancelImageRequest()
        imgView.layer.removeAllAnimations()
        imgView.image = nil
        
        descriptionLable.text = nil
        timeLable.text = nil
        linkLable.text = nil
        
    }

    
}

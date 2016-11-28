//
//  NewsSourceCell.swift
//  MegaNews
//
//  Created by Eugene Kurilenko on 11/19/16.
//  Copyright © 2016 Eugene Kurilenko. All rights reserved.
//

import UIKit
import AlamofireImage

class NewsSourceCell: UITableViewCell, NibLoadableView {
    
    
    //MARK: Outlets

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var nameLable: UILabel!
    @IBOutlet weak var linkLable: UILabel!
    
    
    func configureCell(_ source: Source, placeholderImage: UIImage) {
        
        nameLable.text = source.name
        linkLable.text = source.host
        
        let size = imgView.bounds.size
        
        if let imageURL = source.logoSmall {
            imgView.af_setImage(
                withURL: imageURL,
                placeholderImage: placeholderImage,
                filter: AspectScaledToFitSizeFilter(size: size),
                progress: nil,
                progressQueue: DispatchQueue.global(qos: .default),
                imageTransition: .noTransition,
                runImageTransitionIfCached: false,
                completion: nil
            )
        }
        
    }
    
    override func prepareForReuse() {
        imgView.af_cancelImageRequest()
        imgView.layer.removeAllAnimations()
        imgView.image = nil
        
        nameLable.text = nil
        linkLable.text = nil
    }
    
}

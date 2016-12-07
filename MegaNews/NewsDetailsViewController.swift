//
//  NewsDetailsViewController.swift
//  MegaNews
//
//  Created by Eugene Kurilenko on 12/6/16.
//  Copyright © 2016 Eugene Kurilenko. All rights reserved.
//

import UIKit
import AlamofireImage

class NewsDetailsViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var siteLabel: UILabel!
    @IBOutlet weak var articleImageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var articleLinkButton: UIButton!
    
    
    @IBAction func goToAction(_ sender: UIButton) {
        performSegue(withIdentifier: Storyboard.showURLSegue, sender: sender)
    }
    

    var article: Article?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        titleLabel?.text = article?.title
        timeLabel?.text = article?.publishedTimeAgo
        siteLabel.text = article?.url?.hostWithoutWWW
        descriptionLabel?.text = article?.description
        
        if let imageURL = article?.urlToImage {
            let size = articleImageView.bounds.size

            articleImageView.af_setImage(
                withURL: imageURL,
                placeholderImage: UIImage(),
                filter: AspectScaledToFillSizeFilter(size: size),
                progress: nil,
                progressQueue: DispatchQueue.global(qos: .default),
                imageTransition: .crossDissolve(0.5),
                runImageTransitionIfCached: true,
                completion: nil
            )
        }

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Storyboard.showURLSegue {
            let vc = segue.destination as! WebViewController
            let btn = sender as! UIButton
            switch btn.tag {
            case 1:
                vc.url = article?.url
            default:
                break
            }
        }
    }


}

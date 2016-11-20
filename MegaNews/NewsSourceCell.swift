//
//  NewsSourceCell.swift
//  MegaNews
//
//  Created by Eugene Kurilenko on 11/19/16.
//  Copyright © 2016 Eugene Kurilenko. All rights reserved.
//

import UIKit

class NewsSourceCell: UITableViewCell, NibLoadableView {
    
    //MARK: Model
    
    var source: Source? {
        didSet {
            fetchImage((source?.logoSmall)!)
            sourceNameLable.text = source?.name
            sourceLinkLable.text = source?.host
        }
    }
    
    //MARK: Outlets

    @IBOutlet weak var sourceImageView: UIImageView!
    @IBOutlet weak var sourceNameLable: UILabel!
    @IBOutlet weak var sourceLinkLable: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func fetchImage(_ url: URL) {
        NewsApiService.shared.getImage(url) {[unowned self] (image) in
            DispatchQueue.main.async {
                self.sourceImageView.image = image
            }
        }
    }
    
}

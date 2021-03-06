//
//  NewsSourceSettingsCell.swift
//  MegaNews
//
//  Created by Eugene Kurilenko on 12/2/16.
//  Copyright © 2016 Eugene Kurilenko. All rights reserved.
//

import UIKit

class NewsSourceSettingsCell: UITableViewCell, NibLoadableView {
    
    @IBOutlet weak var nameLable: UILabel!
    @IBOutlet weak var siteLable: UILabel!
    
    
    func configureCell(_ source: Source) {
        
        nameLable.text = source.name
        siteLable.text = source.host
 
    }
    
    override func prepareForReuse() {
        nameLable.text = nil
        siteLable.text = nil
    }
    
    
    
}

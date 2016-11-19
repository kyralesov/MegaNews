//
//  LeftViewController.swift
//  MegaNews
//
//  Created by Eugene Kurilenko on 11/18/16.
//  Copyright © 2016 Eugene Kurilenko. All rights reserved.
//

import UIKit

class LeftViewController: UIViewController {

    //MARK: Model    
    var sources: [Source]? {
        didSet {
            
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.evo_drawerController?.setMaximumLeftDrawerWidth(320, animated: true, completion: nil)
        
        //sources
        fetchNewsSources()
  
        
    }

    
    
    //MARK: - Private
    private func fetchNewsSources() {
        NewsApiService.shared.request(router: .sources(category: nil,
                                                       language: nil,
                                                       country: nil))
        {[unowned self] (data) in
            self.sources = data as? [Source]
        }
    }
    

}

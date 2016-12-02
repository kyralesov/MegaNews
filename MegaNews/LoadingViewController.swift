//
//  LoadingViewController.swift
//  MegaNews
//
//  Created by Eugene Kurilenko on 12/2/16.
//  Copyright © 2016 Eugene Kurilenko. All rights reserved.
//

import UIKit

protocol LoadingViewControllerDelegate: NSObjectProtocol {
    func loadingView(controller: LoadingViewController, didSources: [Source]?)
}

class LoadingViewController: UIViewController {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    //MARK: Delegate
    weak var delegate: LoadingViewControllerDelegate?
    
    
    var sources: [Source]?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    private func fetchNewsSources(completion: @escaping ([Source]?)->Void) {
        //Fetch Local News Sourses
        if let localSources = SourcesDefaults().sources {
            updateSources(local: localSources, completion: { (sources) in
                completion(sources)
            })
            completion(localSources)
        }

        
        
    }
    
    private func updateSources(local: [Source]?, completion: @escaping ([Source]?)->Void) {
        
        NewsApiService.shared.request(router: .sources(category: nil,
                                                       language: nil,
                                                       country: nil))
        {(data) in
            if let sources = data as? [Source] {
                //
                if local == nil || sources != local! {
                    // Set sourses to SourcesDefaults
                    var sourcesDefaults = SourcesDefaults()
                    sourcesDefaults.sources = sources
                    completion(sources)
                }
                
            }
        }
    }
    
    

}

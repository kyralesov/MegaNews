//
//  WebViewController.swift
//  MegaNews
//
//  Created by Eugene Kurilenko on 12/6/16.
//  Copyright © 2016 Eugene Kurilenko. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController {
    
    var webView: WKWebView
    
    @IBOutlet weak var progressView: UIProgressView!
    
    var url: URL?
    
    required init?(coder aDecoder: NSCoder) {
        self.webView = WKWebView(frame: CGRect.zero)
        super.init(coder: aDecoder)
        
        webView.navigationDelegate = self
    }
    
    deinit {
        webView.removeObserver(self, forKeyPath: "estimatedProgress")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        view.insertSubview(webView, belowSubview: progressView)
        
        webView.translatesAutoresizingMaskIntoConstraints = false
        let height = NSLayoutConstraint(item: webView,
                                        attribute: .height,
                                        relatedBy: .equal,
                                        toItem: view,
                                        attribute: .height,
                                        multiplier: 1,
                                        constant: 0)
        let width = NSLayoutConstraint(item: webView,
                                        attribute: .width,
                                        relatedBy: .equal,
                                        toItem: view,
                                        attribute: .width,
                                        multiplier: 1,
                                        constant: 0)
        view.addConstraints([height, width])
        
        webView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
        
        // clearing of cache
        URLCache.shared.removeAllCachedResponses()
        URLCache.shared.diskCapacity = 0
        URLCache.shared.memoryCapacity = 0
        
        if let url = url {
            let request = URLRequest(url: url)
            webView.load(request)
        }
        
        
      
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if keyPath == "estimatedProgress" {
            progressView.isHidden = webView.estimatedProgress == 1
            progressView.setProgress(Float(webView.estimatedProgress), animated: true)
        }
    }

}

extension WebViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        progressView.setProgress(0.0, animated: false)
    }
}

//
//  NewsViewController.swift
//  MegaNews
//
//  Created by Eugene Kurilenko on 11/16/16.
//  Copyright © 2016 Eugene Kurilenko. All rights reserved.
//

import UIKit
import DrawerController

class NewsViewController: UIViewController {
    
    
    //MARK: Model
    
    var source: Source? {
        didSet {
            fetchNews(forSource: source!.id)
        }
    }
    
    var articles: [Article]? {
        didSet {
            tableView.reloadData()
        }
    }
    
    
    lazy var placeholderImage: UIImage = {
        let image = UIImage(named: "Placeholder News")!
        return image
    }()
    
    //MARK: Outlets
    
    @IBOutlet weak var tableView: UITableView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLeftMenuButton()
        
        // register cell
        tableView.register(UINib(nibName: NewsArticleCell.nibName, bundle: nil),
                           forCellReuseIdentifier: NewsArticleCell.defaultReuseIdentifier)
        tableView.estimatedRowHeight = 101
        
    }
    
    
    func setupLeftMenuButton() {
        let leftDrawerButton = DrawerBarButtonItem(target: self,
                                                   action: #selector(leftDrawerButtonPress(_:)),
                                                   menuIconColor: #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1))
        
        self.navigationItem.setLeftBarButton(leftDrawerButton, animated: true)
    }
    
    
    // MARK: - Button Handlers
    
    func leftDrawerButtonPress(_ sender: AnyObject?) {

        self.evo_drawerController?.toggleLeftDrawerSide(animated: true, completion: nil)
    }
    
    
    func fetchNews(forSource id: String) {
        NewsApiService.shared.request(router: .articles(source: id, sortBy: nil),
                                      completion: {[unowned self] (data) in
                self.articles = data as? [Article]
        
        })
    }


}

extension NewsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NewsArticleCell.defaultReuseIdentifier,
                                                 for: indexPath) as! NewsArticleCell
        
        let article = self.articles?[indexPath.row]
        
        cell.configureCell(article!, placeholderImage: placeholderImage)
        
        return cell
    }
}

extension NewsViewController: UITableViewDelegate {
    
}


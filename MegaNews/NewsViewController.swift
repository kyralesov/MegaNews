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
    
    //MARK: Outlets
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: Model
    
    var sources: [Source]? {
        didSet {
            
            if let sources = sources {
                NewsApiService.shared.fetchArticlesFor(sources: sources, completion: {
                    [unowned self] (articles) in
                        self.articles = articles?.uniqueElements.sortArticles()
                })
            }
        }
    }
    
    var articles: [Article]? {
        didSet {
            if tableView != nil {
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }      
        }
    }
    
    
    lazy var placeholderImage: UIImage = {
        let image = UIImage(named: "Placeholder News")!
        return image
    }()
    
    
    var refreshControll: UIRefreshControl!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "News"
        navigationController?.navigationBar.barTintColor = UIColor.white
        
        //Notifications
        
        let nc = NotificationCenter.default
        nc.addObserver(self,
                       selector: #selector(catchNotification(_:)),
                       name: MyNotification.userSourcesNotification,
                       object: nil)
        
        
        setupLeftMenuButton()
        
        // register cell
        tableView.register(UINib(nibName: NewsArticleCell.nibName, bundle: nil),
                           forCellReuseIdentifier: NewsArticleCell.defaultReuseIdentifier)
        tableView.estimatedRowHeight = 101
        
        refreshControll = UIRefreshControl()
        refreshControll.addTarget(self, action: #selector(refresh), for: .valueChanged)
        tableView.addSubview(refreshControll)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    deinit {
        let nc = NotificationCenter.default
        nc.removeObserver(self)
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
    
    // MARK: - Private Methods
    
    func refresh() {
        
        if let sources = self.sources {
            NewsApiService.shared.fetchArticlesFor(sources: sources) {
                [unowned self] articles in
                self.articles = articles?.uniqueElements.sortArticles()
                
                DispatchQueue.main.async { [unowned self] in
                    self.refreshControll.endRefreshing()
                    self.tableView.reloadData()
                }
            }
        }
    
    }
    
    // MaARK: - Notification
    
    func catchNotification(_ notification: Notification) ->Void {
        
        guard let userInfo = notification.userInfo,
            let sources = userInfo["sources"] as? [Source]
            else { return }
        
        self.sources = sources
    }
    
    
    // MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Storyboard.newsDetailsSegue {
            let newsDetailsVC = segue.destination as! NewsDetailsViewController
            let row = (sender as! IndexPath).row
            let article = self.articles?[row]
            newsDetailsVC.article = article
        }
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        performSegue(withIdentifier: Storyboard.newsDetailsSegue, sender: indexPath)
        
        
    }
    
}



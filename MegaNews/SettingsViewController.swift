//
//  SettingsViewController.swift
//  MegaNews
//
//  Created by Eugene Kurilenko on 11/18/16.
//  Copyright © 2016 Eugene Kurilenko. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    
    //dependency
    let defaults = UserDefaults.standard
    

    //MARK: - Model
    var sources: Array<Source>? {
        didSet {
            if let sources = sources {
               fetchAllArticles(sources)
               tableView.reloadData()
            }
          
        }
    }
    
    var articles = [Article]()
    
    private let accessQueue = DispatchQueue(label: "SynchronizedArrayAccess", attributes: .concurrent)
    
    lazy var placeholderImage: UIImage = {
        let image = UIImage(named: "Placeholder News")!
        return image
    }()
    
    
    
    //MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchNewsSources()
        
        // TableView settings
        tableView.estimatedRowHeight = 100
        tableView.register(UINib(nibName: NewsSourceCell.nibName, bundle: nil),
                           forCellReuseIdentifier: NewsSourceCell.defaultReuseIdentifier)
        
        tableView.register(UINib(nibName: SettingsViewHeaderFooterView.nibName, bundle: nil),
                           forHeaderFooterViewReuseIdentifier: SettingsViewHeaderFooterView.defaultReuseIdentifier)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    
        self.navigationController?.view.setNeedsLayout()
        
        self.tableView.reloadSections(IndexSet(integersIn: NSRange(location: 0, length: self.tableView.numberOfSections - 1).toRange() ?? 0..<0), with: .none)

    }
    

    
    
    //MARK: - Private
    
    private func fetchNewsSources() {
        //Fetch News Sourses
        if let dataArray = defaults.object(forKey: UserDefaultsKey.sourses) as? [Data] {
            let sourcesArray = dataArray.map{Source.init(data: $0)!}
            self.sources = sourcesArray
            //check and compare local sources with site sources
            fetchNewsSourcesAndCheck(localSources: sourcesArray)
            
        } else {
            fetchNewsSourcesAndCheck(localSources: nil)
        }
    }
    
    private func fetchNewsSourcesAndCheck(localSources local: [Source]?) {
        NewsApiService.shared.request(router: .sources(category: nil,
                                                       language: nil,
                                                       country: nil))
        {[unowned self] (data) in
            if let sources = data as? [Source] {
                
                if local == nil || sources != local! {
                    self.sources =  sources
                    // Set sourses to UserDefaults
                    let encoded = sources.map{$0.encode()}
                    self.defaults.set(encoded, forKey: UserDefaultsKey.sourses)
                    
                }
               
            }
        }
    }
    
    var count = 0
    private func fetchAllArticles(_ sources: Array<Source>) {
            for source in sources {
                fetchArticles(source, completion: {[unowned self] in
                    print("\(source.name) complited! -> \(self.articles.count)")
                    
                    self.count = self.count + 1
                    if self.count == sources.count {
                        print("DONE!!!")
                        self.count = 0
                    }
                })
            }
    }
    
    private func fetchArticles(_ source: Source, completion: @escaping ()->Void) {
        NewsApiService.shared.request(router: .articles(source: source.id, sortBy: source.sortBysAvailable[0]))
        {[unowned self] (data) in
            self.accessQueue.async(flags:.barrier) {
                if let articles = data as? Array<Article> {
                    self.articles += articles
                    completion()
                }
            }
        }
    }
    
}

//MARK: - UITableViewDataSource
extension SettingsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case 0:
            return 1
        case 1:
            return sources?.count ?? 0
        default:
            return 0
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if indexPath.section == 0 {
            let cell = UITableViewCell(style: .default, reuseIdentifier: "Cell")
            cell.textLabel?.text = "My News"
            return cell
        } else {
        
            let cell = tableView.dequeueReusableCell(
                withIdentifier: NewsSourceCell.defaultReuseIdentifier,
                for: indexPath) as! NewsSourceCell
            
            let source = self.sources?[indexPath.row]
            
            cell.configureCell(source!, placeholderImage: placeholderImage)

            return cell
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return nil
    }
}

//MARK: - UITableViewDelegate
extension SettingsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
        tableView.deselectRow(at: indexPath, animated: true)
        
        let source = self.sources?[indexPath.row]
        
        let centerNavVC = self.evo_drawerController?.centerViewController as? UINavigationController
        let centerVC = centerNavVC?.viewControllers.first as? NewsViewController
        centerVC?.source = source
        
        
        self.evo_drawerController?.toggleLeftDrawerSide(animated: true, completion: nil)

    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
       let header = tableView.dequeueReusableHeaderFooterView(
        withIdentifier: SettingsViewHeaderFooterView.defaultReuseIdentifier) as! SettingsViewHeaderFooterView
        
        header.delegate = self
        
        if section == 0 {
            header.headerLabel.text = Title.settingsHeaderMyNewsTitle
        } else {
            header.headerLabel.text = Title.settingsHeaderAllNewsSourcesTitle
        }

        header.contentView.backgroundColor = #colorLiteral(red: 0.9607843137, green: 0.9607843137, blue: 0.9607843137, alpha: 1)
        header.contentView.alpha = 0.9
        
       return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
            
        guard let height = tableView.dequeueReusableHeaderFooterView(
            withIdentifier: SettingsViewHeaderFooterView.defaultReuseIdentifier)?
            .bounds.height else {return 44.0}
        
        return height
    }
    
}
//MARK: - SettingsViewHeaderFooterViewDelegate
extension SettingsViewController: SettingsViewHeaderFooterViewDelegate {
    func settingsViewHeaderFooterView(_ controller: SettingsViewHeaderFooterView, settingsButtonDidPress: Bool) {
        
        let headerString = controller.headerLabel.text
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        
        if headerString == Title.settingsHeaderMyNewsTitle {
        
            let myNewsVC = mainStoryboard.instantiateViewController(withIdentifier: Storyboard.MyNewsSettingsController) as! MyNewsSettingsTableViewController
            let myNewsNav = UINavigationController(rootViewController: myNewsVC)
            myNewsVC.title = Title.settingsHeaderMyNewsTitle + " settings"
            myNewsVC.sources = self.sources
            
            
            present(myNewsNav, animated: true, completion: nil)

        } else if headerString == Title.settingsHeaderAllNewsSourcesTitle {
            print("-> \(Title.settingsHeaderAllNewsSourcesTitle)")
        }
    }
}


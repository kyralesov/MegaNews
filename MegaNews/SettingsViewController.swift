//
//  SettingsViewController.swift
//  MegaNews
//
//  Created by Eugene Kurilenko on 11/18/16.
//  Copyright © 2016 Eugene Kurilenko. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    //MARK: - Model
    var sources: [Source]? {
        didSet {
            tableView.reloadData()
        }
    }
    
    
    lazy var placeholderImage: UIImage = {
        let image = UIImage(named: "Placeholder News")!
        return image
    }()
    
    
    
    //MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
  
        //sources
        fetchNewsSources()
  

        tableView.estimatedRowHeight = 100
        tableView.register(UINib(nibName: NewsSourceCell.nibName, bundle: nil),
                           forCellReuseIdentifier: NewsSourceCell.defaultReuseIdentifier)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    
        self.navigationController?.view.setNeedsLayout()
        
        self.tableView.reloadSections(IndexSet(integersIn: NSRange(location: 0, length: self.tableView.numberOfSections - 1).toRange() ?? 0..<0), with: .none)

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

extension SettingsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sources?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if section ==  0 {
            return "News sources"
        } else {
           return nil
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(
            withIdentifier: NewsSourceCell.defaultReuseIdentifier,
            for: indexPath) as! NewsSourceCell
        
        let source = self.sources?[indexPath.row]
        
        cell.configureCell(source!, placeholderImage: placeholderImage)
        
        return cell
    }
}

extension SettingsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let source = self.sources?[indexPath.row]
        
        let centerNavVC = self.evo_drawerController?.centerViewController as? UINavigationController
        let centerVC = centerNavVC?.viewControllers.first as? NewsViewController
        centerVC?.source = source
        
        
        self.evo_drawerController?.toggleLeftDrawerSide(animated: true, completion: nil)

    }
    
}

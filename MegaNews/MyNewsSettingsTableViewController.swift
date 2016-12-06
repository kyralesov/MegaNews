//
//  MyNewsSettingsTableViewController.swift
//  MegaNews
//
//  Created by Eugene Kurilenko on 11/28/16.
//  Copyright © 2016 Eugene Kurilenko. All rights reserved.
//

import UIKit

class MyNewsSettingsTableViewController: UITableViewController {

    //MARK: Model
    var sources: [Source]? {
        didSet {
            tableView.reloadData()
        }
    }
    
    private var userSourcesSet = Set<Source>()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Set user sources
        if let userSourcesArray = SourcesDefaults().userSources {
            self.userSourcesSet = Set(userSourcesArray)
        }
        
        // TableView settings
        tableView.register(UINib(nibName: NewsSourceSettingsCell.nibName, bundle: nil),
                           forCellReuseIdentifier: NewsSourceSettingsCell.defaultReuseIdentifier)


        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done,
                                         target: self,
                                         action: #selector(doneButtonAction(_:))
        )
        self.navigationItem.rightBarButtonItem = doneButton
    }
    
    // MARK: - Actions
    func doneButtonAction(_ sender: UIBarButtonItem) {
        
        let userSources = Array(self.userSourcesSet)
        // Set user sourses to UserDefaults
        var sourcesDefaults = SourcesDefaults()
        sourcesDefaults.userSources = userSources
        
        let nc = NotificationCenter.default
        nc.post(name: MyNotification.userSourcesNotification,
                object: nil,
                userInfo: ["sources" : userSources])
        
        dismiss(animated: true, completion: nil)
    }
    
    
    
    // MARK: - UITableViewDataSource
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return sources?.count ?? 0
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: NewsSourceSettingsCell.defaultReuseIdentifier,
                                                 for: indexPath) as! NewsSourceSettingsCell
        
        if let source = self.sources?[indexPath.row] {
            cell.configureCell(source)
            if self.userSourcesSet.contains(source) {
                cell.accessoryType = .checkmark
            }
            
        }
        
        return cell
    }
    
    
    // MARK: - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if let source = self.sources?[indexPath.row] {
            if self.userSourcesSet.contains(source) {
                cell.accessoryType = .checkmark
            } else {
                cell.accessoryType = .none
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard
            let source = self.sources?[indexPath.row],
            let cell = tableView.cellForRow(at: indexPath)
        else {return}
        
        switch cell.accessoryType {
        case .checkmark:
            cell.accessoryType = .none
            self.userSourcesSet.remove(source)
        case .none:
            cell.accessoryType = .checkmark
            self.userSourcesSet.insert(source)
        default:
            cell.accessoryType = .none
        }
  
    }

}

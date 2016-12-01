//
//  MyNewsSettingsTableViewController.swift
//  MegaNews
//
//  Created by Eugene Kurilenko on 11/28/16.
//  Copyright © 2016 Eugene Kurilenko. All rights reserved.
//

import UIKit

class MyNewsSettingsTableViewController: UITableViewController {
    
    //dependency
    let defaults = UserDefaults.standard
    
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

        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done,
                                         target: self,
                                         action: #selector(doneButtonAction(_:))
        )
        self.navigationItem.rightBarButtonItem = doneButton
    }
    
    // MARK: - Actions
    func doneButtonAction(_ sender: UIBarButtonItem) {
        
        // Set user sourses to UserDefaults
        var sourcesDefaults = SourcesDefaults()
        sourcesDefaults.userSources = Array(self.userSourcesSet)
        
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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SourceCell", for: indexPath)
        
        if let source = self.sources?[indexPath.row] {
            cell.textLabel?.text = source.name
            if self.userSourcesSet.contains(source) {
                cell.accessoryType = .checkmark
            }
            
        }
        
        return cell
    }
    
    
    // MARK: - UITableViewDelegate
    
    
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

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
        NewsApiService.shared.request(router: .sources(category: nil,
                                                       language: nil,
                                                       country: nil))
        {[unowned self] (data) in
            self.sources = data as? [Source]
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
            cell.selectionStyle = .gray
            
            cell.accessoryType = .checkmark
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
            
            
            let myNewsVC = mainStoryboard.instantiateViewController(withIdentifier: Storyboard.MyNewsSettingsController)
            let myNewsNav = UINavigationController(rootViewController: myNewsVC)
            myNewsVC.title = Title.settingsHeaderMyNewsTitle + "settings"
            present(myNewsNav, animated: true, completion: nil)

        } else if headerString == Title.settingsHeaderAllNewsSourcesTitle {
            print("-> \(Title.settingsHeaderAllNewsSourcesTitle)")
        }
    }
}

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
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLeftMenuButton()
    

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


}


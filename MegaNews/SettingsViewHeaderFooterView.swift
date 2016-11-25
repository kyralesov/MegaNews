//
//  SettingsViewHeaderFooterView.swift
//  MegaNews
//
//  Created by Eugene Kurilenko on 11/25/16.
//  Copyright © 2016 Eugene Kurilenko. All rights reserved.
//

import UIKit

protocol SettingsViewHeaderFooterViewDelegate: NSObjectProtocol {
    func settingsViewHeaderFooterView(_ controller: SettingsViewHeaderFooterView, settingsButtonDidPress: Bool)
}


class SettingsViewHeaderFooterView: UITableViewHeaderFooterView, NibLoadableView {

    //MARK: Outlets
    @IBOutlet weak var headerLabel: UILabel!
    
    //MARK: Delegate
    weak var delegate: SettingsViewHeaderFooterViewDelegate?
    
    
    
    @IBAction func settingsButtonPressed(_ sender: UIButton) {
        
        delegate?.settingsViewHeaderFooterView(self, settingsButtonDidPress: true)
    }


}

//
//  Constants.swift
//  MegaNews
//
//  Created by Eugene Kurilenko on 11/18/16.
//  Copyright © 2016 Eugene Kurilenko. All rights reserved.
//

import Foundation


struct Storyboard {
    static let settingsViewController = "SettingsViewController"
    static let newsViewController = "NewsViewController"
    
    static let MyNewsSettingsController = "MyNewsSettingsController"
    static let AllNewsSettingsController = "AllNewsSettingsController"
    static let loadingViewController = "LoadingViewController"
    
    static let newsDetailsSegue = "NewsDetailsSegue"
    static let showURLSegue = "ShowURLSegue"
}

struct Title {
    static let settingsHeaderAllNewsSourcesTitle = "All news sources"
    static let settingsHeaderMyNewsTitle = "My news"
}

struct UserDefaultsKey {
    static let sourses = "UserDefaultsSoursesKey"
    static let userSourses = "UserDefaultsUserSoursesKey"
}

struct MyNotification {
    static let userSourcesNotification = Notification.Name(rawValue:"UserSourcesNotification")
}

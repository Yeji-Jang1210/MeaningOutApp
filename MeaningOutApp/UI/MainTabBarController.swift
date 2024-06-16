//
//  MainTabBarController.swift
//  MeaningOutApp
//
//  Created by 장예지 on 6/13/24.
//

import UIKit
import SwiftyUserDefaults

class MainTabBarController: UITabBarController {
    
    enum Tab: Int, CaseIterable {
        case search
        case profile
        
        var title: String {
            switch self {
            case .search:
                return Localized.tabbar_search.title
            case .profile:
                return Localized.tabbar_setting.title
            }
        }
        
        var icon: UIImage? {
            switch self {
            case .search:
                return ImageAssets.search.image
            case .profile:
                return ImageAssets.person.image
            }
        }
        
        var vc: UIViewController {
            switch self {
            case .search:
                return UINavigationController(rootViewController: SearchViewController())
            case .profile:
                return UINavigationController(rootViewController: SettingViewController(title: Localized.profile_tab_title.title))
            }
        }
    }
    
    override func viewDidLoad(){
        super.viewDidLoad()
        tabBar.tintColor = Color.primaryOrange
        tabBar.unselectedItemTintColor = Color.lightGray
        
        let viewControllers = Tab.allCases.map { tab -> UIViewController in
            let vc = tab.vc
            vc.tabBarItem = UITabBarItem(title: tab.title, image: tab.icon, tag: tab.rawValue)
            
            return vc
        }
        
        self.viewControllers = viewControllers
    }
}

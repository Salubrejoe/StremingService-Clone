//
//  ViewController.swift
//  NetflixClone
//
//  Created by Lore P on 09/02/2023.
//  This product uses the TMDB API but is not endorsed or certified by TMDB.

import UIKit

class MainTabBarViewController: UITabBarController {

    
    // MARK: View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTabBar()
    }
    
    // MARK: Tab Bar configuration
    fileprivate func configureTabBar() {
        
        // Create Navigation Controllers
        let homeNavigationController         = UINavigationController(rootViewController: HomeViewController())
        let comingSoonNavigationController   = UINavigationController(rootViewController: UpcomingViewController())
        let topSearchersNavigationController = UINavigationController(rootViewController: SearchViewController())
        let downloadsNavigationController    = UINavigationController(rootViewController: DownloadsViewController())
        
        // Set an image for the tabBarItem
        homeNavigationController.tabBarItem.image         = UIImage(systemName: "house")
        comingSoonNavigationController.tabBarItem.image   = UIImage(systemName: "play.circle")
        topSearchersNavigationController.tabBarItem.image = UIImage(systemName: "magnifyingglass")
        downloadsNavigationController.tabBarItem.image    = UIImage(systemName: "arrow.down.to.line")
        
        // Set a title for the Navigation Controller
        homeNavigationController.title         = "Home"
        comingSoonNavigationController.title   = "Coming Soon"
        topSearchersNavigationController.title = "Top Searchers"
        downloadsNavigationController.title    = "Downloads"
        
        
        tabBar.tintColor = .label
        
        // Set the Root View Controllers for the TabBarController
        setViewControllers([
            homeNavigationController,
            comingSoonNavigationController,
            topSearchersNavigationController,
            downloadsNavigationController
        ], animated: true)
    }


}


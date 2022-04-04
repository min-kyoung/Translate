//
//  ViewController.swift
//  Translate
//
//  Created by 노민경 on 2022/04/04.
//

import UIKit

class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let translateViewController = UIViewController()
        translateViewController.tabBarItem = UITabBarItem(
            title: "translate",
            image: UIImage(systemName: "mic"),
            selectedImage: UIImage(systemName: "mic.fill")
        )
        
        let bookmarkViewController = UIViewController()
        bookmarkViewController.tabBarItem = UITabBarItem(
            title: "bookmark",
            image: UIImage(systemName: "star"),
            selectedImage: UIImage(systemName: "star.fill")
        )
        
        viewControllers = [translateViewController, bookmarkViewController]
    }


}


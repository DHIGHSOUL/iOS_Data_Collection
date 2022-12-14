//
//  WindowTabBarViewController.swift
//  iOSDataCollection
//
//  Created by ROLF J. on 2022/07/25.
//

import UIKit

class WindowTabBarViewController: UITabBarController {
    
    static let shared = WindowTabBarViewController()
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpTabBarLayout()
        self.selectedIndex = 1
    }
    
    // MARK: - Method
    // 센서 확인, 측정 페이지로 이동하는 하단 탭바
    private func setUpTabBarLayout() {
        let firstViewController = UINavigationController(rootViewController: CheckSensorViewController())
        let secondViewController = UINavigationController(rootViewController: MainViewController())
        let thirdViewController = UINavigationController(rootViewController: MenuViewController())
        
        firstViewController.tabBarItem.image = UIImage(systemName: "checkmark.circle.fill")
        firstViewController.tabBarItem.title = LanguageChange.TabBarWord.appSensor
        secondViewController.tabBarItem.image = UIImage(systemName: "house.fill")
        secondViewController.tabBarItem.title = LanguageChange.TabBarWord.measure
        thirdViewController.tabBarItem.image = UIImage(systemName: "menucard.fill")
        thirdViewController.tabBarItem.title = LanguageChange.TabBarWord.appMenu
        
        tabBar.backgroundColor = .systemGray6
        tabBar.tintColor = .systemBlue
        tabBar.unselectedItemTintColor = .lightGray
        
        viewControllers = [firstViewController, secondViewController, thirdViewController]
    }
    
}

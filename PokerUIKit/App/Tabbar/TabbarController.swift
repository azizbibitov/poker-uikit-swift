//
//  TabbarController.swift
//  PokerUIKit
//
//  Created by Aziz Bibitov on 28/12/2025.
//

import UIKit

class TabbarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupVCs()
        setupTabbarAppearance()
    }
    
    func setupTabbarAppearance() {
          let appearance = UITabBarAppearance()
          
          // Selected tab color
          appearance.stackedLayoutAppearance.selected.iconColor = .main
          appearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor.main]
          
          // Unselected tab color
          appearance.stackedLayoutAppearance.normal.iconColor = .cdGray
          appearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.cdGray]
          
          tabBar.standardAppearance = appearance
          if #available(iOS 15.0, *) {
              tabBar.scrollEdgeAppearance = appearance
          }
      }
    
    func setupVCs() {
        let tabVC1 = CombinationsVC()
        tabVC1.tabBarItem = UITabBarItem(title: "", image: UIImage(named: "combinations")?.withTintColor(.cdGray, renderingMode: .alwaysTemplate), selectedImage: UIImage(named: "combinations")?.withTintColor(.main, renderingMode: .alwaysTemplate))
        
        let tabVC2 = QuizVC()
        tabVC2.tabBarItem = UITabBarItem(title: "", image: UIImage(named: "quiz")?.withTintColor(.cdGray, renderingMode: .alwaysTemplate), selectedImage: UIImage(named: "quiz")?.withTintColor(.main, renderingMode: .alwaysTemplate))
        
        let tabVC3 = ClubsVC()
        tabVC3.tabBarItem = UITabBarItem(title: "", image: UIImage(named: "clubs")?.withTintColor(.cdGray, renderingMode: .alwaysTemplate), selectedImage: UIImage(named: "clubs")?.withTintColor(.main, renderingMode: .alwaysTemplate))
        
        
        let tabVC4 = CalculatorVC()
        tabVC4.tabBarItem = UITabBarItem(title: "", image: UIImage(named: "calculator")?.withTintColor(.cdGray, renderingMode: .alwaysTemplate), selectedImage: UIImage(named: "calculator")?.withTintColor(.main, renderingMode: .alwaysTemplate))
        
        self.viewControllers = [UINavigationController(rootViewController: tabVC1), UINavigationController(rootViewController: tabVC2), UINavigationController(rootViewController: tabVC3), UINavigationController(rootViewController: tabVC4)]
        
        tabBar.items?[0].title = "Combinations"
        tabBar.items?[1].title = "Ouiz"
        tabBar.items?[2].title = "Clubs"
        tabBar.items?[3].title = "Calculator"
    }
}

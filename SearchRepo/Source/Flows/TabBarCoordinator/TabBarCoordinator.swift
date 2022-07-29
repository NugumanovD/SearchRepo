//
//  TabBarCoordinator.swift
//  SearchRepo
//
//  Created by Dmitry Nugumanov on 29.07.2022.
//

import Foundation
import RxSwift
import UIKit

class TabBarCoordinator: BaseCoordinator {
  
  private let disposeBag = DisposeBag()
  
  override func start() {
    let tabBarController = UITabBarController()
    
    let repositoriesModel = RepositoriesModel()
    let repositoriesViewModel = RepositoriesViewModel(model: repositoriesModel)
    let repositoriesViewController = RepositoriesViewContoroller()
    repositoriesViewController.viewModel = repositoriesViewModel
    
    repositoriesViewController.tabBarItem = setTabBarItem(
      title: "Repositories",
      image: UIImage(systemName: "person.3"),
      selectedImage: UIImage(systemName: "person.3.fill")
    )
    
    let historyModel = HistoryModel()
    let historyViewModel = HistoryViewModel(model: historyModel)
    let historyViewController = HistoryViewController()
    historyViewController.viewModel = historyViewModel
    
    historyViewController.tabBarItem = setTabBarItem(
      title: "History",
      image: UIImage(systemName: "archivebox"),
      selectedImage: UIImage(systemName: "archivebox.fill")
    )
    
    tabBarController.tabBar.standardAppearance = setTabBarAppearance(iconColor: .systemGray2, selectedIconColor: .darkText)
    
    tabBarController.viewControllers = [
      UINavigationController(rootViewController: repositoriesViewController),
      UINavigationController(rootViewController: historyViewController)
    ]
    
    navigationController.viewControllers = [tabBarController]
  }
  
}

private extension TabBarCoordinator {
  
  func setTabBarItem(title: String, image: UIImage? = nil, selectedImage: UIImage? = nil) -> UITabBarItem {
      .init(title: title, image: image, selectedImage: selectedImage)
  }
  
  private func setTabBarAppearance(
    iconColor: UIColor = UIColor.systemGray,
    selectedIconColor: UIColor = UIColor.systemGray2,
    titleTextColor: UIColor = UIColor.systemGray,
    selectedTitleTextColor: UIColor = UIColor.darkText
  ) -> UITabBarAppearance {
    
    let appearance = UITabBarAppearance()
    appearance.backgroundColor = .white
    appearance.stackedLayoutAppearance.normal.iconColor = iconColor
    appearance.stackedLayoutAppearance.normal.titleTextAttributes = [NSAttributedString.Key.foregroundColor: titleTextColor]
    
    appearance.stackedLayoutAppearance.selected.iconColor = selectedIconColor
    appearance.stackedLayoutAppearance.selected.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.systemPink]
    
    return appearance
  }
  
}

//
//  AppDelegate.swift
//  SearchRepo
//
//  Created by Dmitry Nugumanov on 29.07.2022.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?
  
  let deepLinkHandler = DeepLinkHandler()
  let appCoordinator = AppCoordinator()
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    appCoordinator.deepLinkHandler = deepLinkHandler
    appCoordinator.start()
    
    return true
  }
  
  func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
    deepLinkHandler.handle(url)
    
    return true
  }
  
}


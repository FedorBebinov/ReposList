//
//  SceneDelegate.swift
//  reposList
//
//  Created by Fedor Bebinov on 01.12.2024.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        let navigationController = UINavigationController(rootViewController: ListModule.build(reposFacade: ServiceLocator.reposFacade))
        window.rootViewController = navigationController
        self.window = window
        window.makeKeyAndVisible()
    }
}


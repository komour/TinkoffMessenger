//
//  SceneDelegate.swift
//  TinkoffMessenger
//
//  Created by Always Strive And Prosper on 16.02.2020.
//  Copyright © 2020 komarov. All rights reserved.
//

import UIKit

@available(iOS 13.0, *)
class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

        guard let _ = (scene as? UIWindowScene) else { return }
        
        printLog("The scene has been added to the app: \(#function)\n")
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        printLog("The application state changes from Inactive to Active: \(#function)\n")
    }

    func sceneWillResignActive(_ scene: UIScene) {
        printLog("The application state changes from Active to Inactive: \(#function)\n")
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        printLog("The application state changes from Foreground (Inactive) to Background: \(#function)\n")
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        printLog("The application state changes from Background to Foreground (Inactive): \(#function)\n")
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        printLog("The scene is being released by the system: \(#function)\n")
    }

    func printLog(_ message : String) {
        #if Logs
            print(message)
        #endif
    }

}


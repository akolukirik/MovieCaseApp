//
//  AppDelegate.swift
//  InvioChallenge
//
//  Created by invio on 12.11.2022.
//

import UIKit
import netfox

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        NFX.sharedInstance().start()

        self.window = UIWindow(frame: UIScreen.main.bounds)
        let splashVC = SplashViewController(nibName: SplashViewController.className, bundle: nil)
        splashVC.inject(viewModel: SplashViewModelImpl(), delegate: self)
        self.window?.rootViewController = splashVC
        self.window?.makeKeyAndVisible()
        
        return true
    }
}

extension AppDelegate: SplashViewControllerDelegate {
    func appStart() {
        let movieListVC = MovieListViewController(nibName: MovieListViewController.className, bundle: nil)
        let navigationController = UINavigationController(rootViewController: movieListVC)
        let viewModel = MovieListViewModelImpl(movieService: Service())
        movieListVC.inject(viewModel: viewModel)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
}

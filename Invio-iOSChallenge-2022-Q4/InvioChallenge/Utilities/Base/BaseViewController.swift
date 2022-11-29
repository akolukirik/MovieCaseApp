//
//  BaseViewController.swift
//  InvioChallenge
//
//  Created by invio on 12.11.2022.
//

import UIKit

class BaseViewController: UIViewController {
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showNavBar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        hideNavBar()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    func setupNavBar(title: String? = nil, leftIcon: String? = nil, rightIcon: String? = nil, leftItemAction: Selector? = nil, rightItemAction: Selector? = nil) {
        if let leftIcon = leftIcon {
            let leftItem = UIBarButtonItem(image: UIImage(named: leftIcon)?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: leftItemAction)
            self.navigationItem.leftBarButtonItem = leftItem
        }
        
        if let rightIcon = rightIcon {
            let rightItem = UIBarButtonItem(image: UIImage(named: rightIcon)?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: rightItemAction)
            self.navigationItem.rightBarButtonItem = rightItem
        }

        if let title = title {
            self.title = title
        }
    }
    
    @objc func goBack() {
        if self.navigationController?.viewControllers.count == 1 {
            self.dismiss(animated: true)
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }

    func showNavBar() {
        navigationController?.setNavigationBarHidden(false, animated: true)
    }

    func hideNavBar() {
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
}

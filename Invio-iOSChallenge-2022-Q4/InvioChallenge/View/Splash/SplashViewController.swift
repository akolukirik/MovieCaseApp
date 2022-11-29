//
//  SplashViewController.swift
//  InvioChallenge
//
//  Created by invio on 12.11.2022.
//

import UIKit

extension SplashViewController {
    private enum Constants {
        static let fontSize: CGFloat = 36
    }
}

protocol SplashViewControllerDelegate: AnyObject {
    func appStart()
}

extension SplashViewControllerDelegate {
    func appStart() { }
}

class SplashViewController: BaseViewController {
    
    @IBOutlet private weak var welcomeLabel: UILabel!
    
    private var viewModel: SplashViewModel!
    private weak var delegate: SplashViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        if viewModel == nil {
            assertionFailure(Localizable.Helper.assertionFailureMessage.localized)
        }
        setupUI()
        addObservationListener()
        viewModel.start()
    }
    
    private func setupUI() {
        welcomeLabel.font = UIFont.avenir(.Heavy, size: Constants.fontSize)
        welcomeLabel.textColor = .white
    }
    
    func inject(viewModel: SplashViewModel, delegate: SplashViewControllerDelegate) {
        self.viewModel = viewModel
        self.delegate = delegate
    }
}

// MARK: - ViewModel Listener
extension SplashViewController {
    func addObservationListener() {
        self.viewModel.stateClosure = { [weak self] result in
            switch result {
            case .success(let data):
                self?.handleClosureData(data: data)
            case .failure(_):
                break
            }
        }
    }
    
    private func handleClosureData(data: SplashViewModelImpl.ViewInteractivity) {
        switch data {
        case .appStart:
            delegate?.appStart()
        case .updateWelcomeText(let text):
            welcomeLabel.text = text
        }
    }
}

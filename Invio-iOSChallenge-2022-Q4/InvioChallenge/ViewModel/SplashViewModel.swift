//
//  SplashViewModel.swift
//  InvioChallenge
//
//  Created by invio on 12.11.2022.
//

import Foundation

extension SplashViewModelImpl {
    private enum Constants {
        static let addSecond: CGFloat = 2
    }
}

protocol SplashViewModel: BaseViewModel {
    var stateClosure: ((Result<SplashViewModelImpl.ViewInteractivity, Error>) -> ())? { set get }
}

final class SplashViewModelImpl: SplashViewModel {
    var stateClosure: ((Result<ViewInteractivity, Error>) -> ())?

    private let defaults = UserDefaults.standard

    func start() {
        if defaults.bool(forKey: "firstLaunch") == true {
            self.stateClosure?(.success(.updateWelcomeText(text: Localizable.Splash.welcomeMessage.localized)))
            defaults.set(true, forKey: "firstLaunch")
        } else {
            self.stateClosure?(.success(.updateWelcomeText(text: Localizable.Splash.helloMessage.localized)))
            defaults.set(true, forKey: "firstLaunch")
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + Constants.addSecond) { [weak self] in
            self?.stateClosure?(.success(.appStart))
        }
    }
}

extension SplashViewModelImpl {
    enum ViewInteractivity {
        case appStart
        case updateWelcomeText(text: String)
    }
}

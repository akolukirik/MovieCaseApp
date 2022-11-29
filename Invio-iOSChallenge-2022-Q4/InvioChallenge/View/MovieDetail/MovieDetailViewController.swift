//
//  MovieDetailViewController.swift
//  InvioChallenge
//
//  Created by Ali Kolukirik on 23.11.2022.
//

import UIKit

extension MovieDetailViewController {
    private struct Constants {
        static let leftIcon: String = "left-arrow"
    }
}

class MovieDetailViewController: BaseViewController {
    @IBOutlet private weak var posterImageView: UIImageView!
    @IBOutlet private weak var runtimeLabel: UILabel!
    @IBOutlet private weak var yearLabel: UILabel!
    @IBOutlet private weak var languageLabel: UILabel!
    @IBOutlet private weak var ratingLabel: UILabel!
    @IBOutlet private weak var plotLabel: UILabel!
    @IBOutlet private weak var directorLabel: UILabel!
    @IBOutlet private weak var writerLabel: UILabel!
    @IBOutlet private weak var actorsLabel: UILabel!
    @IBOutlet private weak var countryLabel: UILabel!
    @IBOutlet private weak var boxOfficeLabel: UILabel!

    var viewModel: MovieDetailViewModelProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
        if viewModel == nil {
            assertionFailure(Localizable.Helper.assertionFailureMessage.localized)
        }

        addObservationListener()
        viewModel?.start()
    }

    private func createNavBar(rightIcon: String) {
        setupNavBar(leftIcon: Constants.leftIcon,
                    rightIcon: rightIcon,
                    leftItemAction: #selector(leftItemActionTapped),
                    rightItemAction: #selector(rightItemActionTapped))
    }

    @objc private func leftItemActionTapped() {
        goBack()
    }

    @objc private func rightItemActionTapped() {
        viewModel?.rightItemActionTapped()
    }

    func inject(viewModel: MovieDetailViewModelProtocol) {
        self.viewModel = viewModel
    }
}

extension MovieDetailViewController {
    func addObservationListener() {
        self.viewModel?.stateClosure = { [weak self] result in
            switch result {
            case .success(let data):
                self?.handleClosureData(data: data)
            case .failure(_):
                break
            }
        }
    }

    private func handleClosureData(data: MovieDetailViewModelImpl.ViewInteractivity) {
        switch data {
        case .updateViewElements(let arguments):
            setupNavBar(title: arguments.viewTitle)
            posterImageView.setImage(imageURL: arguments.posterImageURL)
            runtimeLabel.text = arguments.runtimeLabelText
            yearLabel.text = arguments.yearLabelText
            languageLabel.text = arguments.languageLabelText
            ratingLabel.text = arguments.ratingLabelText
            plotLabel.text = arguments.plotLabelText
            directorLabel.text = arguments.directorLabelText
            writerLabel.text = arguments.writerLabelText
            actorsLabel.text = arguments.actorsLabelText
            countryLabel.text = arguments.countryLabelText
            boxOfficeLabel.text = arguments.boxOfficeLabelText
        case .updateSaveButtonIcon(let image):
            createNavBar(rightIcon: image)
        }
    }
}

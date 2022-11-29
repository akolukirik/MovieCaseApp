//
//  MovieDetailViewModel.swift
//  InvioChallenge
//
//  Created by Ali Kolukirik on 23.11.2022.
//

import Foundation

extension MovieDetailViewModelImpl {
    private struct Constants {
        static let unFavoriteIcon: String = "like-empty"
        static let favoriteIcon: String = "like-fill"
        static let savedMoviesKey: String = "savedMovies"
    }
}

protocol MovieDetailViewModelProtocol: BaseViewModel {
    var stateClosure: ((Result<MovieDetailViewModelImpl.ViewInteractivity, Error>) -> ())? { set get }

    func rightItemActionTapped()
}

final class MovieDetailViewModelImpl: MovieDetailViewModelProtocol {

    var stateClosure: ((Result<ViewInteractivity, Error>) -> ())?
    private var detailModel: MovieDetailModel

    init(detailModel: MovieDetailModel) {
        self.detailModel = detailModel
    }

    private var isSavedMovie: Bool {
        set {
            var savedMovies = UserDefaults.standard.object(forKey: Constants.savedMoviesKey) as? [String: Bool] ?? [:]
            savedMovies[detailModel.imdbID ?? ""] = newValue
            UserDefaults.standard.set(savedMovies, forKey: Constants.savedMoviesKey)
        }
        get {
            let savedMovies = UserDefaults.standard.object(forKey: Constants.savedMoviesKey) as? [String: Bool] ?? [:]
            return savedMovies[detailModel.imdbID ?? ""] ?? false
        }
    }
    
    func start() {
        let viewElementsArguments = UpdateViewElementsArguments(
            viewTitle: detailModel.title ?? Localizable.Helper.notAttendantMessage.localized,
            posterImageURL: detailModel.poster ?? "",
            runtimeLabelText: detailModel.runtime ?? Localizable.Helper.notAttendantMessage.localized,
            yearLabelText: detailModel.year ?? Localizable.Helper.notAttendantMessage.localized,
            languageLabelText: detailModel.language?.components(separatedBy: ",").first ?? Localizable.Helper.notAttendantMessage.localized,
            ratingLabelText: detailModel.ratings?.first?.value ?? Localizable.Helper.notAttendantMessage.localized,
            plotLabelText: detailModel.plot ?? Localizable.Helper.notAttendantMessage.localized,
            directorLabelText: detailModel.director ?? Localizable.Helper.notAttendantMessage.localized,
            writerLabelText: detailModel.writer ?? Localizable.Helper.notAttendantMessage.localized,
            actorsLabelText: detailModel.actors ?? Localizable.Helper.notAttendantMessage.localized,
            countryLabelText: detailModel.country ?? Localizable.Helper.notAttendantMessage.localized,
            boxOfficeLabelText: detailModel.boxOffice ?? Localizable.Helper.notAttendantMessage.localized)
        self.stateClosure?(.success(.updateViewElements(arguments: viewElementsArguments)))
        self.stateClosure?(.success(.updateSaveButtonIcon(image: isSavedMovie ? Constants.favoriteIcon : Constants.unFavoriteIcon)))
    }

    func rightItemActionTapped() {
        isSavedMovie = !isSavedMovie
        self.stateClosure?(.success(.updateSaveButtonIcon(image: isSavedMovie ? Constants.favoriteIcon : Constants.unFavoriteIcon)))
    }
}

extension MovieDetailViewModelImpl {
    enum ViewInteractivity {
        case updateViewElements(arguments: UpdateViewElementsArguments)
        case updateSaveButtonIcon(image: String)
    }

    struct UpdateViewElementsArguments {
        let viewTitle: String
        let posterImageURL: String
        let runtimeLabelText: String
        let yearLabelText: String
        let languageLabelText: String
        let ratingLabelText: String
        let plotLabelText: String
        let directorLabelText: String
        let writerLabelText: String
        let actorsLabelText: String
        let countryLabelText: String
        let boxOfficeLabelText: String
    }
}

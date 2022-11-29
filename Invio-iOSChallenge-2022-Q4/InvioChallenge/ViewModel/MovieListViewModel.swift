//
//  MovieListViewModel.swift
//  InvioChallenge
//
//  Created by invio on 12.11.2022.
//

import Foundation
import Alamofire


extension MovieListViewModelImpl {
    private enum Constants {
        static let savedMoviesKey: String = "savedMovies"
    }
}

protocol MovieListViewModel: BaseViewModel {
    var stateClosure: ((Result<MovieListViewModelImpl.ViewInteractivity, Error>) -> ())? { set get }
    var searchResult: [MovieResult]? { get set }
    func getNumberOfRowsInSection() -> Int
    func getMovieForCell(at indexPath: IndexPath) -> MovieResult?
    func fetchData(searchText: String)
    func didTappedMovie(rowIndex: Int)
    func tableViewWillDisplay(indexPath: IndexPath)
    func saveButtonTapped(imdbCode: String, isSaved: Bool)
}

final class MovieListViewModelImpl: MovieListViewModel {
    private var pageNumber = 1
    private var searchText: String?
    var searchResult: [MovieResult]? = []
    let movieService : ServiceProtocol
    var stateClosure: ((Result<ViewInteractivity, Error>) -> ())?

    init(movieService: ServiceProtocol) {
        self.movieService = movieService
    }

    func start() {
        self.stateClosure?(.success(.updateMovieList))
    }

    func fetchData(searchText: String) {
        if pageNumber == 1 || self.searchText != searchText {
            searchResult = []
            pageNumber = 1
        }

        self.searchText = searchText

        self.stateClosure?(.success(.updateFailViewText(text: Localizable.MovieList.searchingMessage.localized)))

        movieService.fetchMovies(searchText: "\(searchText)",
                                 pageNumber: self.pageNumber) { [weak self] model in
            guard let self = self else { return }
            self.stateClosure?(.success(.stopNewPagesAnimations))
            if let newResults = model?.results {
                self.searchResult?.append(contentsOf: newResults)
                self.stateClosure?(.success(.updateMovieList))
            } else if (self.searchResult ?? []).isEmpty == true {
                self.stateClosure?(.success(.updateFailViewText(text: Localizable.MovieList.emptyResponseMessage.localized)))
            }

        } onError: { [weak self] data in
            self?.stateClosure?(.success(.stopNewPagesAnimations))
            self?.stateClosure?(.success(.updateFailViewText(text: Localizable.MovieList.apiError.localized)))
        }
    }

    func didTappedMovie(rowIndex: Int) {
        guard let imdbCode = searchResult?[rowIndex].imdbID else { return }

        movieService.movieDetail(imdbID: imdbCode) { [weak self] model in
            if let model = model {
                self?.stateClosure?(.success(.navigateToMovieDetail(model: model)))
            } else {
                self?.stateClosure?(.success(.updateFailViewText(text: Localizable.MovieList.navigateFailure.localized)))
            }
        } onError: { error in
            self.stateClosure?(.success(.updateFailViewText(text: Localizable.MovieList.apiError.localized)))
        }
    }

    func tableViewWillDisplay(indexPath: IndexPath) {
        if let searchResultCount = searchResult?.count, searchResultCount - 1 == indexPath.row  {
            pageNumber += 1
            fetchData(searchText: searchText ?? "")
            self.stateClosure?(.success(.loadNewPages))
        }
    }

    func saveButtonTapped(imdbCode: String, isSaved: Bool) {
        var savedMovies = UserDefaults.standard.object(forKey: Constants.savedMoviesKey) as? [String: Bool] ?? [:]
        savedMovies[imdbCode] = isSaved
        UserDefaults.standard.set(savedMovies, forKey: Constants.savedMoviesKey)
    }
}

// MARK: ViewModel to ViewController interactivity
extension MovieListViewModelImpl {
    enum ViewInteractivity {
        case updateMovieList
        case navigateToMovieDetail(model: MovieDetailModel)
        case updateFailViewText(text: String)
        case loadNewPages
        case stopNewPagesAnimations
    }
}

// MARK: TableView DataSource
extension MovieListViewModelImpl {
    func getNumberOfRowsInSection() -> Int {
        return self.searchResult?.count ?? 0
    }

    func getMovieForCell(at indexPath: IndexPath) -> MovieResult? {
        guard let movie = self.searchResult?[safe: indexPath.row] else { return nil }
        return movie
    }
}

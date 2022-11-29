//
//  MovieListViewController.swift
//  InvioChallenge
//
//  Created by invio on 12.11.2022.
//

import UIKit

extension MovieListViewController {
    private enum Constants {
        static let bottomCornerSize: CGFloat = 20
        static let cornerRadius: CGFloat = 10
        static let fontSize: CGFloat = 16
        static let topEdge: CGFloat = 10
        static let bottomEdge: CGFloat = 30
        static let zeroEdge: CGFloat = 0
        static let savedMoviesKey: String = "savedMovies"
    }
}

class MovieListViewController: BaseViewController {
    
    @IBOutlet private weak var topContentView: UIView!
    @IBOutlet private weak var searchContainerView: UIView!
    @IBOutlet private weak var searchField: UITextField!
    @IBOutlet private weak var searchButton: UIButton!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!

    private var viewModel: MovieListViewModel!

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideNavBar()
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if viewModel == nil {
            assertionFailure(Localizable.Helper.assertionFailureMessage.localized)
        }
        setupView()
        setupTableView()
        addObservationListener()
        viewModel.start()
        startActivityIndicator()
        activityIndicator.color = UIColor.softBlue
    }
    
    func inject(viewModel: MovieListViewModel) {
        self.viewModel = viewModel
    }

    private func startActivityIndicator() {
        activityIndicator.startAnimating()
        activityIndicator.isHidden = false
    }

    private func stopActivityIndicator() {
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
    }

    private func setupView() {
        topContentView.roundBottomCorners(radius: Constants.bottomCornerSize)
        searchContainerView.cornerRadius = Constants.cornerRadius
        searchField.font = .avenir(.Book, size: Constants.fontSize)
        searchField.textColor = .softBlack
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(cellType: MovieListTableViewCell.self)
        tableView.contentInset = UIEdgeInsets(top: Constants.topEdge,
                                              left: Constants.zeroEdge,
                                              bottom: Constants.bottomEdge,
                                              right: Constants.zeroEdge)
        tableView.separatorStyle = .none
    }
    
    @IBAction func searchButtonTapped() {
        viewModel.fetchData(searchText: searchField.text ?? "")
        tableView.reloadData()
    }
}

// MARK: - TableView Delegate & DataSource
extension MovieListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if viewModel.getNumberOfRowsInSection() == 0 {
            self.tableView.setEmptyMessage(Localizable.MovieList.makeSearch.localized)
            startActivityIndicator()
        } else {
            self.tableView.restore()
            stopActivityIndicator()
        }
        return viewModel.getNumberOfRowsInSection()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let movie = viewModel.getMovieForCell(at: indexPath) else { return UITableViewCell() }

        let cell = tableView.dequeueReusableCell(withIdentifier: MovieListTableViewCell.className, for: indexPath) as! MovieListTableViewCell

        let imdbCode = viewModel.searchResult?[indexPath.row].imdbID ?? ""
        let savedMovies = UserDefaults.standard.object(forKey: Constants.savedMoviesKey) as? [String: Bool] ?? [:]
        let isSaved = savedMovies[imdbCode] ?? false

        cell.setupCell(movie: movie,
                       index: indexPath.row,
                       isSaved: isSaved,
                       delegate: self)
        return cell
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        viewModel.tableViewWillDisplay(indexPath: indexPath)
    }
}

extension MovieListViewController: MovieListTableViewCellDelegate {
    func didTappedSaveMovie(rowIndex: Int, isSaved: Bool) {
        let imdbCode = viewModel.searchResult?[rowIndex].imdbID ?? ""
        viewModel.saveButtonTapped(imdbCode: imdbCode, isSaved: isSaved)
    }

    func didTappedMovie(rowIndex: Int) {
        viewModel.didTappedMovie(rowIndex: rowIndex)
        startActivityIndicator()
    }
}

// MARK: - ViewModel Listener
extension MovieListViewController {
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
    
    private func handleClosureData(data: MovieListViewModelImpl.ViewInteractivity) {
        switch data {
        case .updateMovieList:
            self.tableView.restore()
            self.tableView.reloadData()
        case .navigateToMovieDetail(model: let model):
            navigateToDetailView(model: model)
        case .loadNewPages:
            startActivityIndicator()
        case.stopNewPagesAnimations:
            stopActivityIndicator()
        case .updateFailViewText(let text):
            self.tableView.setEmptyMessage(text)
        }
    }

    private func navigateToDetailView(model: MovieDetailModel) {
        let detailVC = MovieDetailViewController.init(nibName: MovieDetailViewController.className, bundle: nil)
        detailVC.inject(viewModel: MovieDetailViewModelImpl(detailModel: model))
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

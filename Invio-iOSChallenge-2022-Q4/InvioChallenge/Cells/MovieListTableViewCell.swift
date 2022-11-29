//
//  MovieListTableViewCell.swift
//  InvioChallenge
//
//  Created by invio on 12.11.2022.
//

import UIKit

extension MovieListTableViewCell {
    private enum Constants {
        static let corverRadius: CGFloat = 10
        static let likeFill: String = "like-fill"
        static let likeEmpty: String = "like-empty"
        static let posterEmpty: String = "placeholder-poster"
    }
}

protocol MovieListTableViewCellDelegate {
    func didTappedMovie(rowIndex: Int)
    func didTappedSaveMovie(rowIndex: Int, isSaved: Bool)
}

class MovieListTableViewCell: UITableViewCell {

    @IBOutlet private weak var cellContentView: UIView!
    @IBOutlet private weak var posterImageView: UIImageView!
    @IBOutlet private weak var likeButton: UIButton!
    @IBOutlet private weak var movieNameLabel: UILabel!
    @IBOutlet private weak var movieYearLabel: UILabel!
    @IBOutlet private weak var movieTypeLabel: UILabel!
    @IBOutlet private weak var movieImdbLabel: UILabel!

    private var cellIndex: Int = 0
    private var isSaved: Bool = false
    private var delegate: MovieListTableViewCellDelegate?

    func setupCell(movie: MovieResult,
                   index: Int,
                   isSaved: Bool,
                   delegate: MovieListTableViewCellDelegate?) {
        movieNameLabel.text = movie.title
        movieYearLabel.text = movie.year
        movieTypeLabel.text = movie.type?.rawValue
        movieImdbLabel.text = "IMDB ID : \(movie.imdbID ?? "")"
        posterImageView.setImage(imageURL: movie.poster ?? Constants.posterEmpty)
        self.isSaved = isSaved
        self.cellIndex = index
        self.delegate = delegate

        setSaveButtonColor(isSaved: isSaved)
        cellContentView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(containerViewTapped)))
    }

    @objc private func containerViewTapped() {
        delegate?.didTappedMovie(rowIndex: cellIndex)
    }

    @IBAction private func likeButtonTapped() {
        self.likeButton.isSelected = false
        self.isSaved.toggle()
        self.setSaveButtonColor(isSaved: isSaved)
        self.delegate?.didTappedSaveMovie(rowIndex: cellIndex, isSaved: isSaved)
    }

    private func setSaveButtonColor(isSaved: Bool) {
        isSaved ? likeButton.setImage(UIImage(named: Constants.likeFill), for: .normal) :
        likeButton.setImage(UIImage(named: Constants.likeEmpty), for: .normal)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        posterImageView.cornerRadius = Constants.corverRadius
    }
}

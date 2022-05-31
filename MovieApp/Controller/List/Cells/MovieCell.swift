//
//  MovieCell.swift
//  MovieApp
//
//  Created by Murat ŞENOL on 31.05.2022.
//

import UIKit
import Kingfisher

class MovieCell: UITableViewCell {

    @IBOutlet weak var backdropImageView: UIImageView!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var movieNameLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureMovie(with movie : Movie){
        
        if let backdropPath = movie.backdropPath{
            ImageManager.setImage(withPath: backdropPath, on: backdropImageView)
        }
        else{
            backdropImageView.image = UIImage(named: AppConfig.config.defaultBackdropImage)
        }
        if let posterPath = movie.posterPath{
            ImageManager.setImage(withPath: posterPath, on: posterImageView)
        }
        else{
            posterImageView.image = UIImage(named: AppConfig.config.defaultPosterImage)
        }
        
        movieNameLabel.text = movie.title
        genreLabel.text = movie.genresCSV
        overviewLabel.text = movie.overview
        ratingLabel.text = String(movie.voteAverage)
        releaseDateLabel.text = movie.releaseDate
        
    }
    
    func configureMovie(with movie : MovieListResult){
        if let backdropPath = movie.backdropPath{
            ImageManager.setImage(withPath: backdropPath, on: backdropImageView)
        }
        else{
            backdropImageView.image = UIImage(named: AppConfig.config.defaultBackdropImage)
        }
        if let posterPath = movie.posterPath{
            ImageManager.setImage(withPath: posterPath, on: posterImageView)
        }
        else{
            posterImageView.image = UIImage(named: AppConfig.config.defaultPosterImage)
        }
        
        movieNameLabel.text = movie.title
        //TODO make genreCSV for MovieListResult
        overviewLabel.text = movie.overview
        ratingLabel.text = String(movie.voteAverage)
        releaseDateLabel.text = movie.releaseDate
        
    }
    
}

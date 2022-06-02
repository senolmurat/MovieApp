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
    @IBOutlet weak var bookmarkImageView: UIImageView!
    private var isFavourited : Bool = false
    private var movieID : Int?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        let bookmarkGesture = UITapGestureRecognizer(target: self, action:  #selector (self.bookmarkClicked(_:)))
        self.bookmarkImageView.addGestureRecognizer(bookmarkGesture)
        bookmarkImageView.isUserInteractionEnabled = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureMovie(with movie : Movie){
        
        movieID = movie.id

        ImageManager.setImage(withPath: movie.backdropPath, on: backdropImageView)
        ImageManager.setImage(withPath: movie.posterPath, on: posterImageView)
        
        //TODO: set bookmark/favourited image according to user data
        isFavourited = AppConfig.config.favouriteList.contains(movie.id)
        if(isFavourited){
            bookmarkImageView.image = UIImage(systemName: "bookmark.fill")
        }
        else{
            bookmarkImageView.image = UIImage(systemName: "bookmark")
        }
        
        movieNameLabel.text = movie.title
        genreLabel.text = movie.genresCSV
        overviewLabel.text = movie.overview
        ratingLabel.text = String(movie.voteAverage)
        releaseDateLabel.text = movie.releaseDate
    }
    
    func configureMovie(with movie : MovieListResult){
        movieID = movie.id
        
        ImageManager.setImage(withPath: movie.backdropPath, on: backdropImageView)
        ImageManager.setImage(withPath: movie.posterPath, on: posterImageView)
        
        //TODO: set bookmark/favourited image according to user data
        isFavourited = AppConfig.config.favouriteList.contains(movie.id)
        if(isFavourited){
            bookmarkImageView.image = UIImage(systemName: "bookmark.fill")
        }
        else{
            bookmarkImageView.image = UIImage(systemName: "bookmark")
        }
        
        movieNameLabel.text = movie.title
        //TODO: make genreCSV for MovieListResult
        overviewLabel.text = movie.overview
        ratingLabel.text = String(movie.voteAverage)
        releaseDateLabel.text = movie.releaseDate
        
    }
    
    @objc func bookmarkClicked(_ sender:UITapGestureRecognizer){
        if(isFavourited){
            isFavourited = false
            AppConfig.config.favouriteList.removeAll(where: {$0 == movieID})
            bookmarkImageView.image = UIImage(systemName: "bookmark")
        }
        else{
            isFavourited = true
            AppConfig.config.favouriteList.append(movieID!)
            bookmarkImageView.image = UIImage(systemName: "bookmark.fill")
        }
    }
    
}

//
//  MovieLessDetailCell.swift
//  MovieApp
//
//  Created by Murat ŞENOL on 8.06.2022.
//

import UIKit

class MovieLessDetailCell: UITableViewCell {

    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var bookmarkImageView: UIImageView!
    @IBOutlet weak var view: UIView!
    private var isFavourited : Bool = false
    private var movieID : Int?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        let bookmarkGesture = UITapGestureRecognizer(target: self, action:  #selector (self.bookmarkClicked(_:)))
        self.bookmarkImageView.addGestureRecognizer(bookmarkGesture)
        bookmarkImageView.isUserInteractionEnabled = true
        
        view.layer.cornerRadius = 6.0
        view.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureMovie(with movie : Movie){
        
        movieID = movie.id
        
        //ImageManager.setImage(withPath: movie.posterPath, on: posterImageView)
        ImageManager.setImageRounded(withPath: movie.posterPath, on: posterImageView, cornerRadius: 2,placeholder: UIImage(systemName: K.posterPlaceholder)!)
        
        isFavourited = AppConfig.config.favouriteList.contains(movie.id)
        bookmarkImageView.image = self.isFavourited ? UIImage(systemName: "bookmark.fill") : UIImage(systemName: "bookmark")
        
        titleLabel.text = movie.title
        ratingLabel.text = String(movie.voteAverage)
        if let releaseDate = movie.releaseDate{
            releaseDateLabel.text = releaseDate.tryLocalizedDate()
        }
        else{
            releaseDateLabel.text = "unknown".localized()
        }
    }
    
    func configureMovie(with movie : MovieListResult){
        movieID = movie.id
        
        //ImageManager.setImage(withPath: movie.posterPath, on: posterImageView)
        ImageManager.setImageRounded(withPath: movie.posterPath, on: posterImageView, cornerRadius: 2,placeholder: UIImage(systemName: K.posterPlaceholder)!)
        
        isFavourited = AppConfig.config.favouriteList.contains(movie.id)
        bookmarkImageView.image = self.isFavourited ? UIImage(systemName: "bookmark.fill") : UIImage(systemName: "bookmark")
        
        titleLabel.text = movie.title
        ratingLabel.text = String(movie.voteAverage)
        if let releaseDate = movie.releaseDate{
            releaseDateLabel.text = releaseDate.tryLocalizedDate()
        }
        else{
            releaseDateLabel.text = "unknown".localized()
        }
        
    }
    
    @objc func bookmarkClicked(_ sender:UITapGestureRecognizer){
        Movie.configureFavouriteList(with: movieID!, imageView: bookmarkImageView, isAlreadyFavourited: &isFavourited)
    }
    
}

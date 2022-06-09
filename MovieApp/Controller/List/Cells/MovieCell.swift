//
//  MovieCell.swift
//  MovieApp
//
//  Created by Murat ŞENOL on 31.05.2022.
//

import UIKit
import Kingfisher
import Localize_Swift

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
    var inset : CGFloat = 2
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        let bookmarkGesture = UITapGestureRecognizer(target: self, action:  #selector (self.bookmarkClicked(_:)))
        self.bookmarkImageView.addGestureRecognizer(bookmarkGesture)
        bookmarkImageView.isUserInteractionEnabled = true
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: inset, left: 0, bottom: inset, right: 0))
    }
    
    func configureMovie(with movie : Movie){
        
        movieID = movie.id
        
        ImageManager.setImage(withPath: movie.backdropPath, on: backdropImageView)
        ImageManager.setImage(withPath: movie.posterPath, on: posterImageView)
        
        isFavourited = AppConfig.config.favouriteList.contains(movie.id)
        bookmarkImageView.image = self.isFavourited ? UIImage(systemName: "bookmark.fill") : UIImage(systemName: "bookmark")
        
        movieNameLabel.text = movie.title
        genreLabel.text = movie.genresCSV
        overviewLabel.text = movie.overview
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
        
        ImageManager.setImage(withPath: movie.backdropPath, on: backdropImageView)
        ImageManager.setImage(withPath: movie.posterPath, on: posterImageView)
        
        isFavourited = AppConfig.config.favouriteList.contains(movie.id)
        bookmarkImageView.image = self.isFavourited ? UIImage(systemName: "bookmark.fill") : UIImage(systemName: "bookmark")
        
        movieNameLabel.text = movie.title
        genreLabel.text = movie.genresCSV
        overviewLabel.text = movie.overview
        ratingLabel.text = String(movie.voteAverage)
        if let releaseDate = movie.releaseDate{
            releaseDateLabel.text = releaseDate.tryLocalizedDate()
        }
        else{
            releaseDateLabel.text = "unknown".localized()
        }
        
    }
    
    @objc func bookmarkClicked(_ sender:UITapGestureRecognizer){
        if(isFavourited){
            isFavourited = false
            AppConfig.config.favouriteList.removeAll(where: {$0 == movieID})
            //bookmarkImageView.image = UIImage(systemName: "bookmark")
        }
        else{
            isFavourited = true
            AppConfig.config.favouriteList.append(movieID!)
            //bookmarkImageView.image = UIImage(systemName: "bookmark.fill")
        }
        
        UIView.animate(withDuration: 0.1, animations: { [self] in
            let newImage = self.isFavourited ? UIImage(systemName: "bookmark.fill") : UIImage(systemName: "bookmark")
            bookmarkImageView.transform = bookmarkImageView.transform.scaledBy(x: 1.3, y: 1.3)
            bookmarkImageView.image = newImage
        }, completion: { _ in
            UIView.animate(withDuration: 0.1, animations: {
                self.bookmarkImageView.transform = CGAffineTransform.identity
            })
        })
        
    }
    
}

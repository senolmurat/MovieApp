//
//  MovieDetailViewController.swift
//  MovieApp
//
//  Created by Murat ŞENOL on 31.05.2022.
//

import UIKit

class MovieDetailViewController: UIViewController {
    
    var movieID : Int?
    let movieService = MovieService()

    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var releaseDateLable: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var bookmarkImageView: UIImageView!
    private var isFavourited : Bool = false
    
    //TODO: Add Cast and Tags , maybe horizontal scrool view or collection View
    //TODO: make image view scroolable  , maybe images with scenes from the movie
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let movieID = movieID{
            //AlertManager.showLoadingIndicator(in: self)
            movieService.getMovieDetail(id: movieID) { result in
                switch result {
                case .success(let response):
                    DispatchQueue.main.async {
                        self.configureMovieDetail(with: response)
                        //AlertManager.dismiss(in: self, animated: true)
                    }
                case .failure(let error):
                    //TODO: maybe show alertbox ?
                    print(error)
                }
            }
        }
        else{
            //TODO: Localization Support
            AlertManager.showInfoAlertBox(with: "Movie Not Found", in: self) { action in
                self.navigationController?.popViewController(animated: true)
            }
        }
        
        let bookmarkGesture = UITapGestureRecognizer(target: self, action:  #selector (self.bookmarkClicked(_:)))
        self.bookmarkImageView.addGestureRecognizer(bookmarkGesture)
        bookmarkImageView.isUserInteractionEnabled = true
    }
    
    func configureMovieDetail(with movie : Movie){
        if let posterPath = movie.posterPath{
            ImageManager.setImage(withPath: posterPath, on: movieImageView)
        }
        
        isFavourited = AppConfig.config.favouriteList.contains(movie.id)
        
        titleLabel.text = movie.title
        releaseDateLable.text = movie.releaseDate
        ratingLabel.text = String(movie.voteAverage)
        overviewLabel.text = movie.overview
        
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

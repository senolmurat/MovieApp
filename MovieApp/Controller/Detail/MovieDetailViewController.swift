//
//  MovieDetailViewController.swift
//  MovieApp
//
//  Created by Murat ŞENOL on 31.05.2022.
//

import UIKit

class MovieDetailViewController: UIViewController {
    
    var movieID : Int?
    var movie : Movie?
    let movieService = MovieService()
    var castList : [Cast] = []

    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var releaseDateLable: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var bookmarkImageView: UIImageView!
    @IBOutlet weak var genreCollectionView: UICollectionView!
    @IBOutlet weak var castCollectionView: UICollectionView!
    
    private var isFavourited : Bool = false
    
    //TODO: Add Cast and Tags , maybe horizontal scrool view or collection View
    //TODO: make image view scroolable  , maybe images with scenes from the movie
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        genreCollectionView.delegate = self
        genreCollectionView.dataSource = self
        
        castCollectionView.delegate = self
        castCollectionView.dataSource = self
        
        if let movieID = movieID{
            //AlertManager.showLoadingIndicator(in: self)
            movieService.getMovieDetail(id: movieID) { result in
                switch result {
                case .success(let response):
                    self.movie = response
                    DispatchQueue.main.async {
                        self.configureMovieDetail(with: response)
                        self.genreCollectionView.reloadData()
                        //AlertManager.dismiss(in: self, animated: true)
                    }
                    
                    self.movieService.getCredits(movieID: response.id) { result in
                        switch result {
                        case .success(let response):
                            //TODO: Maybe pagination ? Limit For now...
                            self.castList.append(contentsOf: response.cast.prefix(AppConfig.config.MovieDetailViewMaxCastLength))
                            DispatchQueue.main.async {
                                self.castCollectionView.reloadData()
                            }
                        case .failure(let error):
                            //TODO: maybe show alertbox ?
                            print(error)
                        }
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
        
        //genreCollectionView.register(GenreCell.self, forCellWithReuseIdentifier: K.GenreCellIdentifier)
        self.genreCollectionView.register(UINib(nibName: K.GenreCellNibName, bundle: nil), forCellWithReuseIdentifier: K.GenreCellIdentifier)
        self.castCollectionView.register(UINib(nibName: K.CastCellNibName, bundle: nil), forCellWithReuseIdentifier: K.CastCellIdentifier)
        
    }
    
    func configureMovieDetail(with movie : Movie){
        ImageManager.setImage(withPath: movie.posterPath, on: movieImageView)
        
        let finalColor = UIColor.systemBackground
        let initialColor = finalColor.withAlphaComponent(0.0)
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.type = .axial
        gradientLayer.colors = [initialColor.cgColor, finalColor.cgColor]
        gradientLayer.locations = [0, 1]
        //gradientLayer.frame = movieImageView.bounds
        gradientLayer.frame = CGRect(
            x: movieImageView.bounds.origin.x,
            y: movieImageView.bounds.origin.y + movieImageView.bounds.height / 2,
            width: movieImageView.bounds.width,
            height: movieImageView.bounds.height / 2)
        movieImageView.layer.addSublayer(gradientLayer)
        
        isFavourited = AppConfig.config.favouriteList.contains(movie.id)
        if(isFavourited){
            bookmarkImageView.image = UIImage(systemName: "bookmark.fill")
        }
        else{
            bookmarkImageView.image = UIImage(systemName: "bookmark")
        }
        
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


extension MovieDetailViewController : UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if(collectionView == genreCollectionView){
            return movie?.genres.count ?? 0
        }
        else if(collectionView == castCollectionView){
            return castList.count
        }
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if(collectionView == genreCollectionView){
            if let genre = movie?.genres[indexPath.row]{
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: K.GenreCellIdentifier, for: indexPath) as! GenreCell
                cell.configure(with: genre)
                return cell
            }
        }
        else if(collectionView == castCollectionView){
            let cast = castList[indexPath.row]
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: K.CastCellIdentifier, for: indexPath) as! CastCell
            cell.configure(with: cast)
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    
}

extension MovieDetailViewController : UICollectionViewDelegate{
    
}


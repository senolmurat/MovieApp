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
    
    var imageList : [MovieImage]?
    var imageIndex : Int = 0
    var totalImageCount : Int?
    
    var recommendationList : [MovieListResult] = []
    
    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var releaseDateLable: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var bookmarkImageView: UIImageView!
    
    @IBOutlet weak var genreCollectionView: UICollectionView!
    @IBOutlet weak var castCollectionView: UICollectionView!
    @IBOutlet weak var recommendationsCollectionView: UICollectionView!
    
    private var isFavourited : Bool = false
    
    //TODO: Add Cast and Tags , maybe horizontal scrool view or collection View
    //TODO: make image view scroolable  , maybe images with scenes from the movie
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        genreCollectionView.delegate = self
        genreCollectionView.dataSource = self
        
        castCollectionView.delegate = self
        castCollectionView.dataSource = self
        
        recommendationsCollectionView.delegate = self
        recommendationsCollectionView.dataSource = self
        
        if let movieID = movieID{
            //AlertManager.showLoadingIndicator(in: self)
            movieService.getMovieDetail(id: movieID) { result in
                switch result {
                case .success(let response):
                    self.movie = response
                    DispatchQueue.main.async {
                        self.title = response.title
                        self.configureMovieDetail(with: response)
                        self.genreCollectionView.reloadData()
                        //AlertManager.dismiss(in: self, animated: true)
                    }
                    
                    //TODO: Kinda unnecessary since backdrop images are a bunch of photoshopped posters ¯\_(ツ)_/¯
                    //GET Images
//                    self.movieService.getImages(movieID: response.id) { result in
//                        switch result {
//                        case .success(let response):
//                            self.imageList = response.backdrops
//                            self.totalImageCount = response.backdrops.count
//                        case .failure(let error):
//                            //TODO: maybe show alertbox ?
//                            print(error)
//                        }
//                    }
                    
                    //GET Recommendations
                    self.movieService.getRecommendations(id: response.id) { result in
                        switch result {
                        case .success(let response):
                            //TODO: Maybe pagination ? Limit For now...
                            self.recommendationList.append(contentsOf: response.results.prefix(AppConfig.config.MaxRecommendedMovieCount))
                            DispatchQueue.main.async {
                                self.recommendationsCollectionView.reloadData()
                            }
                        case .failure(let error):
                            //TODO: maybe show alertbox ?
                            print(error)
                        }
                    }
                        
                    //GET Credits
                    self.movieService.getCredits(movieID: response.id) { result in
                        switch result {
                        case .success(let response):
                            //TODO: Maybe pagination ? Limit For now...
                            self.castList.append(contentsOf: response.cast.prefix(AppConfig.config.MaxShowedCastCount))
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
        
        //MARK: - Required Gesture Recognizers
        let bookmarkClickGesture = UITapGestureRecognizer(target: self, action:  #selector (self.bookmarkClicked(_:)))
        self.bookmarkImageView.addGestureRecognizer(bookmarkClickGesture)
        bookmarkImageView.isUserInteractionEnabled = true
        
//        let imageSwipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(self.swiped(_:)))
//        self.movieImageView.addGestureRecognizer(imageSwipeGesture)
//        movieImageView.isUserInteractionEnabled = true
        
        //MARK: - Cell Registirations
        self.genreCollectionView.register(UINib(nibName: K.GenreCellNibName, bundle: nil), forCellWithReuseIdentifier: K.GenreCellIdentifier)
        self.castCollectionView.register(UINib(nibName: K.CastCellNibName, bundle: nil), forCellWithReuseIdentifier: K.CastCellIdentifier)
        self.recommendationsCollectionView.register(UINib(nibName: K.RecommendedMovieCellNibName, bundle: nil), forCellWithReuseIdentifier: K.RecommendedMovieCellIdentifier)
        
    }
    
    func configureMovieDetail(with movie : Movie){
        ImageManager.setImage(withPath: movie.posterPath, on: movieImageView , placeholder: UIImage(systemName: K.posterPlaceholder)!)
        
        let finalColor = UIColor.systemBackground
        let initialColor = finalColor.withAlphaComponent(0.0)
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.type = .axial
        gradientLayer.colors = [initialColor.cgColor, finalColor.cgColor]
        gradientLayer.locations = [0, 1]
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
    
    //MARK: - Gesture Recognizer Functions
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
    
    @objc func swiped(_ sender:UISwipeGestureRecognizer) {
        
        guard let totalImageCount = totalImageCount else {
            return
        }

        guard let imageList = imageList else {
            return
        }

        switch sender.direction {
        case UISwipeGestureRecognizer.Direction.right:
            imageIndex -= 1
            if imageIndex < 0 {
                imageIndex = totalImageCount - 1
            }
            ImageManager.setImage(withPath: imageList[imageIndex].filePath, on: movieImageView)
        case UISwipeGestureRecognizer.Direction.left:
            imageIndex += 1
            if imageIndex > totalImageCount {
                imageIndex = 0
            }
            ImageManager.setImage(withPath: imageList[imageIndex].filePath, on: movieImageView)
        default:
            break
        }
    }
}

//MARK: - Collection View Data Source Functions
extension MovieDetailViewController : UICollectionViewDataSource{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if(collectionView == genreCollectionView){
            if let movie = movie{
                return movie.genres.count
            }
        }
        else if(collectionView == castCollectionView){
            return castList.count
        }
        else if(collectionView == recommendationsCollectionView){
            return recommendationList.count
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
        else if(collectionView == recommendationsCollectionView){
            let movie = recommendationList[indexPath.row]
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: K.RecommendedMovieCellIdentifier, for: indexPath) as! RecommendedMovieCell
            cell.configure(with: movie)
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    
}

extension MovieDetailViewController : UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if(collectionView == castCollectionView){
            if let detailVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: String(describing: CastDetailViewController.self)) as? CastDetailViewController{
                
                //Preperation
                if let indexPath = collectionView.indexPathsForSelectedItems{
                    detailVC.personID = castList[indexPath[0].row].id
                    collectionView.deselectItem(at: indexPath[0], animated: false)
                }
                self.navigationController?.pushViewController(detailVC, animated: true)
            }
        }
    }
}

extension MovieDetailViewController: UICollectionViewDelegateFlowLayout {
    // https://medium.com/geekculture/swift-implement-self-sizing-uicollectionview-cells-in-6-line-of-code-or-less-bf4944d62f9
}


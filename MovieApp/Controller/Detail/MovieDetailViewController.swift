//
//  MovieDetailViewController.swift
//  MovieApp
//
//  Created by Murat ŞENOL on 31.05.2022.
//

import UIKit
import SafariServices
import Localize_Swift

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
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var bookmarkImageView: UIImageView!
    @IBOutlet weak var taglineLabel: UILabel!
    
    @IBOutlet weak var originalTitleLabel: UILabel!
    @IBOutlet weak var budgetInfoLabel: UILabel!
    @IBOutlet weak var revenueInfoLabel: UILabel!
    @IBOutlet weak var runtimeInfoLabel: UILabel!
    @IBOutlet weak var homepageInfoLabel: UILabel!
    @IBOutlet weak var companiesInfoLabel: UILabel!
    
    @IBOutlet weak var castTitleLabel: UILabel!
    @IBOutlet weak var additionalTitleLabel: UILabel!
    @IBOutlet weak var recommandationsTitleLabel: UILabel!
    
    @IBOutlet weak var genreCollectionView: UICollectionView!
    @IBOutlet weak var castCollectionView: UICollectionView!
    @IBOutlet weak var recommendationsCollectionView: UICollectionView!
    
    private var isFavourited : Bool = false
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        genreCollectionView.delegate = self
        genreCollectionView.dataSource = self
        
        castCollectionView.delegate = self
        castCollectionView.dataSource = self
        
        recommendationsCollectionView.delegate = self
        recommendationsCollectionView.dataSource = self
        
        if let movieID = movieID{
            AlertManager.showLoadingIndicator(in: self)
            movieService.getMovieDetail(id: movieID ,language: AppConfig.config.languageISO) { result in
                switch result {
                case .success(let response):
                    self.movie = response
                    DispatchQueue.main.async {
                        self.title = response.title
                        self.configureMovieDetail(with: response)
                        self.genreCollectionView.reloadData()
                        AlertManager.dismissLoadingIndicator(in: self)
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
                    self.movieService.getRecommendations(id: response.id , language: AppConfig.config.languageISO) { result in
                        switch result {
                        case .success(let response):
                            if response.results.count != 0 {
                                self.recommendationList.append(contentsOf: response.results.prefix(AppConfig.config.MaxRecommendedMovieCount))
                                DispatchQueue.main.async {
                                    self.recommendationsCollectionView.reloadData()
                                }
                            }
                            else{
                                self.recommendationsCollectionView.setEmptyMessage("recommended_list_na".localized())
                            }
                        case .failure(let error):
                            //TODO: maybe show alertbox ?
                            print(error)
                        }
                    }
                        
                    //GET Credits
                    self.movieService.getCredits(movieID: response.id , language: AppConfig.config.languageISO) { result in
                        switch result {
                        case .success(let response):                            
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
            AlertManager.showInfoAlertBox(with: "movie_na".localized(), in: self) { action in
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
    
    
    //MARK: - Page Configuration
    func configureMovieDetail(with movie : Movie){
        ImageManager.setImage(withPath: movie.posterPath, on: movieImageView , placeholder: UIImage(systemName: K.posterPlaceholder)!)
        
        guard let finalColor = view.backgroundColor else{
            return
        }
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
        bookmarkImageView.image = self.isFavourited ? UIImage(systemName: "bookmark.fill") : UIImage(systemName: "bookmark")
        
        titleLabel.text = movie.title
        
        
        if let releaseDate = movie.releaseDate{
            releaseDateLabel.text = releaseDate.tryLocalizedDate()
        }
        else{
            releaseDateLabel.text = "unknown".localized()
        }
        ratingLabel.text = String(movie.voteAverage)
        
        if let overview = movie.overview{
            overviewLabel.text = overview
        }
        else{
            overviewLabel.isHidden = true
        }
        
        if let tagline = movie.tagline{
            taglineLabel.text = tagline
        }
        else{
            taglineLabel.isHidden = true
        }
        
        originalTitleLabel.text = movie.originalTitle
        
        let currencyformatter = NumberFormatter()
        currencyformatter.locale = Locale(identifier: "en_US")
        currencyformatter.numberStyle = .currency
    
        budgetInfoLabel.text = (currencyformatter.string(from: movie.budget as NSNumber) ?? "not_available".localized())
        
        revenueInfoLabel.text = (currencyformatter.string(from: movie.revenue as NSNumber) ?? "not_available".localized())
        
        if let runtime = movie.runtime{
            runtimeInfoLabel.text = String(runtime / 60) + " " + "hour".localized() + " " + String(runtime % 60) + " " + "minute".localized()
        }
        else{
            runtimeInfoLabel.text = "not_available".localized()
        }
        
        if let homepage = movie.homepage{
            
            if let url = URL(string: homepage){
                let attributedString = NSMutableAttributedString(string: homepage)
                
                let linkRange = NSRange(location: 0, length: homepage.count)
                attributedString.setAttributes([.foregroundColor: UIColor.blue], range: linkRange)
                attributedString.setAttributes([.underlineStyle: NSUnderlineStyle.single.rawValue], range: linkRange)
                attributedString.setAttributes([.link: url], range: linkRange)

                self.homepageInfoLabel.attributedText = attributedString
                self.homepageInfoLabel.isUserInteractionEnabled = true
            }
            else{
                homepageInfoLabel.text = "not_available".localized()
            }
        }
        else{
            homepageInfoLabel.text = "not_available".localized()
        }
        
        companiesInfoLabel.text = movie.productionCompaniesCSV
        
    }
    
    //MARK: - Gesture Recognizer Functions
    @objc func bookmarkClicked(_ sender:UITapGestureRecognizer){
        Movie.configureFavouriteList(with: movieID!, imageView: bookmarkImageView, isAlreadyFavourited: &isFavourited)
    }
    
    
    @IBAction func homepageLinkClicked(_ sender: UITapGestureRecognizer) {
        guard let movie = movie else {
            return
        }

        if let homepage = movie.homepage{
            let vc = SFSafariViewController(url: URL(string: homepage)!)
            present(vc , animated: true)
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

//MARK: - CollectionView Delegate Functions
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
        else if (collectionView == recommendationsCollectionView){
            if let detailVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: String(describing: MovieDetailViewController.self)) as? MovieDetailViewController{
                
                //Preperation
                if let indexPath = collectionView.indexPathsForSelectedItems{
                    detailVC.movieID = recommendationList[indexPath[0].row].id
                    collectionView.deselectItem(at: indexPath[0], animated: false)
                }
                self.navigationController?.pushViewController(detailVC, animated: true)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if(collectionView == castCollectionView){
            let castCell = cell as? CastCell
            castCell?.castImageView.kf.cancelDownloadTask()
        }
        else if(collectionView == recommendationsCollectionView){
            let movieCell = cell as? RecommendedMovieCell
            movieCell?.posterImageView.kf.cancelDownloadTask()
        }
    }
}

//MARK: - CollectionView FlowLayout Functions
extension MovieDetailViewController: UICollectionViewDelegateFlowLayout {
    // https://medium.com/geekculture/swift-implement-self-sizing-uicollectionview-cells-in-6-line-of-code-or-less-bf4944d62f9
    
}

//
//  MovieViewController.swift
//  MovieApp
//
//  Created by Murat ŞENOL on 30.05.2022.
//

import UIKit
import Localize_Swift
import Network

class MovieViewController: UIViewController {
    
    @IBOutlet weak var moviesTabBarItem: UITabBarItem!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var upcomingCollectionView: UICollectionView!
    @IBOutlet weak var nowPlayingCollectionView: UICollectionView!
    @IBOutlet weak var popularCollectionView: UICollectionView!
    @IBOutlet weak var discoverCollectionView: UICollectionView!
    
    private let movieService = MovieService()
    private var popularMovieList : [MovieListResult] = []
    private var popularListPageCounter : Int = 1
    private var totalPopularMovieCount: Int?
    
    private var upcomingMovieList : [MovieListResult] = []
    private var upcomingListPageCounter : Int = 1
    private var totalUpcomingMovieCount: Int?
    private var nowPlayingMovieList : [MovieListResult] = []
    private var nowPlayingListPageCounter : Int = 1
    private var totalNowPlayingMovieCount: Int?
    private var discoverMovieList : [MovieListResult] = []
    private var discoverPageCounter : Int = 1
    private var totalDiscoverMovieCount: Int?
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = (view.bounds.width / 16) * 9 + (MovieCell().inset * 2)
        
        upcomingCollectionView.delegate = self
        upcomingCollectionView.dataSource = self
        
        nowPlayingCollectionView.delegate = self
        nowPlayingCollectionView.dataSource = self
        
        popularCollectionView.delegate = self
        popularCollectionView.dataSource = self
        
        discoverCollectionView.delegate = self
        discoverCollectionView.dataSource = self
        
        tableView.isHidden = false
        scrollView.isHidden = true
        
        title = K.appNameWithEmoji
        if let moviesTabBarItem = navigationController?.tabBarItem{
            moviesTabBarItem.title = "movies_tab_title".localized()
            moviesTabBarItem.image = UIImage(systemName: "film")
            moviesTabBarItem.selectedImage = UIImage(systemName: "film")
        }
        
        //TODO: Internet Connection Check
//        let monitor = NWPathMonitor()
//        monitor.pathUpdateHandler = { path in
//            if path.status == .satisfied {
//                print("Connected to Internet!")
//            } else {
//                print("No Internet connection.")
//                AlertManager.showInfoAlertBox(with: "Device is not connected to the internet. App will still run but it may not function correctly.", errorTitle: "Network Error" ,in: self, handler: nil)
//            }
//
//            print("Expensive Connection : \(path.isExpensive)")
//        }
//        let queue = DispatchQueue(label: "Connection Monitor")
//        monitor.start(queue: queue)
        
        tableView.register(UINib(nibName: K.MovieListCellNibName, bundle: nil), forCellReuseIdentifier: K.MovieListCellIdentifier)
        
        AlertManager.showLoadingIndicator(in: self)
        //NOTE: DispatchGroup - To determine to last ending async function
        
        movieService.getPopular(page: popularListPageCounter ,language: AppConfig.config.languageISO){ result in
            switch result {
            case .success(let response):
                self.popularListPageCounter += 1
                self.totalPopularMovieCount = response.totalResults
                self.popularMovieList.append(contentsOf: response.results)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.popularCollectionView.reloadData()
                    AlertManager.dismissLoadingIndicator(in: self)
                }
            case .failure(let error):
                print(error)
            }
        }
        
        movieService.getUpcoming(page: upcomingListPageCounter ,language: AppConfig.config.languageISO){ result in
            switch result {
            case .success(let response):
                self.upcomingListPageCounter += 1
                self.totalUpcomingMovieCount = response.totalResults
                self.upcomingMovieList.append(contentsOf: response.results)
                DispatchQueue.main.async {
                    self.upcomingCollectionView.reloadData()
                    AlertManager.dismissLoadingIndicator(in: self)
                }
            case .failure(let error):
                print(error)
            }
        }
        
        movieService.getNowPlaying(page: nowPlayingListPageCounter ,language: AppConfig.config.languageISO){ result in
            switch result {
            case .success(let response):
                self.nowPlayingListPageCounter += 1
                self.totalNowPlayingMovieCount = response.totalResults
                self.nowPlayingMovieList.append(contentsOf: response.results)
                DispatchQueue.main.async {
                    self.nowPlayingCollectionView.reloadData()
                    AlertManager.dismissLoadingIndicator(in: self)
                }
            case .failure(let error):
                print(error)
            }
        }
        
        movieService.getDiscover(page: nowPlayingListPageCounter ,language: AppConfig.config.languageISO , sortBy: SortBy.vote_count_desc.rawValue , minVoteCount: 1000){ result in
            switch result {
            case .success(let response):
                self.discoverPageCounter += 1
                self.totalDiscoverMovieCount = response.totalResults
                self.discoverMovieList.append(contentsOf: response.results)
                DispatchQueue.main.async {
                    self.discoverCollectionView.reloadData()
                    AlertManager.dismissLoadingIndicator(in: self)
                }
            case .failure(let error):
                print(error)
            }
        }
        
        self.upcomingCollectionView.register(UINib(nibName: K.RecommendedMovieCellNibName, bundle: nil), forCellWithReuseIdentifier: K.RecommendedMovieCellIdentifier)
        self.nowPlayingCollectionView.register(UINib(nibName: K.RecommendedMovieCellNibName, bundle: nil), forCellWithReuseIdentifier: K.RecommendedMovieCellIdentifier)
        self.popularCollectionView.register(UINib(nibName: K.RecommendedMovieCellNibName, bundle: nil), forCellWithReuseIdentifier: K.RecommendedMovieCellIdentifier)
        self.discoverCollectionView.register(UINib(nibName: K.RecommendedMovieCellNibName, bundle: nil), forCellWithReuseIdentifier: K.RecommendedMovieCellIdentifier)
    }
    
    //MARK: - Populate Table/Collection View
    func populate(view : UIScrollView){
        
    }
    
    //MARK: - List View Changing Table/Collection
    @IBAction func listBarButtonClicked(_ sender: UIBarButtonItem) {
        if(tableView.isHidden){
            tableView.isHidden = false
            tableView.reloadData()
            scrollView.isHidden = true
        }
    }
    
    @IBAction func tableBarButtonClicked(_ sender: UIBarButtonItem) {
        if(scrollView.isHidden){
            scrollView.isHidden = false
            popularCollectionView.reloadData()
            tableView.isHidden = true
        }
    }
}


extension MovieViewController: UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return popularMovieList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let movie = popularMovieList[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: K.MovieListCellIdentifier, for: indexPath) as! MovieCell
        cell.configureMovie(with: movie)
        return cell
    }
    
}

//MARK: - TableView Delegate Methods
extension MovieViewController: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == popularMovieList.count - 1{
            
            guard let totalMovieCount = totalPopularMovieCount else{
                return
            }
            
            //Check if there are anymore characters to load
            if popularMovieList.count < totalMovieCount{
                //Load more content
                AlertManager.showTableViewLoadingIndicator(for: tableView, in: self)
                
                movieService.getPopular(page: popularListPageCounter , language: AppConfig.config.languageISO){ result in
                    switch result {
                    case .success(let response):
                        self.popularListPageCounter += 1
                        self.popularMovieList.append(contentsOf: response.results)
                        self.tableView.reloadData()
                    case .failure(let error):
                        print(error)
                    }
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let detailVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: String(describing: MovieDetailViewController.self)) as? MovieDetailViewController{
            
            //Preperation
            if let indexPath = tableView.indexPathForSelectedRow{
                detailVC.movieID = popularMovieList[indexPath.row].id
                tableView.deselectRow(at: indexPath, animated: false)
            }
            self.navigationController?.pushViewController(detailVC, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let movieCell = cell as? MovieCell
        movieCell?.posterImageView.kf.cancelDownloadTask()
        movieCell?.backdropImageView.kf.cancelDownloadTask()
    }
}

//MARK: - Collection View Data Source Functions
extension MovieViewController : UICollectionViewDataSource{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if(collectionView == upcomingCollectionView){
            return upcomingMovieList.count
        }
        else if(collectionView == nowPlayingCollectionView){
            return nowPlayingMovieList.count
        }
        else if(collectionView == popularCollectionView){
            return popularMovieList.count
        }
        else if(collectionView == discoverCollectionView){
            return discoverMovieList.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if(collectionView == upcomingCollectionView){
            let movie = upcomingMovieList[indexPath.row]
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: K.RecommendedMovieCellIdentifier, for: indexPath) as! RecommendedMovieCell
            cell.configure(with: movie)
            return cell
        }
        else if(collectionView == nowPlayingCollectionView){
            let movie = nowPlayingMovieList[indexPath.row]
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: K.RecommendedMovieCellIdentifier, for: indexPath) as! RecommendedMovieCell
            cell.configure(with: movie)
            return cell
        }
        else if(collectionView == popularCollectionView){
            let movie = popularMovieList[indexPath.row]
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: K.RecommendedMovieCellIdentifier, for: indexPath) as! RecommendedMovieCell
            cell.configure(with: movie)
            return cell
        }
        else if(collectionView == discoverCollectionView){
            let movie = discoverMovieList[indexPath.row]
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: K.RecommendedMovieCellIdentifier, for: indexPath) as! RecommendedMovieCell
            cell.configure(with: movie)
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    
}

//MARK: - CollectionView Delegate Functions
extension MovieViewController : UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if(collectionView == upcomingCollectionView){
            if let detailVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: String(describing: MovieDetailViewController.self)) as? MovieDetailViewController{
                
                //Preperation
                if let indexPath = collectionView.indexPathsForSelectedItems{
                    detailVC.movieID = upcomingMovieList[indexPath[0].row].id
                    collectionView.deselectItem(at: indexPath[0], animated: false)
                }
                self.navigationController?.pushViewController(detailVC, animated: true)
            }
        }
        else if (collectionView == nowPlayingCollectionView){
            if let detailVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: String(describing: MovieDetailViewController.self)) as? MovieDetailViewController{
                
                //Preperation
                if let indexPath = collectionView.indexPathsForSelectedItems{
                    detailVC.movieID = nowPlayingMovieList[indexPath[0].row].id
                    collectionView.deselectItem(at: indexPath[0], animated: false)
                }
                self.navigationController?.pushViewController(detailVC, animated: true)
            }
        }
        else if (collectionView == popularCollectionView){
            if let detailVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: String(describing: MovieDetailViewController.self)) as? MovieDetailViewController{
                
                //Preperation
                if let indexPath = collectionView.indexPathsForSelectedItems{
                    detailVC.movieID = popularMovieList[indexPath[0].row].id
                    collectionView.deselectItem(at: indexPath[0], animated: false)
                }
                self.navigationController?.pushViewController(detailVC, animated: true)
            }
        }
        else if (collectionView == discoverCollectionView){
            if let detailVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: String(describing: MovieDetailViewController.self)) as? MovieDetailViewController{
                
                //Preperation
                if let indexPath = collectionView.indexPathsForSelectedItems{
                    detailVC.movieID = discoverMovieList[indexPath[0].row].id
                    collectionView.deselectItem(at: indexPath[0], animated: false)
                }
                self.navigationController?.pushViewController(detailVC, animated: true)
            }
        }
    }
    
    //Pagination
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if(collectionView == upcomingCollectionView){
            if indexPath.row == upcomingMovieList.count - 1{
                
                guard let totalMovieCount = totalUpcomingMovieCount else{
                    return
                }
                
                //Check if there are anymore characters to load
                if upcomingMovieList.count < totalMovieCount{
                    //Load more content
                    //AlertManager.showTableViewLoadingIndicator(for: tableView, in: self)
                    
                    movieService.getUpcoming(page: upcomingListPageCounter ,language: AppConfig.config.languageISO){ result in
                        switch result {
                        case .success(let response):
                            self.upcomingListPageCounter += 1
                            self.upcomingMovieList.append(contentsOf: response.results)
                            DispatchQueue.main.async {
                                self.upcomingCollectionView.reloadData()
                                //AlertManager.dismissLoadingIndicator(in: self)
                            }
                        case .failure(let error):
                            print(error)
                        }
                    }
                }
            }
        }
        else if(collectionView == nowPlayingCollectionView){
            if indexPath.row == nowPlayingMovieList.count - 1{
                
                guard let totalMovieCount = totalNowPlayingMovieCount else{
                    return
                }
                
                //Check if there are anymore characters to load
                if popularMovieList.count < totalMovieCount{
                    //Load more content
                    //AlertManager.showTableViewLoadingIndicator(for: tableView, in: self)
                    
                    movieService.getNowPlaying(page: nowPlayingListPageCounter ,language: AppConfig.config.languageISO){ result in
                        switch result {
                        case .success(let response):
                            self.nowPlayingListPageCounter += 1
                            self.nowPlayingMovieList.append(contentsOf: response.results)
                            DispatchQueue.main.async {
                                self.nowPlayingCollectionView.reloadData()
                                //AlertManager.dismissLoadingIndicator(in: self)
                            }
                        case .failure(let error):
                            print(error)
                        }
                    }
                }
            }
        }
        else if(collectionView == popularCollectionView){
            if indexPath.row == popularMovieList.count - 1{
                
                guard let totalMovieCount = totalPopularMovieCount else{
                    return
                }
                
                //Check if there are anymore characters to load
                if popularMovieList.count < totalMovieCount{
                    //Load more content
                    //AlertManager.showTableViewLoadingIndicator(for: tableView, in: self)
                    
                    movieService.getPopular(page: popularListPageCounter , language: AppConfig.config.languageISO){ result in
                        switch result {
                        case .success(let response):
                            self.popularListPageCounter += 1
                            self.popularMovieList.append(contentsOf: response.results)
                            self.popularCollectionView.reloadData()
                        case .failure(let error):
                            print(error)
                        }
                    }
                }
            }
        }
        else if(collectionView == discoverCollectionView){
            if indexPath.row == discoverMovieList.count - 1{
                
                guard let totalMovieCount = totalDiscoverMovieCount else{
                    return
                }
                
                //Check if there are anymore characters to load
                if discoverMovieList.count < totalMovieCount{
                    //Load more content
                    //AlertManager.showTableViewLoadingIndicator(for: tableView, in: self)
                    
                    movieService.getDiscover(page: nowPlayingListPageCounter ,language: AppConfig.config.languageISO , sortBy: SortBy.vote_count_desc.rawValue , minVoteCount: 1000){ result in
                        switch result {
                        case .success(let response):
                            self.discoverPageCounter += 1
                            self.discoverMovieList.append(contentsOf: response.results)
                            DispatchQueue.main.async {
                                self.discoverCollectionView.reloadData()
                                AlertManager.dismissLoadingIndicator(in: self)
                            }
                        case .failure(let error):
                            print(error)
                        }
                    }
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let movieCell = cell as? RecommendedMovieCell
        movieCell?.posterImageView.kf.cancelDownloadTask()
    }
}

//MARK: - CollectionView FlowLayout Functions
extension MovieViewController: UICollectionViewDelegateFlowLayout {
    // https://medium.com/geekculture/swift-implement-self-sizing-uicollectionview-cells-in-6-line-of-code-or-less-bf4944d62f9
    
}



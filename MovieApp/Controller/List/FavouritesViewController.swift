//
//  FavouritesViewController.swift
//  MovieApp
//
//  Created by Murat ŞENOL on 30.05.2022.
//

import UIKit
import Localize_Swift

class FavouritesViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    private let movieService = MovieService()
    private var favouriteMovieIDList : [Int] = AppConfig.config.favouriteList
    private var favouriteMovieList : [Movie] = []
    private var pageCounter : Int = 1
    private var totalMovieCount: Int?
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        totalMovieCount = favouriteMovieIDList.count
        
        for movieID in favouriteMovieIDList{
            print(movieID)
        }
        print("Total : \(favouriteMovieIDList.count)")
        
        if(AppConfig.config.reloadFavouriteList){
            loadData()
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    //TODO: Sort by Bar Button item maybe ?
    //TODO: Search in favourites list ?
    //TODO: save scrool position before reloading tableView data
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.rowHeight = 136
        
        totalMovieCount = favouriteMovieIDList.count
        
        title = "favourites_tab_title".localized()
        if let favouritesTabBarItem = navigationController?.tabBarItem{
            favouritesTabBarItem.title = "favourites_tab_title".localized()
            favouritesTabBarItem.image = UIImage(systemName: "star.fill")
            favouritesTabBarItem.selectedImage = UIImage(systemName: "star.fill")
        }

        tableView.register(UINib(nibName: K.MovieListLessDetailNibName, bundle: nil), forCellReuseIdentifier: K.MovieListLessDetailCellIdentifier)
        
    }
    
    func loadData(){
        //Maybe hold the entire movie object instead of just the id ?
        let movieGroup = DispatchGroup()
        
        favouriteMovieIDList = AppConfig.config.favouriteList
        favouriteMovieList.removeAll()
        for movieID in favouriteMovieIDList{
            movieGroup.enter()
            movieService.getMovieDetail(id: movieID , language: AppConfig.config.languageISO) { [self] result in
                switch result {
                case .success(let response):
                    favouriteMovieList.append(response)
                    movieGroup.leave()
                case .failure(let error):
                    
                    print(error)
                    movieGroup.leave()
                }
            }
        }
        movieGroup.notify(queue: .main){
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            AppConfig.config.reloadFavouriteList = false
        }
    }
    
    
    @IBAction func trashBarButtonClicked(_ sender: UIBarButtonItem) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "confirm".localized(), message: "favourites_delete_list_warning".localized(), preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "no".localized(), style: UIAlertAction.Style.cancel, handler: { action in
                //do nothing
            }))
            alert.addAction(UIAlertAction(title: "yes".localized(), style: UIAlertAction.Style.destructive, handler: { action in
                AppConfig.config.favouriteList.removeAll()
                self.favouriteMovieList.removeAll()
                self.tableView.reloadData()
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
}

//MARK: - TableView Data Source Methods
extension FavouritesViewController: UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if favouriteMovieList.count == 0 {
            self.tableView.setEmptyMessage("favourites_empty".localized())
        } else {
            self.tableView.restore()
        }
        return favouriteMovieList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let movie = favouriteMovieList[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: K.MovieListLessDetailCellIdentifier, for: indexPath) as! MovieLessDetailCell
        cell.configureMovie(with: movie)
        return cell
    }
    
}

//MARK: - TableView Delegate Methods
extension FavouritesViewController: UITableViewDelegate{
    
//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        if indexPath.row == favouriteMovieList.count - 1{
//
//            guard let totalMovieCount = totalMovieCount else{
//                return
//            }
//
//            //Check if there are anymore characters to load
//            if favouriteMovieList.count < totalMovieCount{
//                //Load more content
//                //AlertManager.showLoadingIndicator(in: self)
//                AlertManager.showTableViewLoadingIndicator(for: tableView, in: self)
//
//                let movieGroup = DispatchGroup()
//
//                let currentPageStart = AppConfig.config.MaxMovieCountPerPageFavouriteList * pageCounter
//                var currentPageEnd = AppConfig.config.MaxMovieCountPerPageFavouriteList * (pageCounter + 1)
//                if(currentPageEnd >= totalMovieCount){
//                    currentPageEnd = totalMovieCount - 1
//                }
//
//                for movieID in favouriteMovieIDList[currentPageStart...(currentPageEnd)]{
//                    movieGroup.enter()
//                    movieService.getMovieDetail(id: movieID , language: AppConfig.config.languageISO) { [self] result in
//                        switch result {
//                        case .success(let response):
//                            favouriteMovieList.append(response)
//                            movieGroup.leave()
//                        case .failure(let error):
//
//                            print(error)
//                            movieGroup.leave()
//                        }
//                    }
//                }
//                movieGroup.notify(queue: .main){
//                    AlertManager.hideTableViewLoadingIndicator(for: tableView, in: self)
//                    self.pageCounter += 1
//                    DispatchQueue.main.async {
//                        self.tableView.reloadData()
//                    }
//                }
//            }
//        }
//    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let detailVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: String(describing: MovieDetailViewController.self)) as? MovieDetailViewController{
            
            //Preperation
            if let indexPath = tableView.indexPathForSelectedRow{
                detailVC.movieID = favouriteMovieList[indexPath.row].id
                tableView.deselectRow(at: indexPath, animated: false)
            }
            self.navigationController?.pushViewController(detailVC, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let movieCell = cell as? MovieLessDetailCell
        movieCell?.posterImageView.kf.cancelDownloadTask()
    }
}

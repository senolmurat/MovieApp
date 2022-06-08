//
//  FavouritesViewController.swift
//  MovieApp
//
//  Created by Murat ŞENOL on 30.05.2022.
//

import UIKit

class FavouritesViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    private let movieService : MovieServiceProtocol = MovieService()
    private var favouriteMovieIDList : [Int] = AppConfig.config.favouriteList
    private var favouriteMovieList : [Movie] = []
    private var pageCounter : Int = 1
    private var totalMovieCount: Int?
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        loadData()
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        totalMovieCount = favouriteMovieIDList.count
        
        //TODO: maybe show a text like "your favourite list is empty" ?
        //TODO: Localization
        title = "Favourites"

        tableView.register(UINib(nibName: K.MovieListCellNibName, bundle: nil), forCellReuseIdentifier: K.MovieListCellIdentifier)
        
    }
    
    func loadData(){
        //Maybe hold the entire movie object instead of just the id ?
        favouriteMovieIDList = AppConfig.config.favouriteList
        favouriteMovieList.removeAll()
        for movieID in favouriteMovieIDList{
            movieService.getMovieDetail(id: movieID) { [self] result in
                switch result {
                case .success(let response):
                    favouriteMovieList.append(response)
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                    print(error)
                }
            }
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
            self.tableView.setEmptyMessage("Your Favourite Movies List is empty...")
        } else {
            self.tableView.restore()
        }
        return favouriteMovieList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let movie = favouriteMovieList[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: K.MovieListCellIdentifier, for: indexPath) as! MovieCell
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
//                movieService.getPopular(page: pageCounter){ result in
//                    switch result {
//                    case .success(let response):
//                        self.pageCounter += 1
//                        self.favouriteMovieList.append(contentsOf: response.results)
//                        self.tableView.reloadData()
//                    case .failure(let error):
//                        print(error)
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
}

//
//  MovieViewController.swift
//  MovieApp
//
//  Created by Murat ŞENOL on 30.05.2022.
//

import UIKit

class MovieViewController: UIViewController {
    
    @IBOutlet weak var moviesTabBarItem: UITabBarItem!
    @IBOutlet weak var tableView: UITableView!
    
    
    private let movieService : MovieServiceProtocol = MovieService()
    private var movieList : [MovieListResult] = []
    private var pageCounter : Int = 1
    private var totalMovieCount: Int?
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        title = K.appNameWithEmoji
        if let moviesTabBarItem = navigationController?.tabBarItem{
            moviesTabBarItem.title = "Movies"
            moviesTabBarItem.image = UIImage(systemName: "film")
            moviesTabBarItem.selectedImage = UIImage(systemName: "film")
        }
        
        
        tableView.register(UINib(nibName: K.MovieListCellNibName, bundle: nil), forCellReuseIdentifier: K.MovieListCellIdentifier)
        
        AlertManager.showLoadingIndicator(in: self)
        movieService.getPopular(page: pageCounter){ result in
            switch result {
            case .success(let response):
                self.pageCounter += 1
                self.totalMovieCount = response.totalResults
                self.movieList.append(contentsOf: response.results)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    AlertManager.dismissLoadingIndicator(in: self)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
}


extension MovieViewController: UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movieList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let movie = movieList[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: K.MovieListCellIdentifier, for: indexPath) as! MovieCell
        cell.configureMovie(with: movie)
        return cell
    }
    
}

//MARK: - TableView Delegate Methods
extension MovieViewController: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == movieList.count - 1{
            
            guard let totalMovieCount = totalMovieCount else{
                return
            }
            
            //Check if there are anymore characters to load
            if movieList.count < totalMovieCount{
                //Load more content
                //AlertManager.showLoadingIndicator(in: self)
                AlertManager.showTableViewLoadingIndicator(for: tableView, in: self)
                
                movieService.getPopular(page: pageCounter){ result in
                    switch result {
                    case .success(let response):
                        self.pageCounter += 1
                        self.movieList.append(contentsOf: response.results)
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
                detailVC.movieID = movieList[indexPath.row].id
                tableView.deselectRow(at: indexPath, animated: false)
            }
            self.navigationController?.pushViewController(detailVC, animated: true)
        }
    }
}



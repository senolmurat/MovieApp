//
//  SearchViewController.swift
//  MovieApp
//
//  Created by Murat ŞENOL on 30.05.2022.
//

import UIKit

class SearchViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var popularActorsLabel: UILabel!
    @IBOutlet weak var movieGenresLabel: UILabel!
    
    @IBOutlet weak var popularActorsCollectionView: UICollectionView!
    @IBOutlet weak var movieGenresCollectionView: UICollectionView!
    
    var tableView : UITableView!
    
    var genreList : [Genre] = []
    var peopleList : [PeopleListResult] = []
    var searchResult : [MovieListResult] = []
    
    var pageCounter : Int = 1
    var totalResultCount : Int?
    let searchService = SearchService()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        popularActorsCollectionView.delegate = self
        popularActorsCollectionView.dataSource = self
        
        movieGenresCollectionView.delegate = self
        movieGenresCollectionView.dataSource = self
        
        //var leftNavBarButton = UIBarButtonItem(customView:searchBar)
        //self.navigationItem.leftBarButtonItem = leftNavBarButton
        searchBar.delegate = self
        searchBar.sizeToFit()
        navigationItem.titleView = searchBar
        
        let navigationBarHeight: CGFloat = self.navigationController?.navigationBar.frame.height ?? 0
        let tabBarHeight: CGFloat = self.navigationController?.tabBarController?.tabBar.frame.height ?? 0
        let displayWidth: CGFloat = self.view.frame.width
        let displayHeight: CGFloat = self.view.frame.height

        tableView = UITableView(frame: CGRect(x: 0, y: navigationBarHeight, width: displayWidth, height: displayHeight - (navigationBarHeight + tabBarHeight)))
        tableView.dataSource = self
        tableView.delegate = self
        tableView.isHidden = true
        self.view.addSubview(tableView)
        
        
        //TODO: Localization
        GenreService().getMovieGenreList(language: "en-US", completion: { [self] result in
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    genreList = response.genres
                    movieGenresCollectionView.reloadData()
                }
            case .failure(let error):
                //TODO: Network Error , Could not retrive genre lsit for movies
                print(error)
            }
        })
        
        //TODO: Localization
        PersonService().getPopular(page: 1, language: "en-US") { result in
            switch result {
            case .success(let response):
                DispatchQueue.main.async { [self] in
                    peopleList = response.results
                    popularActorsCollectionView.reloadData()
                }
            case .failure(let error):
                //TODO: Network Error , Could not retrive genre lsit for movies
                print(error)
            }
        }

        self.movieGenresCollectionView.register(UINib(nibName: K.GenreCellNibName, bundle: nil), forCellWithReuseIdentifier: K.GenreCellIdentifier)
        self.popularActorsCollectionView.register(UINib(nibName: K.CastPicCellNibName, bundle: nil), forCellWithReuseIdentifier: K.CastPicCellIdentifier)
        self.tableView.register(UINib(nibName: K.MovieListCellNibName, bundle: nil), forCellReuseIdentifier: K.MovieListCellIdentifier)
    }
    
    func search(with query : String){
        AlertManager.showLoadingIndicator(in: self)
        tableView.isHidden = false
        searchService.searchMovie(query: query) { result in
            switch result {
            case .success(let response):
                self.searchResult = response.results
                self.pageCounter = 1
                self.totalResultCount = response.totalResults
                DispatchQueue.main.async { [self] in
                    tableView.reloadData()
                }
                AlertManager.dismissLoadingIndicator(in: self)
            case .failure(let error):
                //TODO: Network Error , Could not retrive genre lsit for movies
                print(error)
            }
        }
    }
    
}

//MARK: - CollectionView Data Source Functions
extension SearchViewController: UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if(collectionView == movieGenresCollectionView){
            return genreList.count
        }
        else if(collectionView == popularActorsCollectionView){
            return peopleList.count
        }
            
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if(collectionView == movieGenresCollectionView){
            let genre = genreList[indexPath.row]
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: K.GenreCellIdentifier, for: indexPath) as! GenreCell
            cell.configure(with: genre)
            return cell
        }
        else if(collectionView == popularActorsCollectionView){
            let people  = peopleList[indexPath.row]
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: K.CastPicCellIdentifier, for: indexPath) as! CastPicCell
            cell.configure(with: people)
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    
}

//MARK: - CollectionView Delegate Functions
extension SearchViewController: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if(collectionView == movieGenresCollectionView){
            
        }
        else if (collectionView == popularActorsCollectionView){
            if let detailVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: String(describing: CastDetailViewController.self)) as? CastDetailViewController{
                
                //Preperation
                if let indexPath = collectionView.indexPathsForSelectedItems{
                    detailVC.personID = peopleList[indexPath[0].row].id
                    collectionView.deselectItem(at: indexPath[0], animated: false)
                }
                self.navigationController?.pushViewController(detailVC, animated: true)
            }
        }
    }
}

extension SearchViewController : UISearchBarDelegate{
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.endEditing(true)
        AlertManager.dismissLoadingIndicator(in: self)
        tableView.isHidden = true
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if(searchText == ""){
            searchBar.endEditing(true)
            tableView.isHidden = true
        }
        else if (searchText.count >= 3){
            tableView.isHidden = false
            AlertManager.dismissLoadingIndicator(in: self)
            search(with: searchText)
        }
        
    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        if let text = searchBar.text{
            if text.count < 3{
                return false
            }
        }
        return true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        
        guard let query = searchBar.text else{
            return
        }
        
        search(with: query)
    }
    
}

//MARK: - UITableViewDelegate Functions
extension SearchViewController: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == searchResult.count - 1{
            
            guard let totalResultCount = totalResultCount else{
                return
            }
            
            guard let query = searchBar.text else{
                return
            }
            
            //Check if there are anymore characters to load
            if searchResult.count < totalResultCount{
                //Load more content
                //AlertManager.showLoadingIndicator(in: self)
                AlertManager.showTableViewLoadingIndicator(for: tableView, in: self)
                
                searchService.searchMovie(query: query , page: pageCounter) { result in
                    switch result {
                    case .success(let response):
                        self.searchResult.append(contentsOf: response.results)
                        self.pageCounter += 1
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                        AlertManager.dismissLoadingIndicator(in: self)
                    case .failure(let error):
                        //TODO: Network Error , Could not retrive genre lsit for movies
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
                detailVC.movieID = searchResult[indexPath.row].id
                tableView.deselectRow(at: indexPath, animated: false)
            }
            self.navigationController?.pushViewController(detailVC, animated: true)
        }
    }
}

//MARK: - UITableViewDataSource Functions
extension SearchViewController: UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResult.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let movie = searchResult[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: K.MovieListCellIdentifier, for: indexPath) as! MovieCell
        cell.configureMovie(with: movie)
        return cell
    }
    
    
}

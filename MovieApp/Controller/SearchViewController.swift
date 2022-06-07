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
    
    var genreList : [Genre] = []
    var peopleList : [PeopleListResult] = []
    
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
        searchBar.sizeToFit()
        navigationItem.titleView = searchBar
        
        
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

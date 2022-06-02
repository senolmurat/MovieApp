//
//  RecommendedMovieCell.swift
//  MovieApp
//
//  Created by Murat ŞENOL on 2.06.2022.
//

import UIKit

class RecommendedMovieCell: UICollectionViewCell {

    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(with movie : MovieListResult){
        titleLabel.text = movie.title
        ImageManager.setImage(withPath: movie.posterPath, on: posterImageView, placeholder: UIImage(systemName: K.posterPlaceholder)!)
    }

}

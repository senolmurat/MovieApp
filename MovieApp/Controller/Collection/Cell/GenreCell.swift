//
//  CollectionViewCell.swift
//  MovieApp
//
//  Created by Murat ŞENOL on 2.06.2022.
//

import UIKit

class GenreCell: UICollectionViewCell {

    @IBOutlet weak var genreLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        genreLabel.layer.cornerRadius = 2.0
        genreLabel.clipsToBounds = true
    }
    
    func configure(with genre : Genre){
        genreLabel.text = genre.name
        
    }

}

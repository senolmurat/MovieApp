//
//  CollectionViewCell.swift
//  MovieApp
//
//  Created by Murat ŞENOL on 2.06.2022.
//

import UIKit

class GenreCell: UICollectionViewCell {

    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var view: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        view.layer.cornerRadius = 6.0
        view.clipsToBounds = true
    }
    
    func configure(with genre : Genre){
        genreLabel.text = genre.name
        
    }

}

//
//  CastCell.swift
//  MovieApp
//
//  Created by Murat ŞENOL on 2.06.2022.
//

import UIKit

class CastCell: UICollectionViewCell {

    @IBOutlet weak var castImageView: UIImageView!
    @IBOutlet weak var characterNameLabel: UILabel!
    @IBOutlet weak var castNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(with cast : Cast){
        
        characterNameLabel.text = cast.character
        castNameLabel.text = cast.name
        //ImageManager.setImageRounded(withPath: cast.profilePath, on: castImageView, cornerRadius: castImageView.bounds.width)
        ImageManager.setImage(withPath: cast.profilePath, on: castImageView)
        
    }

}

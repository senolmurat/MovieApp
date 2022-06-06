//
//  CastPicCell.swift
//  MovieApp
//
//  Created by Murat ŞENOL on 6.06.2022.
//

import UIKit

class CastPicCell: UICollectionViewCell {

    @IBOutlet weak var castPicImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(with people : PeopleListResult){
        ImageManager.setImageRounded(withPath: people.profilePath, on: castPicImageView, cornerRadius: 6 , placeholder: UIImage(systemName:  K.peoplePlaceholder)!)
        //ImageManager.setImage(withPath: cast.profilePath, on: castImageView,placeholder: UIImage(systemName:  K.peoplePlaceholder)!)
    }

}

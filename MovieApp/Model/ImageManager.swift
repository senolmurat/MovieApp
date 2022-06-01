//
//  ImageManager.swift
//  MovieApp
//
//  Created by Murat ŞENOL on 31.05.2022.
//

import Foundation
import UIKit
import Kingfisher

class ImageManager{
    
    
    
    
    static func setImage(withPath imagePath : String , on imageView : UIImageView){
        let url = URL(string: AppConfig.config.originalImageURL + imagePath)
        let processor = DownsamplingImageProcessor(size: imageView.bounds.size)
        imageView.kf.indicatorType = .activity
        imageView.kf.setImage(
            with: url,
            //TODO: change image name to some variable from AppConstants
            placeholder: UIImage(named: "placeholderImage"),
            options: [
                .processor(processor),
                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(0.2)),
                .cacheOriginalImage
            ])
        {
            result in
            switch result {
            case .success(let value):
                print("Task done for: \(value.source.url?.absoluteString ?? "")")
            case .failure(let error):
                imageView.image = UIImage(named: "placeholderImage")
                print("Job failed: \(error.localizedDescription)")
            }
        }
    }
}

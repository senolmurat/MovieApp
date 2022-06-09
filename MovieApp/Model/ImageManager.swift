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
    
    
    
    
    static func setImage(withPath imagePath : String? , on imageView : UIImageView){
        
        if let imagePath = imagePath {
            let url = URL(string: AppConfig.config.originalImageURL + imagePath)
            let processor = DownsamplingImageProcessor(size: imageView.bounds.size)
            imageView.kf.indicatorType = .activity
            imageView.kf.setImage(
                with: url,
                //placeholder: UIImage(named: "placeholderImage"),
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
        else{
            imageView.image = UIImage(named: "placeholderImage")
            print("Job failed: Image Path does not exist.")
        }
        
    }
    
    static func setImage(withPath imagePath : String? , on imageView : UIImageView , placeholder : UIImage){
        
        if let imagePath = imagePath {
            let url = URL(string: AppConfig.config.originalImageURL + imagePath)
            let processor = DownsamplingImageProcessor(size: imageView.bounds.size)
            imageView.kf.indicatorType = .activity
            imageView.kf.setImage(
                with: url,
                //placeholder: placeholder,
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
                    imageView.image = placeholder
                    print("Job failed: \(error.localizedDescription)")
                }
            }
        }
        else{
            imageView.image = placeholder
            print("Job failed: Image Path does not exist.")
        }
        
    }
    
    static func setImageRounded(withPath imagePath : String? , on imageView : UIImageView , cornerRadius : CGFloat){
        
        if let imagePath = imagePath {
            let url = URL(string: AppConfig.config.originalImageURL + imagePath)
            let processor = DownsamplingImageProcessor(size: imageView.bounds.size)
                         |> RoundCornerImageProcessor(cornerRadius: cornerRadius)
            imageView.kf.indicatorType = .activity
            imageView.kf.setImage(
                with: url,
                //placeholder: UIImage(named: "placeholderImage"),
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
        else{
            imageView.image = UIImage(named: "placeholderImage")
            print("Job failed: Image Path does not exist.")
        }
    }
    
    static func setImageRounded(withPath imagePath : String? , on imageView : UIImageView , cornerRadius : CGFloat , placeholder : UIImage){
        
        if let imagePath = imagePath {
            let url = URL(string: AppConfig.config.originalImageURL + imagePath)
            let processor = DownsamplingImageProcessor(size: imageView.bounds.size)
                         |> RoundCornerImageProcessor(cornerRadius: cornerRadius)
            imageView.kf.indicatorType = .activity
            imageView.kf.setImage(
                with: url,
                //placeholder: placeholder,
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
                    imageView.image = placeholder
                    print("Job failed: \(error.localizedDescription)")
                }
            }
        }
        else{
            imageView.image = placeholder
            print("Job failed: Image Path does not exist.")
        }
    }

}

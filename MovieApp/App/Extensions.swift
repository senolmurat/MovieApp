//
//  Extensions.swift
//  MovieApp
//
//  Created by Murat ŞENOL on 3.06.2022.
//

import Foundation
import UIKit

extension UITableView {

    func setEmptyMessage(_ message: String) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = .black
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.font = UIFont(name: "TrebuchetMS", size: 15)
        messageLabel.sizeToFit()

        self.backgroundView = messageLabel
        self.separatorStyle = .none
    }

    func restore() {
        self.backgroundView = nil
        self.separatorStyle = .singleLine
    }
}

extension UICollectionView {

    func setEmptyMessage(_ message: String) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = .black
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = .center;
        messageLabel.font = UIFont(name: "TrebuchetMS", size: 15)
        messageLabel.sizeToFit()

        self.backgroundView = messageLabel;
    }

    func restore() {
        self.backgroundView = nil
    }
}

extension String{
    func tryLocalizedDate() -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: AppConfig.config.locale)
        dateFormatter.dateFormat = "yyyy'-'MM'-'dd'"
        if let date = dateFormatter.date(from: self){
            dateFormatter.setLocalizedDateFormatFromTemplate("YYYY dd MMMM")
            return dateFormatter.string(from: date)
        }
        else{
            return self
        }
        
    }
}

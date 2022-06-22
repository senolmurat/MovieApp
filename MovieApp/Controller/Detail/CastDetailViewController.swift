//
//  CastDetailViewController.swift
//  MovieApp
//
//  Created by Murat ŞENOL on 3.06.2022.
//

import UIKit
import Localize_Swift

class CastDetailViewController: UIViewController {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var personNameLabel: UILabel!
    @IBOutlet weak var birthdayLabel: UILabel!
    @IBOutlet weak var placeOfBirthLabel: UILabel!
    @IBOutlet weak var biographyLabel: UILabel!
    
    var personID : Int?
    let personService = PersonService()
    
    override func viewDidLoad(){
        super.viewDidLoad()

        if let personID = personID{
            AlertManager.showLoadingIndicator(in: self)
            personService.getDetails(personID: personID , language: AppConfig.config.languageISO) { result in
                switch result {
                case .success(let response):
                    DispatchQueue.main.async {
                        self.configureCastDetail(with: response)
                        AlertManager.dismissLoadingIndicator(in: self)
                    }
                case .failure(let error):
                    //TODO: maybe show alertbox ?
                    print(error)
                    AlertManager.showInfoAlertBox(with: "person_info_na".localized(), in: self) { action in
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            }
        }
        else{
            AlertManager.showInfoAlertBox(with: "person_na".localized(), in: self) { action in
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    func configureCastDetail(with person : People){
        
        ImageManager.setImage(withPath: person.profilePath, on: profileImageView, placeholder: UIImage(systemName: K.peoplePlaceholder)!)
        
        
        guard let finalColor = view.backgroundColor else{
            return
        }
        
        let initialColor = finalColor.withAlphaComponent(0.0)
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.type = .axial
        gradientLayer.colors = [initialColor.cgColor, finalColor.cgColor]
        gradientLayer.locations = [0, 1]
        gradientLayer.frame = CGRect(
            x: profileImageView.bounds.origin.x,
            y: profileImageView.bounds.origin.y + profileImageView.bounds.height / 2,
            width: profileImageView.bounds.width,
            height: profileImageView.bounds.height / 2)
        profileImageView.layer.addSublayer(gradientLayer)
        
        personNameLabel.text = person.name
        birthdayLabel.text = person.birthday?.tryLocalizedDate() ?? "birthday_unkown".localized()
        if let deathday = person.deathday{
            birthdayLabel.text! += " | " + deathday.tryLocalizedDate()
        }
        placeOfBirthLabel.text = person.placeOfBirth ?? "palce_of_birth_unknown".localized()
        biographyLabel.text = person.biography.isEmpty ? "not_available_3dot".localized() : person.biography
        
    }
    
    
}

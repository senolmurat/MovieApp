//
//  CastDetailViewController.swift
//  MovieApp
//
//  Created by Murat ŞENOL on 3.06.2022.
//

import UIKit

class CastDetailViewController: UIViewController {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var personNameLabel: UILabel!
    @IBOutlet weak var birthdayLabel: UILabel!
    @IBOutlet weak var placeOfBirthLabel: UILabel!
    @IBOutlet weak var biographyLabel: UILabel!
    
    var personID : Int?
    let personService = PersonService()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let personID = personID{
            personService.getDetails(personID: personID) { result in
                switch result {
                case .success(let response):
                    DispatchQueue.main.async {
                        self.configureCastDetail(with: response)
                    }
                case .failure(let error):
                    //TODO: maybe show alertbox ?
                    print(error)
                }
            }
        }
        else{
            //TODO: Localization Support
            AlertManager.showInfoAlertBox(with: "Movie Not Found", in: self) { action in
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    func configureCastDetail(with person : People){
        
        ImageManager.setImage(withPath: person.profilePath, on: profileImageView, placeholder: UIImage(systemName: K.peoplePlaceholder)!)
        
        let finalColor = UIColor.systemBackground
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
        //TODO: Localization
        birthdayLabel.text = person.birthday ?? "Birthday Unknown"
        if let deathday = person.deathday{
            birthdayLabel.text! += " | " + deathday
        }
        placeOfBirthLabel.text = person.placeOfBirth ?? "Place of Birth Unknown"
        biographyLabel.text = person.biography
        
    }
    
    
}

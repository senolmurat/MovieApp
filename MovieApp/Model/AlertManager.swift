//
//  ErrorManager.swift
//  
//
//  Created by Murat ŞENOL on 16.05.2022.
//

import Foundation
import UIKit

struct AlertManager{
    
    static func showLoadingIndicator(in controller : UIViewController){
        //UI Activity View Indicator
//        let alert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)
//
//        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
//        loadingIndicator.hidesWhenStopped = true
//        loadingIndicator.style = UIActivityIndicatorView.Style.medium
//        loadingIndicator.startAnimating();
//
//        alert.view.addSubview(loadingIndicator)
//        controller.present(alert, animated: true, completion: nil)
        let child = SpinnerViewController()

        // add the spinner view controller
        controller.addChild(child)
        child.view.frame = controller.view.frame
        controller.view.addSubview(child.view)
        child.didMove(toParent: controller)
    }
    
    static func dismissLoadingIndicator(in controller : UIViewController){        
        if let child = controller.children.last as? SpinnerViewController{
            DispatchQueue.main.async
            {
                child.willMove(toParent: nil)
                child.view.removeFromSuperview()
                child.removeFromParent()
            }
        }
    }
    
    static func dismiss(in controller : UIViewController , animated : Bool){
        controller.dismiss(animated: animated, completion: nil)
    }
        
    static func showInfoAlertBox(for error: NSError , in controller: UIViewController , handler: ((UIAlertAction) -> Void)? ){
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: handler))
        controller.present(alert, animated: true, completion: nil)
    }
    
    static func showInfoAlertBox(with message: String , in controller: UIViewController , handler: ((UIAlertAction) -> Void)? ){
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: handler))
        controller.present(alert, animated: true, completion: nil)
    }
    
    static func showTableViewLoadingIndicator(for tableView : UITableView , in controller : UIViewController){
        //NOTE : No need to create spinner everytime it needs to be shown ? 
        let spinner = UIActivityIndicatorView(style: .medium)
        spinner.startAnimating()
        spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: tableView.bounds.width, height: CGFloat(44))

        tableView.tableFooterView = spinner
        tableView.tableFooterView?.isHidden = false
    }
    
    static func hideTableViewLoadingIndicator(for tableView : UITableView , in controller : UIViewController){
        tableView.tableFooterView?.isHidden = true
    }
}

class SpinnerViewController: UIViewController {
    var spinner = UIActivityIndicatorView(style: .large)

    override func loadView() {
        view = UIView()
        view.backgroundColor = UIColor.systemBackground

        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.startAnimating()
        view.addSubview(spinner)

        spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
}

enum ErrorType : Error{
    case NetworkError
    case DecodeError
    case UnknownError
}


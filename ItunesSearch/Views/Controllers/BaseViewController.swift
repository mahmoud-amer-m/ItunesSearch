//
//  BaseViewController.swift
//  ItunesSearch
//
//  Created by Mahmoud Amer on 10/2/18.
//  Copyright © 2018 Amer. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    let loadingView: UIView = UIView()
    var loadingIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    func showLoading() {
        loadingView.frame = view.bounds
        loadingView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7)
        loadingIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
        loadingIndicator.frame = CGRect.init(origin: CGPoint.zero, size: CGSize(width: 50, height: 50))
        loadingIndicator.center = loadingView.center
        loadingIndicator.startAnimating()
        loadingView.addSubview(loadingIndicator)
        view.addSubview(loadingView)
    }
    
    func hideLoadingView() {
        loadingView.removeFromSuperview()
    }
    
    func addItunesLogoToNavigation() {
        let logo = UIImage(named: "iTunesLogo")
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
        imageView.contentMode = .scaleAspectFit
        imageView.image = logo
        navigationItem.titleView = imageView
    }
    
    func showAlert(title: String, message: String, buttonTitle: String, action: ((UIAlertAction)->())? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        if let secondAction = action {
            alert.addAction(UIAlertAction(title: buttonTitle, style: UIAlertActionStyle.default, handler: secondAction))
        }
        self.present(alert, animated: true, completion: nil)
    }

}

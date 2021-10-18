//
//  extension.swift
//  onTheMap
//
//  Created by Victor Tejada Yau on 10/16/21.
//

import UIKit

extension UIViewController {
    
    func alertBox(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true)
    }
    
    func setupIndicator(currentIndicator: UIActivityIndicatorView) {
        self.view.addSubview(currentIndicator)
        currentIndicator.bringSubviewToFront(self.view)
        currentIndicator.center = self.view.center
    }
    
    func displayActivityIndicator(currentIndicator: UIActivityIndicatorView) {
        currentIndicator.isHidden = false
        currentIndicator.startAnimating()
    }
    
    func hideActivityIndicator(currentIndicator: UIActivityIndicatorView) {
        currentIndicator.stopAnimating()
        currentIndicator.isHidden = true
    }
    
    func openLink(_ url: String) {
        guard let url = URL(string: url), UIApplication.shared.canOpenURL(url) else {
            alertBox(title: "Invalid Link", message: "could not open link")
            return
        }
        UIApplication.shared.open(url, options: [:])
    }
}

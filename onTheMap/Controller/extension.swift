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
}

//
//  ViewController.swift
//  onTheMap
//
//  Created by Victor Tejada Yau on 10/08/21.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func login(_ sender: Any) {
        ServiceClient.classicLogin(username: self.usernameTextField.text ?? "", password: self.passwordTextField.text ?? "", completion: handleLoginResponse(success:error:))
    }
    
    func handleLoginResponse(success: Bool, error: Error?) {
        if success {
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "logged", sender: nil)
            }
        } else {
            let alert = UIAlertController(title: "login", message: "User could not logging", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true)
        }
    }
}


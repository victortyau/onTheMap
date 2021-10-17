//
//  ViewController.swift
//  onTheMap
//
//  Created by Victor Tejada Yau on 10/08/21.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    let textFieldLabels = ["Email", "Password"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        usernameTextField.delegate = self
        usernameTextField.text = textFieldLabels[0]
        passwordTextField.delegate = self
        passwordTextField.text = textFieldLabels[1]
    }
    
    @IBAction func signUp(_ sender: Any) {
        UIApplication.shared.open(ServiceClient.Endpoints.signUpLink.url, options: [:], completionHandler: nil)
    }
    

    @IBAction func login(_ sender: Any) {
        if textFieldValidation() {
            ServiceClient.classicLogin(username: self.usernameTextField.text ?? "", password: self.passwordTextField.text ?? "", completion: handleLoginResponse(success:error:))
        } else {
            alertBox(title: "login", message: "Email or Password wrong values")
        }
    }
    
    func handleLoginResponse(success: Bool, error: Error?) {
        if success {
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "logged", sender: nil)
            }
        } else {
            alertBox(title: "login", message: "User could not logging")
        }
    }
    
    func textFieldValidation() -> Bool {
        var success = true
        
        if usernameTextField.text!.isEmpty || passwordTextField.text!.isEmpty {
            success = false
        } else if usernameTextField.text == textFieldLabels[0] || passwordTextField.text == textFieldLabels[1] {
            success = false
        }
        
        return success
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == usernameTextField && textField.text == textFieldLabels[0] {
            textField.text = ""
        }
        
        if textField == passwordTextField && textField.text == textFieldLabels[1] {
            textField.text = ""
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == usernameTextField && textField.text == "" {
            textField.text = textFieldLabels[0]
        }
        
        if textField == passwordTextField && textField.text == "" {
            textField.text = textFieldLabels[1]
        }
    }
}


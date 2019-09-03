//
//  ViewController.swift
//  OnTheMap
//
//  Created by Mahesh Chauhan on 31/8/19.
//  Copyright © 2019 Mahesh Chauhan. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet var emailField: UITextField!
    @IBOutlet var passwordField: UITextField!
    @IBOutlet var loginButton: UIButton!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        emailField.text = ""
        passwordField.text = ""
    }
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        if emailField.text?.isEmpty == true || passwordField.text?.isEmpty == true {
            showError(title: "Login Failed", message: "Please enter both email and password to login.") {}
            return;
        }
        setLoggingIn(true)
        UdacityAPIClient.login(email: emailField.text ?? "", password: passwordField.text ?? "", completion: handleLoginResponse(success:error:))
    }
    
    @IBAction func signUpButtonTapped(_ sender: Any) {
        let app = UIApplication.shared
        if let url = URL(string: "https://auth.udacity.com/sign-up") {
            app.open(url, options: [:], completionHandler: nil)
        }
    }
    
    func handleLoginResponse(success: Bool, error: Error?) {
        setLoggingIn(false)
        if success {
            print("Login success")
            self.performSegue(withIdentifier: "completeLogin", sender: nil)
        } else {
            showError(title: "Login Failed", message: error?.localizedDescription ?? "Unknown Error") {
                self.setLoggingIn(false)
            }
        }
    }
    
    func setLoggingIn(_ loggingIn: Bool) {
        if loggingIn {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
        emailField.isEnabled = !loggingIn
        passwordField.isEnabled = !loggingIn
        loginButton.isEnabled = !loggingIn
    }
    
}


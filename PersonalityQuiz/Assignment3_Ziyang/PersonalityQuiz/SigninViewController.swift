//
//  SigninViewController.swift
//  PersonalityQuiz
//
//  Created by Ziyang Wang on 2024-11-14.
//


import UIKit

class SigninViewController: UIViewController {
    
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var userNameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set passwordTextField to display as *
        passwordTextField.isSecureTextEntry = true
    }
    
    @IBAction func cancelBtnPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func signinBtnPressed(_ sender: Any) {
        guard let username = userNameTextField.text, !username.isEmpty,
              let password = passwordTextField.text, !password.isEmpty else {
            // Show an alert if fields are empty
            showAlert(message: "Please fill in both fields.")
            return
        }

        // Retrieve saved user info from UserDefaults
        if let savedUsers = UserDefaults.standard.dictionary(forKey: "users") as? [String: String] {
            // Check if the entered username exists in the saved users
            if let savedPassword = savedUsers[username] {
                // Compare the entered password with the saved password
                if savedPassword == password {
                    UserSession.shared.username = username// Store the username in the Singleton
                    // Successful sign-in
                    showAlert(message: "Sign-in successful!"){
                        // Only navigate to the next screen after user dismisses the alert
                        self.performSegue(withIdentifier: "signedIn", sender: username)
                    }
                } else {
                    // Invalid password
                    showAlert(message: "Incorrect password.")
                }
            } else {
                // Username exists but password doesn't match
                showAlert(message: "No user found with that username.")
            }
        } else {
            // No users found in UserDefaults (i.e., no saved data)
            showAlert(message: "No users found. Please sign up first.")
        }
    }
    
    // Function to display an alert message
    func showAlert(message: String, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            // Call the completion handler after the user taps "OK"
            completion?()
        }))
        present(alert, animated: true, completion: nil)
    }
    
}

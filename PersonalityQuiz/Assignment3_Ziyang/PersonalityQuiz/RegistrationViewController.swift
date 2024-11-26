//
//  RegistrationViewController.swift
//  PersonalityQuiz
//
//  Created by Ziyang Wang on 2024-11-14.
//

import UIKit

class RegistrationViewController: UIViewController{
    
    

    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signupBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set passwordTextField to display as *
        passwordTextField.isSecureTextEntry = true
    }


    @IBAction func cancelBtnPressed(_ sender: UIButton) {
        // Dismiss the view controller (or perform any other action)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func signupBtnPressed(_ sender: UIButton) {
        // Check if username and password meet the length criteria
        guard let username = userNameTextField.text, let password = passwordTextField.text else { return }
        // Check length of username and password
        if username.count < 5 || username.count > 15 {
            let alert = UIAlertController(title: "Invalid Input", message: "Username must be between 5 and 15 characters.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
            return
        }
        
        if password.count < 5 || password.count > 15 {
            let alert = UIAlertController(title: "Invalid Input", message: "Password must be between 5 and 15 characters.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
            return
        }
        
        // Check if the username already exists in UserDefaults
        if let savedUsers = UserDefaults.standard.dictionary(forKey: "users") as? [String: String],
           savedUsers[username] != nil {
            // Username already exists
            let alert = UIAlertController(title: "Username Taken", message: "The username is already taken. Please choose a different one.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
            return
        }
        saveUserInfo(username: username, password: password)
        
        // Show success alert after successful sign-up
        let successAlert = UIAlertController(title: "Sign Up Successful", message: "You have successfully signed up!", preferredStyle: .alert)
        
        // Add an action to dismiss the alert and optionally navigate away or dismiss the view controller
        successAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            // Optionally dismiss the view controller after successful sign-up
            self.dismiss(animated: true, completion: nil)
        }))
        
        // Present the success alert
        present(successAlert, animated: true, completion: nil)
        
    }
    func saveUserInfo(username: String, password: String) {
        var savedUsers = UserDefaults.standard.dictionary(forKey: "users") as? [String: String] ?? [:]
        savedUsers[username] = password
        UserDefaults.standard.set(savedUsers, forKey: "users")
    }
    
}

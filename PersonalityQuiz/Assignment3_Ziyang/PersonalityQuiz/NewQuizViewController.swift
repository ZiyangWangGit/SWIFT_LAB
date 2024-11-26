//
//  NewQuizViewController.swift
//  PersonalityQuiz
//
//  Created by Ziyang Wang on 2024-11-17.
//
import UIKit

class NewQuizViewController: UIViewController {
    
    var username:String?
    @IBOutlet weak var welcomeMsgLabelView: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let username = UserSession.shared.username ?? "Guest"
        welcomeMsgLabelView.text = "Welcome Home, \(username)"

    }
    
    @IBAction func newQuizPressed(_ sender: UIButton) {
        // Perform the segue to the quiz page
        performSegue(withIdentifier: "showQuiz", sender: self)
    }
    
    @IBAction func logoutBtnPressed(_ sender: UIButton) {
        // Log out the user by clearing the username from UserSession
        UserSession.shared.username = nil
        // Find the FirstPageViewController in the navigation stack and pop to it
        performSegue(withIdentifier: "backToFirst", sender: self)
    }
}

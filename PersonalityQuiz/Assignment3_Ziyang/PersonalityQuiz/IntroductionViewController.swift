//
//  ViewController.swift
//  PersonalityQuiz
//
//  Created by Ziyang Wang on 2024-11-10.
//

import UIKit

class IntroductionViewController: UIViewController {
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let username = UserSession.shared.username ?? "Guest"
        print(username)
    }

    
    @IBAction func unwindToQuizIntroduction(segue:UIStoryboardSegue){
    }
    

    @IBAction func backToMainBtnPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}


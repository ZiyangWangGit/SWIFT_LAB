//
//  FirstPageViewController.swift
//  PersonalityQuiz
//
//  Created by Ziyang Wang on 2024-11-14.
//

import UIKit

class FirstPageViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "signIn" {
            if segue.destination is SigninViewController {
              }
          }
          if segue.identifier == "signUp" {
              if segue.destination is RegistrationViewController {
              }
          }
        if segue.identifier == "question" {
            if segue.destination is IntroductionViewController {
              }
          }

        
        
        
      }
}


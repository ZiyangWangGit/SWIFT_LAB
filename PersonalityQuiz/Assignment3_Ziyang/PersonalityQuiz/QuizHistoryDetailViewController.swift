//
//  QuizHistoryDetailViewController.swift
//  PersonalityQuiz
//
//  Created by Ziyang Wang on 2024-11-17.
//

import UIKit

class QuizHistoryDetailViewController: UIViewController {
    
    @IBOutlet weak var resultUILabel: UILabel!
    @IBOutlet weak var definitionUILabel: UILabel!
    @IBOutlet weak var answersUILabel: UILabel!
    
    var resultAnswer: String?
    var resultDefinition: String?
    var answers: [String]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let resultText = "Result: \(resultAnswer ?? "no result")"
        let definitionText = "Definition: \(resultDefinition ?? "no def")"
        
        // Set the result label text with "Result:" prefix
        resultUILabel.text = resultText
        // Set the definition label text with "Definition:" prefix
        definitionUILabel.text = definitionText
        
        displayAnswers()
    }
    
    func displayAnswers() {
        // Join the answers array with newline characters and set the text to the label
        if let answers = answers {
            let answersText = "Answer Selected:\n" + answers.joined(separator: "\n") // Join with newline separator
            print("Answers array: \(answers)")  // Print the array for debugging
            print("Answers text: \(answersText)") // Check the joined text before setting it to the label
            answersUILabel.text = answersText
        }
    }
    
    @IBAction func backBtnPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

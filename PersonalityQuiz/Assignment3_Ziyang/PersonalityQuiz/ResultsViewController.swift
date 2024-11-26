//
//  ResultsViewController.swift
//  PersonalityQuiz
//
//  Created by Ziyang Wang on 2024-11-10.
//

import UIKit

class ResultsViewController: UIViewController {

    @IBOutlet weak var resultAnswerLabel: UILabel!
    @IBOutlet weak var resultDefinitionLabel: UILabel!
    
    var responses: [Answer]// Array to store the answers chosen by the user
    
    // Custom initializer to pass the chosen answers to this view controller
    init?(coder: NSCoder, responses: [Answer]){
        self.responses = responses
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calculatePersonalityResult()
        // Hide the back button to prevent users from going back to the quiz
        navigationItem.hidesBackButton = true
    }
    
    func calculatePersonalityResult(){
        // Reduce the list of answers into a dictionary that counts the occurrences of each personality type
        let frequencyOfAnswers = responses.reduce(into: [:]) { (counts, answer) in
            counts[answer.type,default: 0 ] += 1
        }
        
        // Sort the dictionary by the frequency of answers in descending order, and get the first (most frequent) answer
        let mostCommonAnswer = frequencyOfAnswers.sorted{ $0.1 > $1.1  }.first!.key
        resultAnswerLabel.text = "You are a \(mostCommonAnswer.rawValue)!"
        resultDefinitionLabel.text = mostCommonAnswer.definition
        
        let resultAnswerString = String(mostCommonAnswer.rawValue)
        // Save the result for the current user (using UserSession singleton to get the username)
        saveResult(forUser: UserSession.shared.username, responses: responses, resultAnswer: resultAnswerString, definition: mostCommonAnswer.definition)
    }
    
    // Function to save the quiz result under the current user's username
    func saveResult(forUser username: String?, responses: [Answer], resultAnswer: String, definition: String) {
        guard let username = username else {
            print("No username found.")
            return
        }
        
        // Create a QuizResult object with the responses, result, and definition
        let quizResult = QuizResult(responses: responses.map { $0.text }, resultAnswer: resultAnswer, definition: definition)
        
        print("Saving result: \(quizResult)")  // Debugging print
        
        // Get the file URL for storing quiz results
        let fileURL = getFileURL(forUser: username)
        
        do {
            // First, load the current results from the file (if any)
            var currentResults = [QuizResult]()
            
            if FileManager.default.fileExists(atPath: fileURL.path) {
                let data = try Data(contentsOf: fileURL)
                let decoder = JSONDecoder()
                currentResults = try decoder.decode([QuizResult].self, from: data)
            }
            
            // Append the new result to the current results
            currentResults.append(quizResult)
            
            // Encode the updated array of quiz results
            let encoder = JSONEncoder()
            let data = try encoder.encode(currentResults)
            
            // Write the encoded data to the file
            try data.write(to: fileURL)
            
            print("Quiz result saved for user \(username) at \(fileURL.path)")
        } catch {
            print("Failed to save result: \(error)")
        }
    }
           
    // Get the URL of the file where results will be saved for the user
    func getFileURL(forUser username: String) -> URL {
        // Get the directory path (Documents directory is a good place for storing app data)
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        // Create a unique file path for each user based on their username
        return documentsDirectory.appendingPathComponent("\(username)_quizResults.json")
    }
}

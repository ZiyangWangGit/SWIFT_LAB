//
//  QuizHistoryViewController.swift
//  PersonalityQuiz
//
//  Created by Ziyang Wang on 2024-11-17.
//


import UIKit

class QuizHistoryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var quizResultTableView: UITableView!
    
    var quizResults: [QuizResult] = []  // To store the results loaded from the file

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Load the results from the file
        loadQuizResults()
        print("Loaded quiz results: \(quizResults)")
        
        // Set up table view
        quizResultTableView.dataSource = self
        quizResultTableView.delegate = self
        quizResultTableView.reloadData()
    }
    
    // Function to load quiz results from file
    func loadQuizResults() {
        guard let username = UserSession.shared.username else { return }
        
        let fileURL = getFileURL(forUser: username)
        
        // Check if the file exists
        if FileManager.default.fileExists(atPath: fileURL.path) {
            do {
                // Read the data from the file
                let data = try Data(contentsOf: fileURL)
                
                // Decode the data into an array of QuizResult objects
                let decoder = JSONDecoder()
                quizResults = try decoder.decode([QuizResult].self, from: data)
                print("Loaded quiz results for \(username): \(quizResults)")
            } catch {
                print("Failed to load results: \(error)")
            }
        } else {
            print("No quiz results found for user \(username)")
        }
    }

    // UITableViewDataSource method: returns the number of rows in the table
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return quizResults.count
    }
    
    // UITableViewDataSource method: configures each table cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "QuizHistoryCell", for: indexPath)
        let result = quizResults[indexPath.row]
        
        // Configure cell text labels with result data
        cell.textLabel?.text = result.resultAnswer
        cell.detailTextLabel?.text = result.definition
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Get the selected result
        let selectedResult = quizResults[indexPath.row]
        
        // Perform segue to show details
        performSegue(withIdentifier: "showDetail", sender: selectedResult)
    }
    
    // Prepare for the segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let detailVC = segue.destination as? QuizHistoryDetailViewController,
               let selectedResult = sender as? QuizResult {
                
                // Pass the selected result data to the detail view controller
                detailVC.resultAnswer = selectedResult.resultAnswer
                detailVC.resultDefinition = selectedResult.definition
                detailVC.answers = selectedResult.responses  // Pass the answers to the detail view
            }
        }
    }
    
    // Helper function to get the file URL for the user's quiz results
    func getFileURL(forUser username: String) -> URL {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return documentsDirectory.appendingPathComponent("\(username)_quizResults.json")
    }
}


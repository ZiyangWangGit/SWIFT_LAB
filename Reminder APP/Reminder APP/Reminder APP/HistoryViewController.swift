import UIKit

class HistoryViewController: UIViewController {

    @IBOutlet weak var historyLabel: UITextView!
    @IBOutlet weak var backBtn: UIButton!
    
    // Array to hold reminders history, passed from ViewController
    var reminders: [Reminder] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        displayHistory() // Display the history when the view loads
    }
    
    func displayHistory() {
        var historyText = ""

        for reminder in reminders {
            historyText += "Title: \(reminder.title)\n"
            historyText += "Description: \(reminder.description)\n"
            historyText += "Remind Time: \(formattedDate(reminder.time))\n"
            historyText += "Created: \(formattedDate(reminder.addedDate))\n"
            historyText += "Is Completed: \(reminder.isComplete ? "Yes" : "No")\n" // Show completion status
            if let completedDate = reminder.completedDate {
                historyText += "Completed Date: \(formattedDate(completedDate))\n" // Show completion date
            } else {
                historyText += "Completed Date: Not completed\n" // Indicate not completed
            }
            historyText += "\n"
        }

        // Set the constructed text to the UITextView
        historyLabel.text = historyText.isEmpty ? "No reminders available." : historyText
    }

    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }

    @IBAction func backBtnPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

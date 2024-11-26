//
//  SceneDelegate.swift
//  Reminder APP
//
//  Created by Ziyang Wang on 2024-10-16.
//

import UIKit

struct Reminder {
    var title: String
    var description: String
    var time: Date
    var addedDate: Date
    var isComplete: Bool = false
    var completedDate: Date?
}


class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var reminders: [Reminder] = []
    var sections: [String] = []
    var remindersByDate: [String: [Reminder]] = [:]
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func organizeRemindersByDate() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        
        // Clear previous data
        sections.removeAll()
        remindersByDate.removeAll()
        
        for reminder in reminders {
            let dateKey = dateFormatter.string(from: reminder.time)
            if remindersByDate[dateKey] == nil {
                remindersByDate[dateKey] = []
                sections.append(dateKey) // Add new section
            }
            remindersByDate[dateKey]?.append(reminder)
        }
        
        sections.sort() // Sort sections by date
    }
    
    func addReminder(reminder: Reminder) {
        reminders.append(reminder) // Append the new reminder to the array
        organizeRemindersByDate() // Re-organize reminders into sections
        tableView.reloadData() // Reload the table view
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let dateKey = sections[section]
        return remindersByDate[dateKey]?.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReminderCell", for: indexPath)
        let dateKey = sections[indexPath.section]
        let reminder = remindersByDate[dateKey]?[indexPath.row]
        
        // Create an attributed string based on completion status
        let title = reminder?.title ?? ""
        let attributedTitle = NSMutableAttributedString(string: title)
        
        if reminder?.isComplete == true {
            // Apply a strikethrough style
            attributedTitle.addAttribute(.strikethroughStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 0, length: attributedTitle.length))
            cell.textLabel?.attributedText = attributedTitle
        } else {
            cell.textLabel?.attributedText = nil // Reset the attributed text
            cell.textLabel?.text = title // Set the normal title if not completed
        }
        
        // Format the time for the detail text label
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm:ss a z"
        dateFormatter.timeZone = TimeZone(identifier: "EST")
        cell.detailTextLabel?.text = dateFormatter.string(from: reminder?.time ?? Date())
        
        // Highlight past reminders
        cell.backgroundColor = reminder!.time < Date() ? UIColor.lightGray : UIColor.white
        
        // Create and configure the button
        let completeButton = UIButton(type: .system)
        completeButton.tag = indexPath.row // Tag the button with the row index
        completeButton.addTarget(self, action: #selector(completeButtonTapped(_:)), for: .touchUpInside)
        
        // Set button title based on completion status
        completeButton.setTitle(reminder!.isComplete ? "Complete" : "Incomplete", for: .normal)
        
        // Set button frame (adjust as necessary for your layout)
        completeButton.frame = CGRect(x: cell.contentView.frame.size.width - 100, y: 10, width: 90, height: 30)
        completeButton.autoresizingMask = [.flexibleLeftMargin]
        
        // Remove any existing button to prevent duplicates
        for subview in cell.contentView.subviews {
            if subview is UIButton {
                subview.removeFromSuperview()
            }
        }

        // Add button to the cell's content view
        cell.contentView.addSubview(completeButton)

        return cell
    }

    @objc func completeButtonTapped(_ sender: UIButton) {
        let section = sender.superview?.superview as! UITableViewCell
        if let indexPath = tableView.indexPath(for: section) {
            let dateKey = sections[indexPath.section]
            
            // Get the current reminder
            if var reminder = remindersByDate[dateKey]?[indexPath.row] {
                // Toggle the completion status
                reminder.isComplete.toggle()
                
                // If completed, set the completed date
                if reminder.isComplete {
                    reminder.completedDate = Date() // Save the current date as the completion date
                } else {
                    reminder.completedDate = nil // Clear the completion date if marked incomplete
                }
                
                // Update the reminders array
                if let reminderIndex = reminders.firstIndex(where: { $0.time == reminder.time }) {
                    reminders[reminderIndex] = reminder // Update the main array
                }
                
                // Update the section array
                remindersByDate[dateKey]?[indexPath.row] = reminder
                
                // Reload the specific row to refresh the button title
                tableView.reloadRows(at: [indexPath], with: .none)
            }
        }
    }



    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowReminderTableViewController" {
            if let reminderTableVC = segue.destination as? ReminderTableViewController {
                reminderTableVC.delegate = self // Set the delegate to self
            }
        } else if segue.identifier == "ShowHistoryViewController" {
            if let historyVC = segue.destination as? HistoryViewController {
                print("Passing reminders: \(reminders)") //debug
                historyVC.reminders = reminders // Pass the reminders to the history view controller
            }
        }
    }

    
}

extension ViewController: ReminderTableViewControllerDelegate {
    func didSaveReminder(_ reminder: Reminder) {
        addReminder(reminder: reminder) // Add the saved reminder to the reminders array
    }
}



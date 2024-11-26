//
//  SceneDelegate.swift
//  Reminder APP
//
//  Created by Ziyang Wang on 2024-10-16.
//

import UIKit

// Define a protocol to communicate back to the main view controller
protocol ReminderTableViewControllerDelegate: AnyObject {
    func didSaveReminder(_ reminder: Reminder) // Method to call when a reminder is saved
}

class ReminderTableViewController: UITableViewController {

    @IBOutlet weak var titleText: UITextField!
    @IBOutlet weak var descTextView: UITextView!
    @IBOutlet weak var timePicker: UIDatePicker!
    
    @IBOutlet weak var savedBtn: UIButton!
    
    weak var delegate: ReminderTableViewControllerDelegate?
    
    let sectionTitles = ["", "TITLE", "DESCRIPTION", "TIME"]

    override func viewDidLoad() {
        super.viewDidLoad()
        savedBtn.isEnabled = false
        titleText.addTarget(self, action: #selector(textFieldDidEndEditing), for: .editingChanged)
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }

    @IBAction func cancelBtnPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveBtnPressed(_ sender: UIButton) {
        // Validate that the title is not empty
        guard let title = titleText.text, !title.isEmpty else {
            return
        }

        let description = descTextView.text ?? "" // Get the description
        let time = timePicker.date // Get the selected date and time

        // Create a new Reminder object
        let reminder = Reminder(title: title, description: description, time: time,addedDate: Date(), isComplete: false)

        // Pass the reminder back to the main view controller via the delegate
        delegate?.didSaveReminder(reminder)

        // Dismiss the current view controller
        self.dismiss(animated: true, completion: nil)
    }
}

// Extend ReminderTableViewController to conform to UITextFieldDelegate
extension ReminderTableViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        // Enable the save button only if the titleText is not empty
        savedBtn.isEnabled = !(titleText.text?.isEmpty ?? true)
    }
}

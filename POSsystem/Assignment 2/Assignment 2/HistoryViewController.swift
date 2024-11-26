//
//  HistoryViewController.swift
//  Assignment 2
//
//  Created by Ziyang Wang on 2024-10-24.
//

import UIKit

class HistoryViewController: UITableViewController {
    
    var purchaseHistory: [Purchase] = []
    
    var purchases: [Purchase] {
        return ItemList.shared.purchaseHistory
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }


    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1 // Only one section for the purchase history
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return purchases.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "purchaseCell", for: indexPath)

        let purchase = purchases[indexPath.row]
        // Set the title
        cell.textLabel?.text = "Purchase: \(purchase.itemName) x \(purchase.quantity)"
        
        // Format the date
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        let formattedDate = dateFormatter.string(from: purchase.date)
        
        // Set the detail text
        cell.detailTextLabel?.text = formattedDate

        return cell
    }


    @objc func saveHistory() {
        ItemList.shared.savePurchaseHistory() // Call the save method directly from ItemList
        let alert = UIAlertController(title: "Saved", message: "Purchase history has been saved successfully.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true, completion: nil)
    }
    
    // If you want to connect this to a button in your UI
    @IBAction func saveBtnPressed(_ sender: UIButton) {
        saveHistory() // Call the saveHistory method when the button is pressed
    }
}

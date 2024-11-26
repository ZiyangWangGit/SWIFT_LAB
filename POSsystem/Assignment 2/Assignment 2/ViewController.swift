//
//  ViewController.swift
//  Assignment 2
//
//  Created by Ziyang Wang on 2024-10-14.
//

import UIKit

struct Item {
    let name: String
    var stock: Int
    let price: Double
}

struct Purchase : Codable {
    let itemName: String
    let quantity: Int
    let totalPrice: Double
    let date: Date
}


class ItemList {
    static let shared = ItemList()
    var items: [Item]
    var purchaseHistory: [Purchase] {
        didSet {
            savePurchaseHistory()
        }
    }

    private init() {
        items = [
            Item(name: "Computer", stock: 4, price: 799.99),
            Item(name: "Monitor", stock: 4, price: 399.99),
            Item(name: "Keyboard", stock: 10, price: 129.99),
            Item(name: "Mouse", stock: 10, price: 99.99)
        ]
        purchaseHistory = [] // Initialize with an empty array
        loadPurchaseHistory() // Call to load purchase history after initialization
    }
    
    private func archiveURL() -> URL {
        let fileManager = FileManager.default
        let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        return documentsDirectory.appendingPathComponent("purchaseHistory.json")
    }

    func savePurchaseHistory() {
        if let encoded = try? JSONEncoder().encode(purchaseHistory) {
            UserDefaults.standard.set(encoded, forKey: "purchaseHistory")
        }
    }

    func loadPurchaseHistory() {
        if let data = UserDefaults.standard.data(forKey: "purchaseHistory"),
           let decoded = try? JSONDecoder().decode([Purchase].self, from: data) {
            purchaseHistory = decoded // Assign the loaded history to the property
        }
    }

    func purchaseItem(at index: Int, quantity: Int) {
        let item = items[index]
        items[index].stock -= quantity

        let purchase = Purchase(itemName: item.name, quantity: quantity, totalPrice: item.price * Double(quantity), date: Date())
        purchaseHistory.append(purchase) // This will automatically save the purchase history
    }

    func getItems() -> [Item] {
        return items
    }
}



var isNewNumber = true
var rowSelected = 0

class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    @IBOutlet weak var pickerView: UIPickerView!
    
    @IBOutlet weak var selectedItem: UILabel!
    @IBOutlet weak var quantityDisplay: UILabel!
    @IBOutlet weak var exceedMsg: UILabel!
    @IBOutlet weak var totalPrice: UILabel!
    
    @IBOutlet weak var buyBtn: UIButton!
    
    // Create an instance of ItemList
    var itemList = ItemList.shared
    var items: [Item] {
        return itemList.getItems() // Get items from ItemList
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerView.dataSource = self
        pickerView.delegate = self
        selectedItem.text = items[0].name //Default name of UILabel
        buyBtn.isEnabled = false  //Disable buy button on load
        exceedMsg.text = ""
        exceedMsg.textColor = .red  //Default colour of UILabel when user enter exceeded quantity
        
    }
    
    //PickerView Functions
    // Return the number of columns in the picker view
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    
    // Return the number of rows
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return items.count
    }

    // Return the title of each row
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return items[row].name // Item names in the first column
        } else {
            return component == 1 ? "\(items[row].stock)" : "$\(items[row].price)" // Stock or Price for all items
        }
    }
    
    // Retreive corresponding stock and price for selected item
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        rowSelected = row
        if component == 0 { // When an item name is selected
            pickerView.selectRow(row, inComponent: 1, animated: true) // Select stock for selected item
            pickerView.selectRow(row, inComponent: 2, animated: true) // Select price for selected item
        } else { // If stock or price is selected
            let selectedRow = pickerView.selectedRow(inComponent: 0)
            pickerView.selectRow(selectedRow, inComponent: 0, animated: true)
            pickerView.selectRow(selectedRow, inComponent: 1, animated: true)
            pickerView.selectRow(selectedRow, inComponent: 2, animated: true)
        }
        
        //Update UILabel with the name of the selected item
        let selectedRow = pickerView.selectedRow(inComponent: 0)
        selectedItem.text = items[selectedRow].name // Set the text of the label
        
        pickerView.reloadComponent(1) // Reload stock column
        pickerView.reloadComponent(2) // Reload price column
    }
    
    
    
    
    //Quantity button functions
    //Update Quantity Label with corespoding number entered by customer
    @IBAction func quantityBtnPressed(_ sender: UIButton) {
        let pressedNumber = sender.titleLabel!.text!
        // If it's a new number entry
        if isNewNumber {
            // Only allow numbers 1-9 to be entered first
            if pressedNumber != "0" {
                quantityDisplay.text = pressedNumber
                isNewNumber = false
            }
        } else {
            quantityDisplay.text = quantityDisplay.text! + pressedNumber
        }
        updateTotalPrice()
    }
    
    // Delete the last entered number
    @IBAction func deletedLastNumber(_ sender: UIButton) {
        guard let currentText = quantityDisplay.text,!currentText.isEmpty else {
            return // If the display is empty, do nothing
        }
        // Remove the last character from the display
        quantityDisplay.text = String(currentText.dropLast())
        
        // Check if the display is empty after deletion
        if quantityDisplay.text!.isEmpty {
            quantityDisplay.text = "0"
            isNewNumber = true // Reset for new number input
        }
        updateTotalPrice()
    }
        
    // Delete all entered numbers
    @IBAction func deleteAllNumbers(_ sender: UIButton) {
        quantityDisplay.text = "0"
        isNewNumber = true // Reset for new number input
        updateTotalPrice()
    }
    
    
    
    //Update total price
    private func updateTotalPrice() {
        guard let quantity = Int(quantityDisplay.text!), quantity > 0 else {
            totalPrice.text = "$0.00"
            totalPrice.textColor = .black
            exceedMsg.text = ""
            return
        }
        let price = items[rowSelected].price
        let total = price * Double(quantity)
        
        // Check if quantity exceeds stock
        if quantity > items[rowSelected].stock {
            totalPrice.text = String(format: "$%.2f", total)
            totalPrice.textColor = .red // Change text color to red
            buyBtn.isEnabled = false
            exceedMsg.text = "Quantity exceeds stock availability"
           } else {
               totalPrice.text = String(format: "$%.2f", total)
               totalPrice.textColor = .black // Reset color to default
               buyBtn.isEnabled = true // Enable buy button
               exceedMsg.text = ""
           }
    }
    
    //Buy button event listener
    @IBAction func buyBtnPressed(_ sender: UIButton) {
        let quantity = Int(quantityDisplay.text!)!
        itemList.purchaseItem(at: rowSelected, quantity: quantity)
        updateTotalPrice() // Refresh the total price
        pickerView.reloadAllComponents()
        exceedMsg.text = "Purchase successful!"
    }
    
    @IBAction func managerBtnPressed(_ sender: UIButton) {
        let alert = UIAlertController(title: "Enter Code", message: "", preferredStyle: .alert)
        
        // Add a text field to the alert
        alert.addTextField { textField in
            textField.isSecureTextEntry = true // Hide text for security
        }

        // Add the submit action
        let submitAction = UIAlertAction(title: "Submit", style: .default) { _ in
            if let code = alert.textFields?.first?.text, code == "1234" {
                // Code is correct, goes to the manager scene
                self.performSegue(withIdentifier: "showManagerViewController", sender: self)
            } else {
                // Code is incorrect, show error message
                let errorAlert = UIAlertController(title: "Access Denied", message: "Incorrect code. Please try again.", preferredStyle: .alert)
                errorAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(errorAlert, animated: true, completion: nil)
            }
        }
        alert.addAction(submitAction)
        present(alert, animated: true, completion: nil)
    }
    
    func refreshPickerView() {
        pickerView.reloadAllComponents()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshPickerView() // Refresh the picker view when returning to this view
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("Preparing for segue")
        if let tabBarController = segue.destination as? UITabBarController {
            for viewController in tabBarController.viewControllers ?? [] {
                if let managerVC = viewController as? ManagerViewController {
                    managerVC.itemList = ItemList.shared
                } else if let historyVC = viewController as? HistoryViewController {
                    historyVC.purchaseHistory = ItemList.shared.purchaseHistory // Pass purchase history
                    for purchase in historyVC.purchaseHistory {
                                  print("Item: \(purchase.itemName), Quantity: \(purchase.quantity), Total Price: \(purchase.totalPrice), Date: \(purchase.date)")
                              }
                }
            }
        }
    }


}



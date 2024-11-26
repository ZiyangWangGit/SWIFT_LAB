//
//  NewItemViewController.swift
//  Assignment 2
//
//  Created by Ziyang Wang on 2024-10-24.
//

import UIKit

class NewItemViewController: UIViewController {
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var valueTextField: UITextField!
    @IBOutlet weak var quantityTextField: UITextField!
    
    var itemList: ItemList?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func cancelBtnPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveBtnPressed(_ sender: Any) {
        guard let name = titleTextField.text,
              let stockText = quantityTextField.text,
              let priceText = valueTextField.text,
              let stock = Int(stockText),   // Convert stock to Int
              let price = Double(priceText)  // Convert price to Double
        else {
            return
        }
        let newItem = Item(name: name, stock: stock, price: price)
        ItemList.shared.items.append(newItem)// Add new item to the list
        
        self.dismiss(animated: true, completion: nil)
    }
}

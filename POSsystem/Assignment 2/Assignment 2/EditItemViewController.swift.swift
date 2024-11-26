//
//  EditItemViewController.swift.swift
//  Assignment 2
//
//  Created by Ziyang Wang on 2024-10-24.
//
import UIKit

class EditItemViewController: UIViewController {
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var valueTextField: UITextField!
    @IBOutlet weak var quantityTextField: UITextField!
    var item: Item?
    var itemList: ItemList?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        if let item = item {
            titleTextField.text = item.name
            quantityTextField.text = "\(item.stock)"
            valueTextField.text = "\(item.price)"
            
        }
    }
    
    @IBAction func cancelBtnPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
        
    @IBAction func saveBtnPressed(_ sender: Any) {
        guard let name = titleTextField.text,
                let stockText = quantityTextField.text,
                let priceText = valueTextField.text,
                let stock = Int(stockText),
                let price = Double(priceText) else {
            return
        }

        // Update the selected item
        if let itemIndex = itemList?.items.firstIndex(where: { $0.name == item?.name }) {
            itemList?.items[itemIndex] = Item(name: name, stock: stock, price: price)
        }
        self.dismiss(animated: true, completion: nil)
    }
}

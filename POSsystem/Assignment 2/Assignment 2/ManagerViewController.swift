//
//  ManagerViewController.swift
//  Assignment 2
//
//  Created by Ziyang Wang on 2024-10-14.
//
import UIKit

class ManagerViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var itemList: ItemList? // Keep this to hold the passed item list
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.reloadData() // Reload data to reflect the current item list
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemList?.getItems().count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath)
        if let item = itemList?.getItems()[indexPath.row] {
            cell.textLabel?.text = item.name
            cell.detailTextLabel?.text = "Stock: \(item.stock) - Price: $\(item.price)"
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let selectedItem = itemList?.getItems()[indexPath.row] else { return }
        performSegue(withIdentifier: "showEditItemViewController", sender: selectedItem)
    }

    @IBAction func doneBtnPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showEditItemViewController" {
            if let editItemVC = segue.destination as? EditItemViewController,
               let item = sender as? Item {
                editItemVC.item = item
                editItemVC.itemList = itemList // Pass the itemList for updating
            }
        } else if segue.identifier == "showAddItemViewController" {
            if let addItemVC = segue.destination as? NewItemViewController {
                addItemVC.itemList = itemList // Pass the itemList to AddItemViewController
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData() // Reload data to reflect any new items added
    }
}

//
//  StockDetailViewController.swift
//  Assignment 4
//
//  Created by Ziyang Wang on 2024-12-01.
//

import UIKit
import CoreData

class StockDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var stockTableView: UITableView!


    
    var activeStocks: [Stock] = []  // Array to hold active stocks
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Fetch the active stocks from Core Data
        fetchActiveStocksFromCoreData()
        
        // Set up the table view
        stockTableView.dataSource = self
        stockTableView.delegate = self
    }
    
    // Fetch active stocks from Core Data
    func fetchActiveStocksFromCoreData() {
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Stock> = Stock.fetchRequest()
        
        // Filter to fetch only active stocks
        fetchRequest.predicate = NSPredicate(format: "listType == %@", "active")
        
        do {
            // Fetch the active stocks
            activeStocks = try context.fetch(fetchRequest)
            stockTableView.reloadData()  // Reload the table view to show the active stocks
        } catch {
            print("Error fetching active stocks: \(error)")
        }
    }

    // Number of rows in the table (equal to the number of active stocks)
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return activeStocks.count
    }
    
    // Configure each cell to display the stock's name and other details
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StockCell", for: indexPath)
        
        // Get the stock for this row
        let stock = activeStocks[indexPath.row]
        
        // Set the cell's text to the stock's name
        cell.textLabel?.text = stock.name
        cell.detailTextLabel?.text = stock.symbol
        
        // Create a UIMenu for the button
        if let menuButton = cell.viewWithTag(100) as? UIButton {
            // Set the button's title based on the stock's rank from Core Data
            if let rank = stock.rank {
                switch rank.lowercased() {
                case "super hot":
                    menuButton.setTitle("Very Hot", for: .normal)
                case "hot":
                    menuButton.setTitle("Hot", for: .normal)
                case "cold":
                    menuButton.setTitle("Cold", for: .normal)
                default:
                    menuButton.setTitle("Normal", for: .normal)
                }
            } else {
                menuButton.setTitle("Normal", for: .normal)
            }
            
            // Create the UIMenu
            let menu = UIMenu(title: "", children: [
                UIAction(title: "Normal", handler: { action in
                    self.updateStockRank(stock: stock, rank: "Normal")
                    menuButton.setTitle("Normal", for: .normal)
                }),
                UIAction(title: "Hot", handler: { action in
                    self.updateStockRank(stock: stock, rank: "Hot")
                    menuButton.setTitle("Hot", for: .normal)
                }),
                UIAction(title: "Very Hot", attributes: .destructive, handler: { action in
                    self.updateStockRank(stock: stock, rank: "Super Hot")
                    menuButton.setTitle("Very Hot", for: .normal)
                }),
                UIAction(title: "Cold", handler: { action in
                    self.updateStockRank(stock: stock, rank: "Cold")
                    menuButton.setTitle("Cold", for: .normal)
                })
            ])
            
            // Assign the menu to the button
            menuButton.menu = menu
            menuButton.showsMenuAsPrimaryAction = true
        }
        
        return cell
    }

    
    func updateStockRank(stock: Stock, rank: String) {
        let context = appDelegate.persistentContainer.viewContext
        
        // Set the rank of the stock
        stock.rank = rank
        
        // Save the changes to Core Data
        do {
            try context.save()
            print("\(stock.name ?? "Unknown") rank updated to: \(rank)")
            
            // Update the rank in the local array as well
            if let index = activeStocks.firstIndex(of: stock) {
                activeStocks[index].rank = rank
            }
        } catch {
            print("Error saving rank: \(error)")
        }
    }
}

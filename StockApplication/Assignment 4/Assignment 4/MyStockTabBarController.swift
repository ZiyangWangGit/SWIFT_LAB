//
//  MyStockTabBarController.swift
//  Assignment 4
//
//  Created by Ziyang Wang on 2024-11-27.
//

import UIKit
import CoreData

struct StockInfo {
    var price: Double
    var ratio: Double
}


class MyStockTabBarController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    let appdelegate = UIApplication.shared.delegate as! AppDelegate
    
    let headerTitles = ["ACTIVE", "WATCHING"]//Header title
 
    var activeStocks: [Stock] = []
    var watchingStocks: [Stock] = []
    var allSavedStockSymbols: [String] = []
    var stockPrices: [String: StockInfo] = [:]

    
    var refreshControl: UIRefreshControl!
    
    @IBOutlet weak var stockTableView: UITableView!
    @IBOutlet weak var currentRatioLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stockTableView.dataSource = self
        stockTableView.delegate = self
        
        // Initialize and add the refresh control to the table view
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshStocks), for: .valueChanged)
        stockTableView.refreshControl = refreshControl

        fetchStocksFromCoreData()
  
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Trigger the core data when returning to this page
        fetchStocksFromCoreData()
    }
    
    // Fetch data from CoreData
       func fetchStocksFromCoreData() {
           let context = appdelegate.persistentContainer.viewContext
           let fetchRequest: NSFetchRequest<Stock> = Stock.fetchRequest()
           
           do {
               let stocks = try context.fetch(fetchRequest)  // Fetch the Stock entities
               
               // Categorize stocks based on their listType
               activeStocks = stocks.filter { $0.listType == "active" }
               watchingStocks = stocks.filter { $0.listType == "watching" }
               
               // Populate the allSavedStockSymbols array with stock symbols
                allSavedStockSymbols = stocks.map { $0.symbol ?? "" }
               
               // Retrieve stock prices
               retrieveAllStockPrice()

               // Reload the table view with new data
               stockTableView.reloadData()
           } catch {
               print("Failed to fetch stocks: \(error)")
           }
       }

       // Pull to refresh handler
       @objc func refreshStocks() {
           // Refresh data by fetching from Core Data again
           fetchStocksFromCoreData()

           // End refreshing
           refreshControl.endRefreshing()
       }

    // UITableViewDataSource methods

    // Number of sections: 2 (Active and Watching)
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    // Section header titles
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section < headerTitles.count {
            return headerTitles[section]
        }
        return nil
    }

    // Number of rows in each section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {  // Active section
            return activeStocks.count
        } else if section == 1 {  // Watching section
            return watchingStocks.count
        }
        return 0
    }
    
    // Handle deletion of stocks
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let context = appdelegate.persistentContainer.viewContext
        
        if editingStyle == .delete {
            var stockToRemove: Stock?
            
            // Determine which array to remove the stock from
            if indexPath.section == 0 {
                stockToRemove = activeStocks.remove(at: indexPath.row)
            } else if indexPath.section == 1 {
                stockToRemove = watchingStocks.remove(at: indexPath.row)
            }
            // Remove the stock from Core Data
            if let stock = stockToRemove {
                context.delete(stock)
                appdelegate.savecontext()  // Save context to Core Data
            }
            // Delete the row from the table view
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    // Each cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StockCell", for: indexPath)
        
        var stock: Stock?
        
        // Determine which array to use based on the section
        if indexPath.section == 0 {
            stock = activeStocks[indexPath.row]
        } else if indexPath.section == 1 {
            stock = watchingStocks[indexPath.row]
        }

        // Configure the cell with stock data
        if let stock = stock {
            // Check the rank and append emoji to stock name accordingly
            if let rank = stock.rank {
                    switch rank.lowercased() {
                    case "super hot":
                        cell.textLabel?.text = "\(stock.name ?? "") 🔥🔥🔥"
                    case "hot":
                        cell.textLabel?.text = "\(stock.name ?? "") 🔥"
                    case "cold":
                        cell.textLabel?.text = "\(stock.name ?? "") ❄️"
                    default:
                        cell.textLabel?.text = stock.name
                    }
            } else {
                cell.textLabel?.text = stock.name
            }
            
        // Set the price in the subtitle
        if let symbol = stock.symbol, let stockInfo = stockPrices[symbol] {
            let priceString = String(format: "$%.2f", stockInfo.price)
                cell.detailTextLabel?.text = priceString
            } else {
                cell.detailTextLabel?.text = "Loading..."
            }
    }
        
        return cell
    }
    
    // Handle cell selection
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var stock: Stock?
        
        // Determine which array to use based on the section
        if indexPath.section == 0 {
            stock = activeStocks[indexPath.row]
        } else if indexPath.section == 1 {
            stock = watchingStocks[indexPath.row]
        }

        // If stock is found, retrieve its symbol and show the ratio
        if let stock = stock, let symbol = stock.symbol, let stockInfo = stockPrices[symbol] {
            // Create the message to display
            let message = "Current ratio: \(stockInfo.ratio)"
            
            // Create and show the UIAlertController
            let alertController = UIAlertController(title: stock.name, message: message, preferredStyle: .alert)
            
            // Add an "OK" button to dismiss the alert
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            
            // Present the alert
            present(alertController, animated: true, completion: nil)
        }
    }
    
    @IBAction func editBtnPressed(_ sender: UIButton) {
        let isEditing = stockTableView.isEditing
        stockTableView.setEditing(!isEditing, animated: true)
        
        // Change the button title based on the current editing mode
        sender.setTitle(isEditing ? "Edit" : "Done", for: .normal)
    }
    
    // Reordering stocklist type
    func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        var movedStock: Stock?
        
        // Determine which section the stock is being moved from
        if fromIndexPath.section == 0 {
            movedStock = activeStocks.remove(at: fromIndexPath.row)
        } else if fromIndexPath.section == 1 {
            movedStock = watchingStocks.remove(at: fromIndexPath.row)
        }

        // Move the stock to the new section
        if let stock = movedStock {
            if to.section == 0 {
                activeStocks.insert(stock, at: to.row)
                stock.listType = "active"  // Update the listType to "active"
            } else if to.section == 1 {
                watchingStocks.insert(stock, at: to.row)
                stock.listType = "watching"  // Update the listType to "watching"
            }
            
            // Save the changes to Core Data
            appdelegate.savecontext()
        }
    }

    // Allow rows to be movable
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    // Fetch stock prices from API and update stockPrices dictionary
    func retrieveAllStockPrice() {
        // Loop through all saved stock symbols to fetch prices
        for symbol in allSavedStockSymbols {
            fetchStockPrice(symbol: symbol)
        }
    }
        
    // Fetch stock price from Yahoo Finance API
    func fetchStockPrice(symbol: String) {
        let headers = [
            "x-rapidapi-key": "ee4dcbbf7emshaffd520a618dafep15d446jsn25b19c90b790",
            "x-rapidapi-host": "yahoo-finance15.p.rapidapi.com"
        ]
        
        // Construct the URL for the request
        let urlString = "https://yahoo-finance15.p.rapidapi.com/api/v1/markets/stock/modules?ticker=\(symbol)&module=financial-data"
            
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
            
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request) { (data, response, error) in
            if let data = data, error == nil {
                do {
                    // Decode the JSON response
                    let jsonDecoder = JSONDecoder()
                    
                    // Decode the response
                    let stockPriceResponse = try jsonDecoder.decode(StockPriceResponse.self, from: data)
                    
                    // Extract the current price
                    let currentPrice = stockPriceResponse.body.currentPrice.raw
                    let currentRatio = stockPriceResponse.body.currentRatio.raw
                    
                    let stockInfo = StockInfo(price: currentPrice, ratio: currentRatio)
                    // Update the stockPrices dictionary
                    DispatchQueue.main.async {
                        self.stockPrices[symbol] = stockInfo
                        self.stockTableView.reloadData()  // Reload table after price is fetched
                    }
                    
                    // Print the fetched price for debugging
                    print("Fetched current price for \(symbol): \(currentPrice)")
                } catch {
                    print("Error decoding JSON: \(error)")
                }
            } else {
                print("Error fetching data: \(String(describing: error))")
            }
        }
        
        // Start the network request
        dataTask.resume()
    }

}


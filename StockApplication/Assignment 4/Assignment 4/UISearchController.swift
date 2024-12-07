//
//  UISearchController.swift
//  Assignment 4
//
//  Created by Ziyang Wang on 2024-11-27.
//
import UIKit
import CoreData

class UISearchController : UIViewController,UISearchBarDelegate,UITableViewDataSource {
    let appdelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet weak var stockTableView: UITableView!
    @IBOutlet weak var searchStockBar: UISearchBar!
    @IBOutlet weak var doneBtn: UIButton!
    @IBOutlet weak var resultLabel: UILabel!
    

    var stockResults: [StockSymbol] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchStockBar.delegate = self
        stockTableView.dataSource = self
        
    }
    
    //https://rapidapi.com/manwilbahaa/api/yahoo-finance127/playground/apiendpoint_075055e3-be27-418b-9722-caa7945abfa2
    @IBAction func doneBtnPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        fetchStockDataFromSearchBar()
    }
        
    @IBAction func searchBtnPressed(_ sender: UIButton) {
        fetchStockDataFromSearchBar()
    }
    
    private func fetchStockDataFromSearchBar() {
        guard let stockSymbol = searchStockBar.text, !stockSymbol.isEmpty else {
            // Show an alert or handle the case where the symbol is empty
            return
        }
        
        // Call the function to fetch stock data with the entered symbol
        fetchStockData(stockSymbol: stockSymbol)
    }
    
    // Function to fetch stock data from the API
    func fetchStockData(stockSymbol: String) {
        let headers = [
            "x-rapidapi-key": "ee4dcbbf7emshaffd520a618dafep15d446jsn25b19c90b790",
            "x-rapidapi-host": "yahoo-finance15.p.rapidapi.com"
        ]
        
        let urlString = "https://yahoo-finance15.p.rapidapi.com/api/v1/markets/search?search=\(stockSymbol)"
        
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request) { [weak self] (data, response, error) in
            let jsonDecoder = JSONDecoder()
            
            if let data = data {
                do {
                    // Decode the response into the ApiResponse model
                    let stockResponse = try jsonDecoder.decode(ApiResponse.self, from: data)
                    
                    // Use the 'body' array to update stockResults
                    self?.stockResults = stockResponse.body
                    DispatchQueue.main.async {
                        // Reload the table view on the main thread
                        self?.stockTableView.reloadData()
                    }
                    
                } catch {
                    print("Error decoding JSON: \(error)")
                }
            } else if let error = error {
                print("Error: \(error.localizedDescription)")
            }
        }
        
        // Start the network request
        dataTask.resume()
    }
    
    // Return the number of rows in the table
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stockResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StockCell", for: indexPath)
        
        let stock = stockResults[indexPath.row]
        cell.textLabel?.text = stock.name

        if let addButton = cell.viewWithTag(100) as? UIButton {
            // Set the tag of the button to identify which row it's in
            addButton.tag = indexPath.row
            
            // Remove any previous target to prevent duplicate actions
            addButton.removeTarget(self, action: #selector(addButtonTapped(sender:)), for: .touchUpInside)
            
            // Add the target-action for the "Add" button tap
            addButton.addTarget(self, action: #selector(addButtonTapped(sender:)), for: .touchUpInside)
        }
        
        return cell
    }
    
    @objc func addButtonTapped(sender: UIButton) {
        // Get the row index from the button's tag
        let rowIndex = sender.tag
        let stock = stockResults[rowIndex]
        
        // Save the stock to Core Data
        saveStockToCoreData(stock: stock)
        print("Add button tapped for stock: \(stock.name)")
        
        let alertController = UIAlertController(title: "Success", message: "\(stock.name) has been added to your watching list!", preferredStyle: .alert)
        
        // Add an action to dismiss the alert
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(action)
        
        // Present the alert to the user
        present(alertController, animated: true, completion: nil)
    }

    // Save stock data to Core Data
    func saveStockToCoreData(stock: StockSymbol) {
        // Create a new Stock entity in Core Data
        let stockSaved = Stock(context: appdelegate.persistentContainer.viewContext)
        
        // Set the attributes
        stockSaved.name = stock.name
        stockSaved.symbol = stock.symbol
        stockSaved.rank = "normal"
        stockSaved.listType = "watching"

        // Save to Core Data
        appdelegate.savecontext()
        
    }

    
}


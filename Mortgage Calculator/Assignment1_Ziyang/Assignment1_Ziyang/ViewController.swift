//
//  ViewController.swift
//  Assignment1_Ziyang
//
//  Created by Ziyang on 2024-09-22.
//

import UIKit

struct Mortgage{
    var purchasePrice: Float
    var dp: Float
    var interestRate: Float
    var timeRange: Int
    var loan: Float
    var monthlyPay: Float
}

class ViewController: UIViewController, UITextFieldDelegate {
    
    //Text View
    @IBOutlet weak var mortgageCalDisplay: UITextView!
    @IBOutlet weak var savedListTextView: UITextView!
    
    //Label
    @IBOutlet weak var myPurchasePrice: UILabel!
    @IBOutlet weak var myPurchaseAmount: UILabel!
    @IBOutlet weak var myDp: UILabel!
    @IBOutlet weak var myDpAmount: UILabel!
    @IBOutlet weak var myInterestRate: UILabel!
    @IBOutlet weak var myInterestRateAmount: UILabel!
    @IBOutlet weak var loanAmount: UILabel!
    @IBOutlet weak var estimatedMonthlyAmount: UILabel!
    @IBOutlet weak var timeRange: UILabel!
    
    //UIview
    @IBOutlet weak var calculatorView: UIView!
    @IBOutlet weak var savedListView: UIView!
    @IBOutlet weak var customInputView: UIView!
    
    //TextField
    @IBOutlet weak var purchasePriceTextField: UITextField!
    @IBOutlet weak var dpTextField: UITextField!
    @IBOutlet weak var interestRateTextField: UITextField!
    
    var mortgage = Mortgage(purchasePrice: 5000000, dp: 500000, interestRate: 5, timeRange: 20, loan: 0.0, monthlyPay: 0.0)
    var savedMortgages: [Mortgage] = [] //mortgage array
    var originalPurchasePrice = "5000000"
    var originalDP = "500000"
    var originalInterestRate = "5%"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //display calculator view after load
        calculatorView.isHidden = false
        savedListView.isHidden = true
        customInputView.isHidden = true
        savedListTextView.isScrollEnabled = true
        
        purchasePriceTextField.text = originalPurchasePrice
        purchasePriceTextField.delegate = self // Set the delegate
        
        dpTextField.text = originalDP
        dpTextField.delegate = self // Set the delegate
        
        interestRateTextField.text = originalInterestRate
        interestRateTextField.delegate = self // Set the delegate
     
        uiUpdate()
    }
    
    func uiUpdate(){
        loanAmount.text = calculateLoan()
        estimatedMonthlyAmount.text = calculateMonthlyPay()
    }
    
    @IBAction func switchView(_ sender: UISegmentedControl) {
         switch sender.selectedSegmentIndex {
             //if user select calculator,display
             case 0:
                 calculatorView.isHidden = false
                 savedListView.isHidden = true
             case 1:
                 calculatorView.isHidden = true
                 savedListView.isHidden = false
                 updateSavedListView()
             default:
                 break
         }
     }
    
    
    @IBAction func purchaseSliderChanged(_ sender: UISlider) {
        mortgage.purchasePrice = sender.value
        let floatValue = Float(sender.value)
        myPurchaseAmount.text = formatNumber(floatValue)
        loanAmount.text = calculateLoan()
        estimatedMonthlyAmount.text = calculateMonthlyPay()
    }
 
    
    @IBAction func dpSliderChanged(_ sender: UISlider) {
        mortgage.dp = sender.value
        let floatValue = Float(sender.value)
        myDpAmount.text = formatNumber(floatValue)
        loanAmount.text = calculateLoan()
        estimatedMonthlyAmount.text = calculateMonthlyPay()
    }
    
    @IBAction func interestRateSliderChanged(_ sender: UISlider) {
        mortgage.interestRate = sender.value
        let interestRate = String(format: "%.1f", sender.value)
        myInterestRateAmount.text = "\(interestRate)%"
        estimatedMonthlyAmount.text = calculateMonthlyPay()
    }
    
    //format the number as curreny and add dollar sign
    func formatNumber(_ number: Float) -> String {
        let numFormat = NumberFormatter()
        numFormat.numberStyle = .currency
        numFormat.currencySymbol = "$"
        numFormat.minimumFractionDigits = 2
        numFormat.maximumFractionDigits = 2
        let formattedString = numFormat.string(from: NSNumber(value: number))
        return formattedString ?? "$0.00"
    }
    
    //calculate loan amount
    func calculateLoan() -> String{
        mortgage.loan  = mortgage.purchasePrice - mortgage.dp
        return formatNumber(mortgage.loan)
    }
   
    @IBAction func timeRangeChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
            case 0:
                mortgage.timeRange = 20
            case 1:
                mortgage.timeRange = 25
            case 2:
                mortgage.timeRange = 30
            case 3:
                mortgage.timeRange = 35
            default:
                break
            }
        timeRange.text = "\(mortgage.timeRange) years"
        estimatedMonthlyAmount.text = calculateMonthlyPay()
    }
    

    func calculateMonthlyPay() -> String{
        mortgage.loan = mortgage.purchasePrice - mortgage.dp
        let monthlyInterestRate = mortgage.interestRate / 100 / 12
        // Number of payments based on the time range
        let numberOfPayments = mortgage.timeRange * 12
        // Monthly payment calculation
        if mortgage.interestRate == 0 {
            mortgage.monthlyPay = mortgage.loan / Float(numberOfPayments)
        } else {
            mortgage.monthlyPay = mortgage.loan * (monthlyInterestRate * pow(1 + monthlyInterestRate,Float(numberOfPayments))) / (pow(1 + monthlyInterestRate, Float(numberOfPayments)) - 1)
        }
        return formatNumber(mortgage.monthlyPay)
    }
    
    @IBAction func savedButton(_ sender: Any) {
        mortgage.loan = mortgage.purchasePrice - mortgage.dp
        var updateMonthlyPay = calculateMonthlyPay()
        savedMortgages.append(mortgage)
        updateSavedListView()
    }
    
    //Display mortgage details
    func updateSavedListView() {
        var savedText = "Saved Mortgages:\n\n"
        for savedMortgage in savedMortgages {
            savedText += "Purchase Price: \(formatNumber(savedMortgage.purchasePrice))\n"
            savedText += "Down Payment: \(formatNumber(savedMortgage.dp))\n"
            savedText += "Interest Rate: \(String(format: "%.1f", savedMortgage.interestRate))%\n"
            savedText += "Time Range: \(savedMortgage.timeRange) years\n"
            savedText += "Loan Amount: \(formatNumber(savedMortgage.loan))\n"
            savedText += "Monthly Payment: \(formatNumber(savedMortgage.monthlyPay))\n"
            savedText += "\n"
        }
        savedListTextView.text = savedText
    }

//    Overview
//    The Custom Input feature allows users to input their mortgage parameters (purchase price, down payment, and interest rate) manually through text fields.     This enhances the user experience by providing flexibility and precision when calculating mortgage values.

    @IBAction func customInput(_ sender: UIButton) {
        // Show the custom input view when the button is pressed
        customInputView.isHidden = false
        
        // Populate the text fields with the current values from the displayed amounts
        purchasePriceTextField.text = myPurchaseAmount.text
        originalPurchasePrice = purchasePriceTextField.text! // Store the original purchase price for reference
        
        dpTextField.text = myDpAmount.text
        originalDP = dpTextField.text! // Store the original down payment for reference
        
        interestRateTextField.text = myInterestRateAmount.text
        originalInterestRate = interestRateTextField.text! // Store the original interest rate for reference
    }

    @IBAction func backToSlider(_ sender: UIButton) {
        // Hide the custom input view when returning to the slider view
        customInputView.isHidden = true
        
        // Update the displayed amounts with the values from the text fields
        myPurchaseAmount.text = purchasePriceTextField.text // Set the displayed purchase amount
        myDpAmount.text = dpTextField.text // Set the displayed down payment
        myInterestRateAmount.text = interestRateTextField.text // Set the displayed interest rate
    }
    
    // UITextFieldDelegate method to clear the text field on focus
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == purchasePriceTextField {
            originalPurchasePrice = purchasePriceTextField.text!
            purchasePriceTextField.text = "" // Clear the text field
        }
        
        if textField == interestRateTextField {
            originalInterestRate = interestRateTextField.text!
            interestRateTextField.text = "" // Clear the text field
        }
        
        if textField == dpTextField {
            originalDP = dpTextField.text!
            dpTextField.text = "" // Clear the text field
        }
    }
    
    @IBAction func customPrice(_ sender: UITextField) {
        // Clear the dollar sign for input processing
        let rawText = sender.text?.replacingOccurrences(of: "$", with: "").trimmingCharacters(in: .whitespaces)
        
        // Attempt to convert the cleaned text to a Float value
        if let text = rawText, let value = Float(text) {
            mortgage.purchasePrice = value
            purchasePriceTextField.text = formatNumber(value)
            originalPurchasePrice = purchasePriceTextField.text! // Store the formatted value as the original
            loanAmount.text = calculateLoan()
            estimatedMonthlyAmount.text = calculateMonthlyPay()
            // Set the text field back with the formatted value
            sender.text = formatNumber(value)
        } else if sender.text?.isEmpty == true {
            sender.text = originalPurchasePrice
        }
    }

    @IBAction func customDp(_ sender: UITextField) {
        // Clear the dollar sign for input processing
        let rawText = sender.text?.replacingOccurrences(of: "$", with: "").trimmingCharacters(in: .whitespaces)
        
        // Attempt to convert the cleaned text to a Float value
        if let text = rawText, let value = Float(text) {
            mortgage.dp = value
            dpTextField.text = formatNumber(value)
            originalDP = dpTextField.text! // Store the formatted value as the original
            loanAmount.text = calculateLoan()
            estimatedMonthlyAmount.text = calculateMonthlyPay()
            // Set the text field back with the formatted value
            sender.text = formatNumber(value)
        } else {
            sender.text = originalDP
        }
    }

    @IBAction func customInterestRate(_ sender: UITextField) {
        // Clear the percent sign for input processing
        let rawText = sender.text?.replacingOccurrences(of: "%", with: "").trimmingCharacters(in: .whitespaces)
        
        // Attempt to convert the cleaned text to a Float value
        if let text = rawText, let value = Float(text) {
            mortgage.interestRate = value
            interestRateTextField.text = "\(String(format: "%.1f", value))%"
            originalInterestRate = interestRateTextField.text! // Store the formatted value as the original
            estimatedMonthlyAmount.text = calculateMonthlyPay()
            // Set the text field back with the formatted value
            sender.text = "\(String(format: "%.1f", value))%"
        } else {
            sender.text = originalInterestRate
        }
    }

}


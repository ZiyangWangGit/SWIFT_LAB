# Mortgage Calculator App

This project is an iOS application designed to help users calculate mortgage payments based on several variables like purchase price, down payment, interest rate, and the mortgage time range. It provides both sliders for easy adjustments and custom inputs for precise values, and it allows users to save and view their mortgage calculations.

## Features

- **Real-time Mortgage Calculation:** 
  - Calculate loan amount and estimated monthly payment based on the purchase price, down payment, interest rate, and time range.
  - Sliders for adjusting purchase price, down payment, and interest rate dynamically.
  - Manual custom input for precise mortgage calculations.

- **Saved Mortgage List:**
  - Allows users to save multiple mortgage calculations.
  - Displays saved mortgage details including purchase price, down payment, interest rate, loan amount, and monthly payment.

- **Custom Input Mode:**
  - Users can manually input their mortgage parameters (purchase price, down payment, interest rate) for a more tailored calculation experience.
  
## Technologies Used

- **Language:** Swift
- **Framework:** UIKit for UI components and interaction
- **Design Pattern:** MVC (Model-View-Controller)

## How to Use

1. **Input Variables:**
   - Use the sliders to set the **Purchase Price**, **Down Payment**, and **Interest Rate**.
   - Choose the time range (20, 25, 30, or 35 years) from the segmented control.

2. **View Results:**
   - The loan amount and estimated monthly payment are calculated in real-time and displayed as you adjust the sliders or input custom values.

3. **Switch Views:**
   - Use the segmented control to switch between the **Calculator View** and the **Saved List View**.
   - The **Saved List View** will show all previously saved mortgage calculations.

4. **Save Mortgage Calculation:**
   - After configuring the mortgage parameters, press the **Save** button to store the current calculation.
   - Saved calculations are displayed in the **Saved List View**.

5. **Custom Inputs:**
   - Press the **Custom Input** button to manually input the purchase price, down payment, and interest rate through text fields.

6. **Back to Slider View:**
   - After using custom inputs, press the **Back to Slider** button to return to the slider controls.
   
   - ![mortgage_calculator](https://github.com/user-attachments/assets/f0d5bfaf-eda1-4992-bd0a-a2bc442595d2)
![saved_list](https://github.com/user-attachments/assets/a6a04b29-f39d-40f7-a0ba-451922c4c52c)



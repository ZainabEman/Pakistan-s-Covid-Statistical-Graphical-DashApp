# 📊 Probability Project: Analyzing COVID Data

Welcome to the **Probability Project**! This Dash application is designed to provide a comprehensive analysis of COVID-19 data using various statistical methods and visualizations. 🌟

## 🚀 Introduction

This project leverages the power of Dash and Plotly to explore COVID-19 data in a fun and interactive way. With options for summary statistics, probability calculations, and predictions, this tool is your go-to for visualizing and analyzing COVID-19 statistics. Whether you're a student of probability and statistics or just curious about data trends, this app has something for you!

## 🔍 Features

- **Summary Statistics**: Get descriptive statistics of COVID-19 cases, deaths, and recoveries.
- **Probability Analysis**: Visualize the probabilities of deaths and recoveries across different provinces.
- **Graphical Representations**: Explore various plots including scatter plots, pie charts, and bar charts.
- **Predictions**: Make predictions about deaths and recoveries based on new case inputs.

### 1. **Load Data** 
The app reads COVID-19 data from a CSV file. Make sure to update the file path to the location of your `PKcovid.csv` file.```python file_path = r"C:\Users\Admin\Downloads\pakCovid\PKcovid.csv" mydata = pd.read_csv(file_path)  

### 2. **App Layout**

The layout consists of dropdowns, buttons, and various graphs:

- **Dropdown Menu**: Select the type of analysis you want to perform.
- **Prediction Inputs**: Enter new case values to predict deaths and recoveries.
- **Graphs**: Visualizations are updated based on your selection.

### 3. **Callbacks**

The app uses Dash callbacks to update the content based on user interactions:

- **Toggle Prediction Inputs**: Shows or hides prediction inputs based on dropdown selection.
- **Run Analysis**: Computes and displays results based on the selected analysis type.

## 🔧 Dependencies

Make sure you have the following Python packages installed:

- `dash`: For building the interactive web application.
- `dash_bootstrap_components`: For enhanced styling and layout.
- `pandas`: For data manipulation and analysis.
- `plotly`: For creating interactive plots and charts.
- `statsmodels`: For statistical modeling and predictions.

You can install the dependencies using pip:

bash

Copy code

`pip install dash dash-bootstrap-components pandas plotly statsmodels`

## 📊 Available Analyses

### **1. Summary Statistics**

Displays descriptive statistics for cases, deaths, and recoveries.

### **2. Probability Calculations**

Calculates and visualizes the probabilities of death and recovery by province.

### **3. Graphical Representations**

Generates various plots including:

- Scatter plots of deaths and recoveries.
- Pie charts of cases, deaths, and recoveries.
- Bar charts showing component values.

### **4. Predictions**

Uses linear regression to predict deaths and recoveries based on user-provided case values.

Here are the results:
![Linear Reggression Prediction](https://github.com/user-attachments/assets/746c2a81-9d40-4106-80b4-101e45cfd659)



## 📝 Running the App

To run the app, simply execute the following command in your terminal:

bash

Copy code

`python app.py`

The app will start running on your local server. Open your web browser and navigate to `http://127.0.0.1:8050/` to start exploring the data.

## 📂 File Structure

- `app.py`: Main Python script for the Dash application.
- `PKcovid.csv`: CSV file containing the COVID-19 data.

## 💬 Contributing

If you'd like to contribute to this project, feel free to fork the repository, make changes, and submit a pull request. Contributions, feedback, and suggestions are always welcome!

//
//  WeatherViewController.swift
//  E2WeatherApp
//
//  Created by LOKESH on 29/02/24.
//

import Foundation
import UIKit

class WeatherViewController: UIViewController {
    // UI Components
    private let tableView = UITableView()
    private let dashboardView = UIView()
    private let currentTempLabel = UILabel()
    private let currentWeatherLabel = UILabel()
    private var asyncImageView: UIImageView!


    
    // ViewModel
    private let weatherViewModel = WeatherViewModel1()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fetchData()
    }

    private func setupUI() {
        // TableView
        tableView.delegate = self
        tableView.dataSource = self

        // DashboardView
        dashboardView.addSubview(currentTempLabel)
        dashboardView.addSubview(currentWeatherLabel)

        // AsyncImageView
        asyncImageView = UIImageView()
        dashboardView.addSubview(asyncImageView)

        // Constraints
        

        
        currentTempLabel.translatesAutoresizingMaskIntoConstraints = false
        currentTempLabel.topAnchor.constraint(equalTo: dashboardView.topAnchor, constant: 100).isActive = true
        currentTempLabel.leadingAnchor.constraint(equalTo: dashboardView.leadingAnchor, constant: 20).isActive = true

        currentWeatherLabel.translatesAutoresizingMaskIntoConstraints = false
        currentWeatherLabel.topAnchor.constraint(equalTo: currentTempLabel.bottomAnchor, constant: 10).isActive = true
        currentWeatherLabel.leadingAnchor.constraint(equalTo: dashboardView.leadingAnchor, constant: 20).isActive = true

        asyncImageView.translatesAutoresizingMaskIntoConstraints = false
        asyncImageView.topAnchor.constraint(equalTo: currentWeatherLabel.bottomAnchor, constant: 10).isActive = true
        asyncImageView.leadingAnchor.constraint(equalTo: dashboardView.leadingAnchor, constant: 20).isActive = true
                  
      

        // Add subviews
        view.addSubview(tableView)
        view.addSubview(dashboardView)

        // Constraints
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true

        dashboardView.translatesAutoresizingMaskIntoConstraints = true
        dashboardView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        dashboardView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        dashboardView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        dashboardView.heightAnchor.constraint(equalToConstant: 100).isActive = true
                  
        
    }

    private func fetchData() {
        weatherViewModel.fetchWeather { [weak self] success in
            guard success else {
                print("Error fetching weather data")
                return
            }
            DispatchQueue.main.async {
                self?.updateUI()
            }
        }
    }

    private func updateUI() {
        if let currentWeather = weatherViewModel.currentWeather {
            currentTempLabel.text = "\(currentWeather.main.temp)°C"
            currentWeatherLabel.text = "\(currentWeather.weather[0].main.rawValue)"

            // Load image asynchronously
            //if let iconURLString = currentWeather.weather[0].icon.rawValue {
                let urlString = "https://openweathermap.org/img/w/\(currentWeather.weather[0].icon.rawValue).png"
                if let url = URL(string: urlString) {
                    URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
                        guard let data = data, error == nil else { return }
                        DispatchQueue.main.async {
                            self?.asyncImageView.image = UIImage(data: data)
                        }
                    }.resume()
                }
            //}
        }
        tableView.reloadData()
    }
}

extension WeatherViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weatherViewModel.forecasts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        let forecast = weatherViewModel.forecasts[indexPath.row]
        cell.textLabel?.text = "\(forecast.dtTxt)"
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let forecast = weatherViewModel.forecasts[indexPath.row]
        let detailViewController = DetailViewController(forecast: forecast, cit: weatherViewModel.cityObject!)
        navigationController?.pushViewController(detailViewController, animated: true)
    }
}

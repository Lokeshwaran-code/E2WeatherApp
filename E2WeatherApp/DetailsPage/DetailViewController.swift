//
//  DetailViewController.swift
//  E2WeatherApp
//
//  Created by LOKESH on 29/02/24.
//

import Foundation
import UIKit


class DetailViewController: UIViewController
{
    private let forecast: List
    private let cityObj: City
    private let tempLabel = UILabel()
    private let temp_min = UILabel()
    private let temp_max = UILabel()
    private let weatherStatus = UILabel()
    private let humidity = UILabel()
    private let sunrise = UILabel()
    private let sunset = UILabel()
    private var imageView = UIImageView()
    

    init(forecast: List, cit: City) {
        self.forecast = forecast
        self.cityObj = cit
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
           super.viewDidLoad()
           view.backgroundColor = .white

           // Display forecast details
           tempLabel.text = "\(forecast.main.temp)°C"
           view.addSubview(tempLabel)
           
           temp_min.text = "Min Temp: \(forecast.main.tempMin)"
           view.addSubview(temp_min)

           temp_max.text = "Max Temp: \(forecast.main.tempMax)"
           view.addSubview(temp_max)

           weatherStatus.text = "Weather: \(forecast.weather[0].description)"
           view.addSubview(weatherStatus)

           humidity.text = "Humidity: \(forecast.main.humidity)"
           view.addSubview(humidity)

           sunrise.text = "Sunrise: \(cityObj.sunrise)"
           view.addSubview(sunrise)

           sunset.text = "Sunset: \(cityObj.sunset)"
           view.addSubview(sunset)
           
           // Configure the image view
           imageView.contentMode = .scaleAspectFit
           view.addSubview(imageView)

           // Constraints
           tempLabel.translatesAutoresizingMaskIntoConstraints = false
           tempLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
           tempLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
           
           temp_min.translatesAutoresizingMaskIntoConstraints = false
           temp_min.topAnchor.constraint(equalTo: tempLabel.bottomAnchor, constant: 20).isActive = true
           temp_min.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
           
           temp_max.translatesAutoresizingMaskIntoConstraints = false
           temp_max.topAnchor.constraint(equalTo: temp_min.bottomAnchor, constant: 20).isActive = true
           temp_max.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
           
           weatherStatus.translatesAutoresizingMaskIntoConstraints = false
           weatherStatus.topAnchor.constraint(equalTo: temp_max.bottomAnchor, constant: 20).isActive = true
           weatherStatus.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
           
           humidity.translatesAutoresizingMaskIntoConstraints = false
           humidity.topAnchor.constraint(equalTo: weatherStatus.bottomAnchor, constant: 20).isActive = true
           humidity.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
           
           sunrise.translatesAutoresizingMaskIntoConstraints = false
           sunrise.topAnchor.constraint(equalTo: humidity.bottomAnchor, constant: 20).isActive = true
           sunrise.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
           
           sunset.translatesAutoresizingMaskIntoConstraints = false
           sunset.topAnchor.constraint(equalTo: sunrise.bottomAnchor, constant: 20).isActive = true
           sunset.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
           
           imageView.translatesAutoresizingMaskIntoConstraints = false
           imageView.topAnchor.constraint(equalTo: sunset.bottomAnchor, constant: 20).isActive = true
           imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
           imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
           imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20).isActive = true
           
           let urlString = "https://openweathermap.org/img/w/\(forecast.weather[0].icon.rawValue).png"
           if let url = URL(string: urlString) {
               URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
                   guard let data = data, error == nil else { return }
                   DispatchQueue.main.async {
                       self?.imageView.image = UIImage(data: data)
                   }
               }.resume()
           }
       }
}

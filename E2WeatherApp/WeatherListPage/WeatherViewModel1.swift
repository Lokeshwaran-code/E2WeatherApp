//
//  WeatherViewModel1.swift
//  E2WeatherApp
//
//  Created by LOKESH on 29/02/24.
//

import Foundation

import UIKit


class WeatherViewModel1
{
    var currentWeather: List?
    var forecasts: [List] = []
    var cityObject: City?

    func fetchWeather(completion: @escaping (Bool) -> Void) {
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/forecast?q=CHENNAI&appid=9ba9b2170e8ac964f2d0c2d0b6a2f45b") else {
            completion(false)
            return
        }

        URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let data = data, error == nil else {
                completion(false)
                return
            }
            do {
                let response = try JSONDecoder().decode(Welcome.self, from: data)
                self?.currentWeather = response.list.first
                self?.forecasts = response.list
                self?.cityObject = response.city
                completion(true)
            } catch {
                print("Error fetching weather data: \(error.localizedDescription)")
                completion(false)
            }
        }.resume()
    }
}


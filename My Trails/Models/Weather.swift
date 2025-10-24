//
//  Weather.swift
//  My Trails
//
//  Weather domain model using OpenWeather and MET Norway data sources.
//

import Foundation
import CoreLocation

struct WeatherForecast: Identifiable, Codable, Hashable {
    let id: UUID
    var location: CLLocationCoordinate2D
    var hourly: [HourlyWeather]
    var daily: [DailyWeather]
    var updatedAt: Date

    init(id: UUID = UUID(), location: CLLocationCoordinate2D, hourly: [HourlyWeather], daily: [DailyWeather], updatedAt: Date = .now) {
        self.id = id
        self.location = location
        self.hourly = hourly
        self.daily = daily
        self.updatedAt = updatedAt
    }
}

struct HourlyWeather: Identifiable, Codable, Hashable {
    let id: UUID
    var timestamp: Date
    var temperature: Measurement<UnitTemperature>
    var precipitationProbability: Double
    var windSpeed: Measurement<UnitSpeed>
    var visibility: Measurement<UnitLength>
    var condition: WeatherCondition

    init(
        id: UUID = UUID(),
        timestamp: Date,
        temperature: Measurement<UnitTemperature>,
        precipitationProbability: Double,
        windSpeed: Measurement<UnitSpeed>,
        visibility: Measurement<UnitLength>,
        condition: WeatherCondition
    ) {
        self.id = id
        self.timestamp = timestamp
        self.temperature = temperature
        self.precipitationProbability = precipitationProbability
        self.windSpeed = windSpeed
        self.visibility = visibility
        self.condition = condition
    }
}

struct DailyWeather: Identifiable, Codable, Hashable {
    let id: UUID
    var date: Date
    var sunrise: Date
    var sunset: Date
    var minTemperature: Measurement<UnitTemperature>
    var maxTemperature: Measurement<UnitTemperature>
    var condition: WeatherCondition
    var avalancheRisk: AvalancheRisk
}

enum WeatherCondition: String, Codable, CaseIterable {
    case clear
    case partlyCloudy
    case cloudy
    case rain
    case storm
    case snow
    case fog
}

enum AvalancheRisk: String, Codable, CaseIterable {
    case low
    case moderate
    case considerable
    case high
    case extreme
}

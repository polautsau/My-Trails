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

    private enum CodingKeys: String, CodingKey {
        case id
        case latitude
        case longitude
        case hourly
        case daily
        case updatedAt
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        let latitude = try container.decode(CLLocationDegrees.self, forKey: .latitude)
        let longitude = try container.decode(CLLocationDegrees.self, forKey: .longitude)
        location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        hourly = try container.decode([HourlyWeather].self, forKey: .hourly)
        daily = try container.decode([DailyWeather].self, forKey: .daily)
        updatedAt = try container.decode(Date.self, forKey: .updatedAt)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(location.latitude, forKey: .latitude)
        try container.encode(location.longitude, forKey: .longitude)
        try container.encode(hourly, forKey: .hourly)
        try container.encode(daily, forKey: .daily)
        try container.encode(updatedAt, forKey: .updatedAt)
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
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

    private enum CodingKeys: String, CodingKey {
        case id
        case timestamp
        case temperatureCelsius
        case precipitationProbability
        case windSpeedMetersPerSecond
        case visibilityMeters
        case condition
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        timestamp = try container.decode(Date.self, forKey: .timestamp)
        let temp = try container.decode(Double.self, forKey: .temperatureCelsius)
        temperature = Measurement(value: temp, unit: .celsius)
        precipitationProbability = try container.decode(Double.self, forKey: .precipitationProbability)
        let wind = try container.decode(Double.self, forKey: .windSpeedMetersPerSecond)
        windSpeed = Measurement(value: wind, unit: .metersPerSecond)
        let visibilityMeters = try container.decode(Double.self, forKey: .visibilityMeters)
        visibility = Measurement(value: visibilityMeters, unit: .meters)
        condition = try container.decode(WeatherCondition.self, forKey: .condition)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(timestamp, forKey: .timestamp)
        try container.encode(temperature.converted(to: .celsius).value, forKey: .temperatureCelsius)
        try container.encode(precipitationProbability, forKey: .precipitationProbability)
        try container.encode(windSpeed.converted(to: .metersPerSecond).value, forKey: .windSpeedMetersPerSecond)
        try container.encode(visibility.converted(to: .meters).value, forKey: .visibilityMeters)
        try container.encode(condition, forKey: .condition)
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

    private enum CodingKeys: String, CodingKey {
        case id
        case date
        case sunrise
        case sunset
        case minTemperatureCelsius
        case maxTemperatureCelsius
        case condition
        case avalancheRisk
    }

    init(
        id: UUID = UUID(),
        date: Date,
        sunrise: Date,
        sunset: Date,
        minTemperature: Measurement<UnitTemperature>,
        maxTemperature: Measurement<UnitTemperature>,
        condition: WeatherCondition,
        avalancheRisk: AvalancheRisk
    ) {
        self.id = id
        self.date = date
        self.sunrise = sunrise
        self.sunset = sunset
        self.minTemperature = minTemperature
        self.maxTemperature = maxTemperature
        self.condition = condition
        self.avalancheRisk = avalancheRisk
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        date = try container.decode(Date.self, forKey: .date)
        sunrise = try container.decode(Date.self, forKey: .sunrise)
        sunset = try container.decode(Date.self, forKey: .sunset)
        let minTemp = try container.decode(Double.self, forKey: .minTemperatureCelsius)
        minTemperature = Measurement(value: minTemp, unit: .celsius)
        let maxTemp = try container.decode(Double.self, forKey: .maxTemperatureCelsius)
        maxTemperature = Measurement(value: maxTemp, unit: .celsius)
        condition = try container.decode(WeatherCondition.self, forKey: .condition)
        avalancheRisk = try container.decode(AvalancheRisk.self, forKey: .avalancheRisk)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(date, forKey: .date)
        try container.encode(sunrise, forKey: .sunrise)
        try container.encode(sunset, forKey: .sunset)
        try container.encode(minTemperature.converted(to: .celsius).value, forKey: .minTemperatureCelsius)
        try container.encode(maxTemperature.converted(to: .celsius).value, forKey: .maxTemperatureCelsius)
        try container.encode(condition, forKey: .condition)
        try container.encode(avalancheRisk, forKey: .avalancheRisk)
    }
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

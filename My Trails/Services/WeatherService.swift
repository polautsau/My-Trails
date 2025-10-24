//
//  WeatherService.swift
//  My Trails
//
//  Provides 48h and 7d forecasts with support for offline caching.
//

import Foundation
import Combine
import CoreLocation

protocol WeatherService {
    var supportsExtendedForecast: Bool { get }
    func prepare() async throws
    func forecast(for location: CLLocationCoordinate2D, includeExtended: Bool) async throws -> WeatherForecast
}

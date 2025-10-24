//
//  MapPreviewView.swift
//  My Trails
//
//  Displays MapLibre/MapKit preview per TRD.
//

import SwiftUI
import MapKit

struct MapPreviewView: View {
    var trail: Trail

    var body: some View {
        if #available(iOS 17, *) {
            Map(initialPosition: .region(region))
                .mapControls {
                    MapCompass()
                    MapPitchToggle()
                }
                .mapStyle(.hybrid(elevation: .realistic))
        } else {
            Map(coordinateRegion: .constant(region))
        }
    }

    private var region: MKCoordinateRegion {
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: trail.trailheadCoordinate.latitude, longitude: trail.trailheadCoordinate.longitude),
            span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        )
    }
}

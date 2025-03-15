//
//  MapUIView.swift
//  IRLGallery
//
//  Created by Zain Ashraf on 6/11/24.
//

import SwiftUI
import MapKit

//my post all world
//login auto
//logout
//citi label

struct MapUIView: View {
    @ObservedObject var locationManager = LocationManager()
    @State var cameraPosition = MapCameraPosition.region(MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 34.011_284, longitude: -116.166_860),
        span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)))
    var body: some View {
        if let myLocation = locationManager.location {
            Text("Latitude: \(myLocation.latitude.formatted(.number.precision(.fractionLength(0)))), Longitude: \(myLocation.longitude.formatted(.number.precision(.fractionLength(0))))".uppercased())
            Map(position: $cameraPosition)
                .onAppear(perform: {
                    cameraPosition = MapCameraPosition.region(MKCoordinateRegion(
                        center: locationManager.location!,
                        span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)))
                })
        }
    }
}

#Preview {
    MapUIView()
}

//
//  MainTabView.swift
//  My Trails
//
//  Core navigation tabs: Discover, Record, Offline, Profile.
//

import SwiftUI

struct MainTabView: View {
    @State private var selection = 0

    var body: some View {
        TabView(selection: $selection) {
            TrailDiscoveryView()
                .tabItem {
                    Label("Discover", systemImage: "map")
                }
                .tag(0)
            RecordView()
                .tabItem {
                    Label("Record", systemImage: "dot.circle.and.cursorarrow")
                }
                .tag(1)
            OfflineDownloadsView()
                .tabItem {
                    Label("Offline", systemImage: "arrow.down.square")
                }
                .tag(2)
            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person.crop.circle")
                }
                .tag(3)
        }
        .tint(.cyan)
    }
}

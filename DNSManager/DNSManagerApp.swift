//
//  DNSManagerApp.swift
//  DNSManager
//
//  Created by Hadi Sharghi on 8/31/24.
//

import SwiftUI

@main
struct DNSManagerApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}

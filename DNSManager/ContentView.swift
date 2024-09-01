//
//  ContentView.swift
//  DNSManager
//
//  Created by Hadi Sharghi on 8/31/24.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    var body: some View {
        Text("DNS Manager")
            .padding(64)
    }
}

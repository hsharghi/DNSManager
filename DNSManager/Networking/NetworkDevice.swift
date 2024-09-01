//
//  NetworkDevice.swift
//  DNSManager
//
//  Created by Hadi Sharghi on 9/1/24.
//

import Foundation


struct NetworkDevice {
    //    var id = UUID()
    var name: String
    var device: String
    var isSelected: Bool
    
    init(name: String, device: String, isSelected: Bool = false) {
        self.name = name
        self.device = device
        self.isSelected = isSelected
    }
    
    var description: String {
        "\(name) - \(device)"
    }
}


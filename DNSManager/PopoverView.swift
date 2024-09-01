//
//  PopoverView.swift
//  DNSManager
//
//  Created by Hadi Sharghi on 8/31/24.
//

import SwiftUI



struct PopoverView: View {
    
    @State var networkDevices: [NetworkDevice] = []
    
    var body: some View {
        
        List(networkDevices.indices, id: \.self) { index in
            HStack {
                Text("\(self.networkDevices[index].name)")
                Toggle("", isOn: self.$networkDevices[index].isSelected)
                    .onChange(of: self.networkDevices[index].isSelected) { oldValue, newValue in
                        var selectedDevices: [String] = (UserDefaults.standard.array(forKey: NetworkManager.storageKey) as? [String]) ?? []
                        let device = $networkDevices[index].device.wrappedValue
                        if newValue == true {
                            selectedDevices.append(device)
                        } else {
                            selectedDevices.removeAll(where: { $0 == device })
                        }
                        UserDefaults.standard.setValue(selectedDevices, forKey: NetworkManager.storageKey)
                    }
            }
        }
        .onAppear(perform: {
            networkDevices = try! NetworkManager.shared.getDevices()
        })
    }
   
}

#Preview {
    PopoverView()
}

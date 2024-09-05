//
//  PopoverView.swift
//  DNSManager
//
//  Created by Hadi Sharghi on 8/31/24.
//

import SwiftUI



struct PopoverView: View {
    
    @State var dnsItems: [DNSItem] = []
    @State var activeDNS: DNSItem?
    
    var body: some View {
        VStack(spacing: 8) {
            ForEach(dnsItems, id: \.self) { dnsItem in
                DNSItemView(item: dnsItem, isConnected: activeDNS?.name == dnsItem.name)
                    .onTapGesture {
                        try? NetworkManager.shared.connect(to: dnsItem)
                        activeDNS = dnsItem
                    }
            }
            Rectangle()
                .frame(maxWidth: .infinity, minHeight: 1, maxHeight: 1)
                .padding(.horizontal, 6)
            DNSItemView(item: DNSServer.shared.off, isConnected: false)
                .onTapGesture {
                    NetworkManager.shared.disconnect()
                    activeDNS = nil
                }
        }
        .padding(.vertical, 12)
        .onAppear(perform: {
            dnsItems = DNSServer.shared.getDnsItems()
            activeDNS = NetworkManager.shared.getActiveDNS()
        })
        .frame(width: 160)
        .onReceive(NotificationCenter.default.publisher(for: NSWindow.didBecomeKeyNotification)) { window in
            print("something received")
            if let nswindow = window.object as? NSWindow {
                print("making active...")
                print(nswindow.title)
                nswindow.makeKeyAndOrderFront(self)
            }
        }  // 👈 Update the storage on change

    }
}

struct HoverViewModifier : ViewModifier {
    @State private var hovered = false
    func body(content: Content) -> some View {
        content
            .background(hovered ?  Color(white: 0.1, opacity: 0.9) : .clear)
            .onHover { isHovered in
                self.hovered = isHovered
            }
    }
}

#Preview {
    PopoverView(dnsItems: [
        DNSServer.shared.electro,
        DNSServer.shared.shecan,
        DNSServer.shared.gozar,
    ])
}

struct NetworkDeviceView: View {
    
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

struct DNSItemView: View {
    var item: DNSItem
    var isConnected: Bool

    var body: some View {
        HStack {
            (item.name == "Disconnect"
             ? Image(systemName: "xmark.octagon")
                .resizable(resizingMode: .stretch)
             : Image(item.name.lowercased())
                .resizable(resizingMode: .stretch)
            )
            .frame(width: 24, height: 24)
            .clipShape(Circle())
            .padding(.leading, 12)
            .padding(.vertical, 4)
            Text(item.name)
                .frame(maxWidth: .infinity, alignment: .leading)
                .if(item.name == "Disconnect", transform: { view in
                    view.foregroundStyle(.red)
                })
            Spacer()
            if isConnected {
                Image(systemName: "dot.square")
                    .padding(.trailing, 12)
                    .foregroundStyle(.green)
            }
        }
        .modifier(HoverViewModifier())
        .frame(height: 24)
    }
}

extension View {
    /// Applies the given transform if the given condition evaluates to `true`.
    /// - Parameters:
    ///   - condition: The condition to evaluate.
    ///   - transform: The transform to apply to the source `View`.
    /// - Returns: Either the original `View` or the modified `View` if the condition is `true`.
    @ViewBuilder func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}

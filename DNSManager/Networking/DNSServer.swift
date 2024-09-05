//
//  VPN.swift
//  VPNState
//
//  Created by Hadi Sharghi on 11/12/22.
//

import Foundation
#if(canImport(RegexBuilder))
import RegexBuilder
import AppKit
#endif



struct DNSServer {
    
    static var shared = DNSServer()
    
    func getDnsItems() -> [DNSItem] {
        var dnsItems = [DNSItem]()
        let mirroredItems = Mirror(reflecting: DNSServer.shared)
        for (_, mirroredItem) in mirroredItems.children.enumerated() {
            guard let item = mirroredItem.value as? DNSItem else { continue }
            dnsItems.append(item)
        }
        dnsItems.removeAll(where: { $0.name == "Disconnect" })
        return dnsItems
    }
    

    var off = DNSItem(dns1: "", dns2: "", name: "Disconnect")
    
    var shecan = DNSItem(dns1: "178.22.122.100", dns2: "185.51.200.2", name: "Shecan")
    
    var asia = DNSItem(dns1: "255.255.255.0", dns2: "192.168.80.2", name: "Asia")
    
    var w403 = DNSItem(dns1: "10.202.10.202", dns2: "10.202.10.102", name: "403")
    
    var gozar = DNSItem(dns1: "185.55.226.26", dns2: "185.55.225.25", name: "Gozar")
    
    var electro = DNSItem(dns1: "78.157.42.100", dns2: "78.157.42.101", name: "Electro")
    
    var shelter = DNSItem(dns1: "91.92.255.160", dns2: "91.92.255.242", name: "Shelter")
    
    var yandex = DNSItem(dns1: "77.88.8.8", dns2: "77.88.8.8", name: "Yandex")
    
    var verisign = DNSItem(dns1: "64.6.64.6", dns2: "64.6.65.6", name: "Verisign")

    func findItem(with dnsAddresses: String) -> DNSItem {
        let dns = dnsAddresses.components(separatedBy: "\n")
        if dns.count != 2 {
            return off
        }
        guard let dns1 = dns.first,
              let dns2 = dns.last else {
                  return off
              }
        for dnsItem in DNSServer.shared.getDnsItems() {
            if dnsItem.dns1 == dns1,
               dnsItem.dns2 == dns2 {
                return dnsItem
            }
        }
        return off
    }
}


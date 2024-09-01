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
    
    static func getDnsItems() -> [DNSItem] {
        var dnsItems = [DNSItem]()
        let mirroredItems = Mirror(reflecting: DNSServer.shared)
        for (_, mirroredItem) in mirroredItems.children.enumerated() {
            guard let item = mirroredItem.value as? DNSItem else { continue }
            dnsItems.append(item)
        }
        return dnsItems
    }
    

    var off = DNSItem(dns1: "", dns2: "", name: "Disconnect")
    
    var shecan = DNSItem(dns1: "178.22.122.100", dns2: "185.51.200.2", name: "Shecan")
    
    var asia = DNSItem(dns1: "255.255.255.0", dns2: "192.168.80.2", name: "Asia")
    
    var w402 = DNSItem(dns1: "10.202.10.202", dns2: "10.202.10.102", name: "403")
    
    var gozar = DNSItem(dns1: "10.202.10.202", dns2: "10.202.10.102", name: "Gozar")
    
    var electro = DNSItem(dns1: "10.202.10.202", dns2: "10.202.10.102", name: "Electro")
    
    var shelter = DNSItem(dns1: "10.202.10.202", dns2: "10.202.10.102", name: "Shelter")
    
    var yandex = DNSItem(dns1: "10.202.10.202", dns2: "10.202.10.102", name: "Yandex")
    
    var verisign = DNSItem(dns1: "10.202.10.202", dns2: "10.202.10.102", name: "Verisign")
    
    func findItem(with dnsAddresses: String) -> DNSItem {
        let dns = dnsAddresses.components(separatedBy: "\n")
        if dns.count != 2 {
            return off
        }
        guard let dns1 = dns.first,
              let dns2 = dns.last else {
                  return off
              }
        for dnsItem in DNSServer.getDnsItems() {
            if dnsItem.dns1 == dns1,
               dnsItem.dns2 == dns2 {
                return dnsItem
            }
        }
        return off
    }
}


//
//  DNSManager.swift
//  DNSManager
//
//  Created by Hadi Sharghi on 9/1/24.
//

import Foundation
import RegexBuilder


class NetworkManager {
    
    static let storageKey = "SelectedDevices"
    static let shared = NetworkManager()
    
    private let bash: Bash
    
    private init() {
        bash = Bash()
        Bash.debugEnabled = true
    }
    
    
    var status: DNSItem {
        getVPNStatus()
    }
    
    func getDevices() throws -> [NetworkDevice] {
        
        let selectedDevices: [String] = (UserDefaults.standard.array(forKey: NetworkManager.storageKey) as? [String]) ?? []

        guard let output = try? bash.run("networksetup", arguments: ["-listnetworkserviceorder"]) else {
            throw NetworkError(message: "Can't get device name")
        }
        

        let lines = output.components(separatedBy: .newlines)
        var enDevices = [NetworkDevice]()

        for i in 0..<lines.count - 1 {
            let currentLine = lines[i]
            let nextLine = lines[i + 1]
            
            if let nameMatch = currentLine.range(of: "^\\((\\d+)\\) (.+)$", options: .regularExpression),
               let deviceMatch = nextLine.range(of: "Device: (en\\d+)", options: .regularExpression) {
                let nameStartIndex = currentLine.index(nameMatch.lowerBound, offsetBy: 4)
                let name = String(currentLine[nameStartIndex...]).trimmingCharacters(in: .whitespaces)
                let device = String(nextLine[deviceMatch].dropFirst(8))
                let isSelected = selectedDevices.contains(device)
                enDevices.append(.init(name: name, device: device, isSelected: isSelected))
            }
        }
        
        return enDevices

    }
    
    
    func getDevice() throws -> String? {
        
        guard let info = try? bash.run("networksetup", arguments: ["-listnetworkserviceorder"]) else {
            throw NetworkError(message: "Can't get device name")
        }
        
        if #available(macOS 13, *) {
            let search = Regex {
                "Hardware Port: Wi-Fi, Device: "
                Capture {
                    OneOrMore(.word)
                }
            }
            
            guard let result = try? search.firstMatch(in: info) else {
                throw NetworkError(message: "No Wi-Fi device")
            }
            
            return String(result.1)
        } else {
            let range = NSRange(location: 0, length: info.utf16.count)
            let regex = try! NSRegularExpression(pattern: "\\w+.*Wi-Fi, Device: \\s*(\\w{3})")
            let result = regex.matches(in: info, range: range)
            if result.count == 0 {
                throw NetworkError(message: "No Wi-Fi device")
            }
            guard let rr = Range(result[0].range(at: 1), in: info) else {
                throw NetworkError(message: "Can't get Wi-Fi device name")
            }
            
            return String(info[rr])
        }
        
        
    }
    
    func getVPNStatus() -> DNSItem {
        if let dnsIps = try? bash.run("networksetup", arguments: ["-getdnsservers", "Wi-Fi"]) {
            let dnsItem = DNSServer.shared.findItem(with: dnsIps)
            return dnsItem
        }
        return DNSServer.shared.off
    }
    
    func connect(to dns: DNSItem) throws {
//        let device = (NSApplication.shared.delegate as? AppDelegate)?.device ?? "en0"
//        guard let _ = try? bash.run("ipconfig", arguments: ["getifaddr", device ]) else {
//            throw NetworkError(message: "Can't get system IP")
//        }
        _ = try? bash.run("networksetup", arguments: ["-setdhcp", "Wi-Fi"])
        _ = try? bash.run("networksetup", arguments: ["-setdnsservers", "Wi-Fi", dns.dns1, dns.dns2])
    }
    
    func disconnect() {
        _ = try? bash.run("networksetup", arguments: ["-setdhcp", "Wi-Fi"])
        _ = try? bash.run("networksetup", arguments: ["-setdnsservers", "Wi-Fi", "Empty"])
    }
    
}

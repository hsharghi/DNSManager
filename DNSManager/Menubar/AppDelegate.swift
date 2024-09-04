//
//  AppDelegate.swift
//  DNSManager
//
//  Created by Hadi Sharghi on 8/31/24.
//

import SwiftUI

class AppDelegate: NSObject, NSApplicationDelegate {
    
    static var popover = NSPopover()
    var statusBar: StatusBarController?
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        Self.popover.contentViewController = NSHostingController(rootView: PopoverView()
            .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext))
        
        Self.popover.behavior = .transient
        statusBar = StatusBarController(Self.popover)
        
        
        if( NSApp.windows.count > 0 ) {
            let window : NSWindow = NSApp.windows[0]
            let title = window.title
            print(title)
            window.close()
        }
    }
    
}

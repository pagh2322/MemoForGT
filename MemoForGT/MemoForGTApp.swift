//
//  MemoForGTApp.swift
//  MemoForGT
//
//  Created by peo on 2022/04/30.
//

import SwiftUI

@main
struct MemoForGTApp: App {
    @StateObject private var allData = AllData()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(allData)
        }
    }
}

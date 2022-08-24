//
//  Cubic_CalculatorApp.swift
//  Cubic Calculator
//
//  Created by Paweł Sobaszek on 24/08/2022.
//

import SwiftUI

@main
struct Cubic_CalculatorApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}

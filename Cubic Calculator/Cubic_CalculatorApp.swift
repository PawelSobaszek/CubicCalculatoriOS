//
//  Cubic_CalculatorApp.swift
//  Cubic Calculator
//
//  Created by Paweł Sobaszek on 24/08/2022.
//

import SwiftUI

@main
struct Cubic_CalculatorApp: App {    
    var body: some Scene {
        WindowGroup {
            let calculatorViewModel = CalculatorViewModel()
            CalculatorView(viewModel: calculatorViewModel)
        }
    }
}

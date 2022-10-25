//
//  TextCubicMeters.swift
//  Cubic Calculator
//
//  Created by Paweł Sobaszek on 30/08/2022.
//

import SwiftUI

struct TextCubicMeters: View {
    private let value: String
    
    init(value: String) {
        self.value = value
    }
    
    var body: some View {
        Text("\(value)m")
            .font(.title) + Text("3").font(Font.footnote).baselineOffset(8.0)
    }
}

struct TextCubicMeters_Previews: PreviewProvider {
    static var previews: some View {
        TextCubicMeters(value: "1.234")
    }
}

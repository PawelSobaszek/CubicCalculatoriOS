//
//  BasicTextField.swift
//  Cubic Calculator
//
//  Created by Paweł Sobaszek on 24/08/2022.
//

import SwiftUI

struct BasicTextField: View {
    private let placeholder: String
    private var hint: String?
    
    @Binding private var value: String
    
    init(placeholder: String, hint: String? = nil, value: Binding<String>) {
        self.placeholder = placeholder
        self.hint = hint
        self._value = value
    }

    var body: some View {
        VStack {
            TextField(placeholder, text: $value)
                .textFieldStyle(.roundedBorder)
                .padding()
            
            if let hint {
                Text(hint)
                    .font(.footnote)
            }
        }
    }
}

struct BasicTextField_Previews: PreviewProvider {
    static var previews: some View {
        BasicTextField(placeholder: "Długość", value: .constant(""))
            .previewLayout(.sizeThatFits)
    }
}

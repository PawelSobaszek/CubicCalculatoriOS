//
//  BasicTextField.swift
//  Cubic Calculator
//
//  Created by Paweł Sobaszek on 24/08/2022.
//

import SwiftUI

struct BasicTextField: View {
    let placeholder: String
    var hint: String? = nil
    
    @Binding var value: String

    var body: some View {
        VStack {
            TextField(placeholder, text: $value)
                .textFieldStyle(.roundedBorder)
                .padding()
            
            if let hint = hint {
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

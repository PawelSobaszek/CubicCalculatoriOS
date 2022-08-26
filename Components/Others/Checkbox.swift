//
//  Checkbox.swift
//  Cubic Calculator
//
//  Created by Paweł Sobaszek on 24/08/2022.
//

import SwiftUI

struct Checkbox: View {
    let title: String
    @State var checkboxSelected: Bool = false
    
    var body: some View {
        HStack {
            Button(action: {
                checkboxSelected.toggle()
            }, label: {
                HStack {
                    Image(uiImage: checkboxSelected ? UIImage(systemName: "checkmark.square")! : UIImage(systemName: "square")!)
                        .aspectRatio(1, contentMode: .fit)

                }
            })
            
            Text(title)
                .font(.caption)
                .foregroundColor(.black)
        }
    }
}

struct SingleSelectionCheckbox_Previews: PreviewProvider {
    static var previews: some View {
        Checkbox(title: "Zapamiętaj")
    }
}

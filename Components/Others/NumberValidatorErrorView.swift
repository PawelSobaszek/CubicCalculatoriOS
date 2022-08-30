//
//  NumberValidatorErrorView.swift
//  Cubic Calculator
//
//  Created by Paweł Sobaszek on 30/08/2022.
//

import SwiftUI

struct NumberValidatorErrorView: View {
    var numberValidator: NumberValidatorState = .empty

    var body: some View {
        switch numberValidator {
        case .notNumber:
            Text(Strings.numberValidatorOnlyNumbers())
                .foregroundColor(.red)
        case .zero:
            Text(Strings.numberValidatorNotEqualZero())
                .foregroundColor(.red)
        case .valid, .empty:
            EmptyView()
        }
    }
}

struct NumberValidatorErrorView_Previews: PreviewProvider {
    static var previews: some View {
        NumberValidatorErrorView()
    }
}

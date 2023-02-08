//
//  NumberValidatorErrorView.swift
//  Cubic Calculator
//
//  Created by Paweł Sobaszek on 30/08/2022.
//

import SwiftUI

struct NumberValidatorErrorView: View {
    private var numberValidator: NumberValidatorState
    
    init(numberValidator: NumberValidatorState = .empty) {
        self.numberValidator = numberValidator
    }
    
    var body: some View {
        switch numberValidator {
        case .notNumber:
            Text(Resources.strings.numberValidatorOnlyNumbers())
                .foregroundColor(.red)
        case .zero:
            Text(Resources.strings.numberValidatorNotEqualZero())
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

//
//  String.swift
//  Cubic Calculator
//
//  Created by Paweł Sobaszek on 25/10/2022.
//

import Foundation

extension String {
    func numberValidator() -> NumberValidatorState {
        if let value = Int(self) {
            return value == 0 ? .zero : .valid
        } else {
            return self.isEmpty ? .empty : .notNumber
        }
    }
    
    mutating func setEmptyString() {
        self = ""
    }
}

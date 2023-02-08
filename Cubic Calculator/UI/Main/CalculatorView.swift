//
//  ContentView.swift
//  Cubic Calculator
//
//  Created by Paweł Sobaszek on 24/08/2022.
//

import SwiftUI

struct CalculatorView<ViewModel: CalculatorViewModelProtocol>: View {
    @ObservedObject var viewModel: ViewModel
    
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack(spacing: 0) {
            BasicTextField(placeholder: Resources.strings.dimensionDiameter(),
                           hint: Resources.strings.unitCentimeters(),
                           value: viewModel.diameterBinding)
            .padding()
            
            NumberValidatorErrorView(numberValidator: viewModel.diameterValidator)
            
            BasicTextField(placeholder: Resources.strings.dimensionLength(),
                           hint: Resources.strings.unitCentimeters(),
                           value: viewModel.lengthBinding)
            .padding()
            NumberValidatorErrorView(numberValidator: viewModel.lengthValidator)
            
            HStack {
                Toggle("", isOn: viewModel.remeberLengthBinding)
                    .labelsHidden()
                Text(Resources.strings.buttonRemember())
                    .font(.callout)
            } // HSTACK
            .padding(.vertical)
            
            HStack {
                Spacer()
                
                Button(Resources.strings.buttonClear(), action: viewModel.removeAllButtonTouchIn)
                
                Spacer()
                
                Button(Resources.strings.buttonAdd(), action: viewModel.addButtonTouchIn)
                    .disabled(viewModel.addButtonDisabled)
                
                Spacer()
            } // HSTACK
            .buttonStyle(.bordered)
            .padding()
            
            TextCubicMeters(value: viewModel.sum)
            
            Text(Resources.strings.sum())
                .font(.footnote)
            
            SummationsListView(
                allSummations: viewModel.allSummations,
                onDeleteAction: viewModel.deleteItem(offsets:)
            )
            .padding(.top)
            .frame(maxHeight: .infinity)
        } // VSTACK
    }
}

struct ContentView_Previews: PreviewProvider {
    static let calculatorViewModel = CalculatorViewModel()
    
    static var previews: some View {
        CalculatorView(viewModel: calculatorViewModel)
    }
}

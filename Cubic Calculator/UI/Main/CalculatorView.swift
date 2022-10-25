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
            BasicTextField(placeholder: Strings.dimensionDiameter(), hint: Strings.unitCentimeters(), value: viewModel.diameterBinding)
                .padding()
            NumberValidatorErrorView(numberValidator: viewModel.diameterValidator)
            
            BasicTextField(placeholder: Strings.dimensionLength(), hint: Strings.unitCentimeters(), value: viewModel.lengthBinding)
                .padding()
            NumberValidatorErrorView(numberValidator: viewModel.lengthValidator)

            HStack {
                Toggle("", isOn: viewModel.remeberLengthBinding)
                    .labelsHidden()
                Text(Strings.buttonRemember())
                    .font(.callout)
            } // HSTACK
            .padding(.vertical)
            
            HStack {
                Spacer()
                
                Button(Strings.buttonClear(), action: viewModel.removeAllButtonTouchIn)
                
                Spacer()
                
                Button(Strings.buttonAdd(), action: viewModel.addButtonTouchIn)
                    .disabled(viewModel.addButtonDisabled)
                
                Spacer()
            } // HSTACK
            .buttonStyle(.bordered)
            .padding()
            
            TextCubicMeters(value: viewModel.sum)
            
            Text(Strings.sum())
                .font(.footnote)
            
            SummationsListView(allSummations: viewModel.allSummations, onDeleteAction: viewModel.deleteItem(offsets:))
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

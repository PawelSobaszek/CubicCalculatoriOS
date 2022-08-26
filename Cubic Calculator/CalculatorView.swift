//
//  ContentView.swift
//  Cubic Calculator
//
//  Created by Paweł Sobaszek on 24/08/2022.
//

import SwiftUI

struct CalculatorView<ViewModel: CalculatorViewModelProtocol>: View {
    @ObservedObject var viewModel: ViewModel

    var sum: String {
        var digits = 3
        var sum: Double = 0
        viewModel.allSummations.forEach { summation in
            sum += summation.sum
        }
        if sum == 0 {
            digits = 0
        } else {
            digits = 3
        }
        return String(format: "%.\(digits)f", sum)
    }
    
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                BasicTextField(placeholder: "Diameter", hint: "Centimeters", value: viewModel.diameterBinding)
                    .padding()
                
                if let diameterIsValid = viewModel.diameterIsValid {
                    if !diameterIsValid {
                        Text("Zły Diameter")
                            .foregroundColor(.red)
                    }
                }
                
                BasicTextField(placeholder: "Length", hint: "Centimeters", value: viewModel.lengthBinding)
                    .padding()
                
                if let lengthIsValid = viewModel.lengthIsValid {
                    if !lengthIsValid {
                        Text("Zły Length")
                            .foregroundColor(.red)
                    }
                }
                
                HStack {
                    Toggle("", isOn: viewModel.remeberLengthBinding)
                        .labelsHidden()
                    Text("Zapamiętaj")
                        .font(.callout)
                }
                .padding(.vertical)
                
                HStack {
                    Spacer()
                    
                    Button("Wyczyść", action: viewModel.removeAllButtonTouchIn)
                    
                    Spacer()
                    
                    Button("Dodaj", action: viewModel.addButtonTouchIn)
                        .disabled(viewModel.addButtonDisabled)
                    
                    Spacer()
                } // HSTACK
                .buttonStyle(.bordered)
                .padding()
                
                Text("\(sum)m3")
                    .font(.title)
                
                Text("Wynik")
                    .font(.footnote)
                
                List {
                    HStack {
                        Text("ID")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                        Text("Średnica")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                        Text("Długość")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                        Text("Wynik")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                    }
                    
                    ForEach(viewModel.allSummations) { summation in
                        HStack {
                            Text("\(summation.id)")
                                .frame(maxWidth: .infinity)
                            Text("\(summation.diameter)")
                                .frame(maxWidth: .infinity)
                            Text("\(summation.length)")
                                .frame(maxWidth: .infinity)
                            Text(String(format: "%.3f", summation.sum))
                                .frame(maxWidth: .infinity)
                        }
                    }.onDelete(perform: viewModel.deleteItem(offsets:))
                }
                .padding(.top)
                .listStyle(.inset)
                .frame(maxHeight: .infinity)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static let calculatorViewModel = CalculatorViewModel()
    
    static var previews: some View {
        CalculatorView(viewModel: calculatorViewModel)
    }
}

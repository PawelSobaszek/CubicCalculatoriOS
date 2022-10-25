//
//  CalculatorViewModel.swift
//  Cubic Calculator
//
//  Created by Paweł Sobaszek on 25/08/2022.
//

import Foundation
import Combine
import SwiftUI

protocol CalculatorViewModelProtocol: ObservableObject {
    var allSummations: [SummationEntity] { get }
    var allSummationsPublisher: Published<[SummationEntity]>.Publisher { get }
    
    var sum: String { get }
    var sumPublisher: Published<String>.Publisher { get }
    
    var diameter: String { get set }
    var diameterBinding: Binding<String> { get }
    
    var length: String { get set }
    var lengthBinding: Binding<String> { get }
    
    var remeberLength: Bool { get set }
    var remeberLengthBinding: Binding<Bool> { get }
    
    var diameterValidator: NumberValidatorState { get }
    var diameterValidatorPublisher: Published<NumberValidatorState>.Publisher { get }
    
    var lengthValidator: NumberValidatorState { get }
    var lengthValidatorPublisher: Published<NumberValidatorState>.Publisher { get }
    
    var addButtonDisabled: Bool { get }
    var addButtonDisabledPublisher: Published<Bool>.Publisher { get }
 
    func removeAllButtonTouchIn()
    func addButtonTouchIn()
    func deleteItem(offsets: IndexSet)
}

final class CalculatorViewModel: CalculatorViewModelProtocol {
    @Published var allSummations: [SummationEntity] = []
    var allSummationsPublisher: Published<[SummationEntity]>.Publisher { $allSummations }
    
    @Published var sum: String = ""
    var sumPublisher: Published<String>.Publisher { $sum }
    
    @Published var diameter: String = ""
    var diameterBinding: Binding<String> {
        Binding(get: { self.diameter }, set: { self.diameter = $0 })
    }
    
    @Published var length: String = ""
    var lengthBinding: Binding<String> {
        Binding(get: { self.length }, set: { self.length = $0 })
    }
 
    @Published var remeberLength: Bool = false
    var remeberLengthBinding: Binding<Bool> {
        Binding(get: { self.remeberLength }, set: { self.remeberLength = $0 })
    }
    
    @Published var diameterValidator: NumberValidatorState = .empty
    var diameterValidatorPublisher: Published<NumberValidatorState>.Publisher { $diameterValidator }
    
    @Published var lengthValidator: NumberValidatorState = .empty
    var lengthValidatorPublisher: Published<NumberValidatorState>.Publisher { $lengthValidator }
    
    @Published var addButtonDisabled: Bool = true
    var addButtonDisabledPublisher: Published<Bool>.Publisher { $addButtonDisabled }
    
    private let summationDataService: SummationDataServiceProtocol
    private var cancellables = Set<AnyCancellable>()

    init(summationDataService: SummationDataServiceProtocol = SummationDataService()) {
        self.summationDataService = summationDataService
        addSubscribers()
    }
}

extension CalculatorViewModel {
    func removeAllButtonTouchIn() {
        summationDataService.removeAll()
    }
    
    func addButtonTouchIn() {
        guard let diameterValue = Int(diameter), let lengthValue = Int(length) else { return }
        summationDataService.add(diameter: diameterValue, length: lengthValue)
        diameter.setEmptyString()
        if !remeberLength { length.setEmptyString() }
    }
    
    func deleteItem(offsets: IndexSet) {
        offsets.map { allSummations[$0] }.forEach { entity in
            summationDataService.remove(id: Int(entity.id))
        }
    }
}

extension CalculatorViewModel {
    private func calculateSum(summations: [SummationEntity]) {
        let sumResult = summations.sum(\.sum)
        let digits = sumResult.isEqual(to: 0) ? 0 : 3
        sum = String(format: "%.\(digits)f", sumResult)
    }
    
    private func validateAddButtonDisabled() {
        addButtonDisabled = diameterValidator == .valid && lengthValidator == .valid ? false : true
    }
    
    private func addSubscribers() {
        $allSummations
            .sink { [weak self] summations in
                guard let self else { return }
                self.calculateSum(summations: summations)
            }
            .store(in: &cancellables)
        
        $diameter
            .sink { [weak self] value in
                guard let self else { return }
                self.diameterValidator = value.numberValidator()
                self.validateAddButtonDisabled()
            }
            .store(in: &cancellables)
        
        $length
            .sink { [weak self] value in
                guard let self else { return }
                self.lengthValidator = value.numberValidator()
                self.validateAddButtonDisabled()
            }
            .store(in: &cancellables)
        
        summationDataService.savedEntitiesPublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] value in
                guard let self = self else { return }
                self.allSummations = value
            }
            .store(in: &cancellables)
    }
}

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
    
    var diameter: String { get set }
    var diameterBinding: Binding<String> { get }
    
    var length: String { get set }
    var lengthBinding: Binding<String> { get }
    
    var remeberLength: Bool { get set }
    var remeberLengthBinding: Binding<Bool> { get }
    
    var diameterIsValid: Bool? { get }
    var diameterIsValidPublisher: Published<Bool?>.Publisher { get }
    
    var lengthIsValid: Bool? { get }
    var lengthIsValidPublisher: Published<Bool?>.Publisher { get }
    
    var addButtonDisabled: Bool { get }
    var addButtonDisabledPublisher: Published<Bool>.Publisher { get }
 
    func removeAllButtonTouchIn()
    func addButtonTouchIn()
    func deleteItem(offsets: IndexSet)
}

final class CalculatorViewModel: CalculatorViewModelProtocol {
    @Published var allSummations: [SummationEntity] = []
    var allSummationsPublisher: Published<[SummationEntity]>.Publisher { $allSummations }
    
    @Published var diameter: String = "" {
        didSet {
            validateAddButtonDisabled()
        }
    }
    var diameterBinding: Binding<String> {
        Binding(get: { self.diameter }, set: { self.diameter = $0 })
    }
    
    @Published var length: String = "" {
        didSet {
            validateAddButtonDisabled()
        }
    }
    var lengthBinding: Binding<String> {
        Binding(get: { self.length }, set: { self.length = $0 })
    }
 
    @Published var remeberLength: Bool = false
    var remeberLengthBinding: Binding<Bool> {
        Binding(get: { self.remeberLength }, set: { self.remeberLength = $0 })
    }
    
    @Published var diameterIsValid: Bool? = nil
    var diameterIsValidPublisher: Published<Bool?>.Publisher { $diameterIsValid }
    
    @Published var lengthIsValid: Bool? = nil
    var lengthIsValidPublisher: Published<Bool?>.Publisher { $lengthIsValid }
    
    @Published var addButtonDisabled: Bool = true
    var addButtonDisabledPublisher: Published<Bool>.Publisher { $addButtonDisabled }
    
    private let summationDataService: SummationDataServiceProtocol
    private var cancellables = Set<AnyCancellable>()

    init(summationDataService: SummationDataServiceProtocol = SummationDataService()) {
        self.summationDataService = summationDataService
        addSubscribers()
    }
    
    func removeAllButtonTouchIn() {
        summationDataService.removeAll()
    }
    
    func addButtonTouchIn() {
        summationDataService.add(diameter: Int(diameter) ?? 1, length: Int(length) ?? 1)
        diameter = ""
        if !remeberLength {
            length = ""
        }
    }
    
    func deleteItem(offsets: IndexSet) {
        offsets.map { allSummations[$0] }.forEach { entity in
            summationDataService.remove(id: Int(entity.id))
        }
    }
    
    private func validateAddButtonDisabled() {
        if Int(diameter) != nil && Int(length) != nil {
            addButtonDisabled = false
        } else {
            addButtonDisabled = true
        }
    }
    
    private func addSubscribers() {
        $diameter
            .sink { [weak self] value in
                guard let self = self else { return }
                if let _ = Int(value) {
                    self.diameterIsValid = true
                } else {
                    if value.isEmpty {
                        self.diameterIsValid = nil
                    } else {
                        self.diameterIsValid = false
                    }
                }
            }
            .store(in: &cancellables)
        
        $length
            .sink { [weak self] value in
                guard let self = self else { return }
                if let _ = Int(value) {
                    self.lengthIsValid = true
                } else {
                    if value.isEmpty {
                        self.lengthIsValid = nil
                    } else {
                        self.lengthIsValid = false
                    }
                }
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

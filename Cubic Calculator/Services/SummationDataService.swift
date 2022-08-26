//
//  SummationDataService.swift
//  Cubic Calculator
//
//  Created by Paweł Sobaszek on 25/08/2022.
//

import Foundation
import CoreData

protocol SummationDataServiceProtocol {
    var savedEntities: [SummationEntity] { get }
    var savedEntitiesPublished: Published<[SummationEntity]> { get }
    var savedEntitiesPublisher: Published<[SummationEntity]>.Publisher { get }
    
    func add(diameter: Int, length: Int)
    func remove(id: Int)
    func removeAll()
}

final class SummationDataService: SummationDataServiceProtocol {
    private let container: NSPersistentContainer
    private let containerName: String = "Summation"
    private let entityName: String = "SummationEntity"
    
    @Published var savedEntities: [SummationEntity] = []
    var savedEntitiesPublished: Published<[SummationEntity]> { _savedEntities }
    var savedEntitiesPublisher: Published<[SummationEntity]>.Publisher { $savedEntities }

    init() {
        container = NSPersistentContainer(name: containerName)
        container.loadPersistentStores { (_, error) in
            if let error = error {
                print("Error loading Core Data! \(error)")
            }
            self.getSummations()
        }
    }
        
    func add(diameter: Int, length: Int) {
        let entity = SummationEntity(context: container.viewContext)
        entity.id = Int32(savedEntities.count + 1)
        entity.diameter = Int32(diameter)
        entity.length = Int32(length)
        entity.sum = getSum(diameter: diameter, length: length)
        applyChanges()
    }
    
    func remove(id: Int) {
        if let entity = savedEntities.first(where: { $0.id == id }) {
            delete(entity: entity)
        }
        updateIDs()
    }
    
    func removeAll() {
        savedEntities.forEach { entity in
            delete(entity: entity)
        }
    }
    
    private func updateIDs() {
        var id = 1
        savedEntities.forEach { entity in
            entity.id = Int32(id)
            id += 1
        }
        applyChanges()
    }
    
    private func getSum(diameter: Int, length: Int) -> Double {
        return ((Double(diameter) / 200) * (Double(diameter) / 200) * (Double(length) / 100) * Double.pi)
    }
        
    private func getSummations() {
        let request = NSFetchRequest<SummationEntity>(entityName: entityName)
        do {
            savedEntities = try container.viewContext.fetch(request)
        } catch let error {
            print("Error fetching Portfolio Entities. \(error)")
        }
    }
    
    private func delete(entity: SummationEntity) {
        container.viewContext.delete(entity)
        applyChanges()
    }
    
    private func save() {
        do {
            try container.viewContext.save()
        } catch let error {
            print("Error saving to Core Data. \(error)")
        }
    }
    
    private func applyChanges() {
        save()
        getSummations()
    }
}

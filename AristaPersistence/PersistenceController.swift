//
//  Persistence.swift
//  Arista
//
//  Created by Vincent Saluzzo on 08/12/2023.
//

import CoreData

// MARK: - PersistenceController Definition

public struct PersistenceController {
    
    // MARK: - Shared Instances
    
    public static let shared = PersistenceController()
    
    public static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()
    
    // MARK: - Core Data Stack
    
    public let container: NSPersistentContainer
    
    // MARK: - Initializer
    
    public init(inMemory: Bool = false) {
            // Charge le modèle Core Data depuis le framework
            guard let modelURL = Bundle(identifier: "com.openclassrooms.AristaPersistence")?.url(forResource: "Arista", withExtension: "momd"),
                  let model = NSManagedObjectModel(contentsOf: modelURL) else {
                fatalError("Impossible de charger le modèle de données depuis le framework.")
            }
            
            // Initialise le container avec le modèle chargé manuellement
            container = NSPersistentContainer(name: "Arista", managedObjectModel: model)
            
            if inMemory {
                container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
            }
            
            container.loadPersistentStores { storeDescription, error in
                if let error = error as NSError? {
                    print("Unresolved error \(error), \(error.userInfo)")
                }
            }
            
            container.viewContext.automaticallyMergesChangesFromParent = true
            
            // Applique les données par défaut si `inMemory` est `false`
            if !inMemory {
                applyDefaultData()
            }
        }
    
    // MARK: - Private Helper Methods
    
    /// Applies the default data to the persistent store.
    private func applyDefaultData() {
        do {
            try DefaultData(context: container.viewContext).apply()
            print("Données par défaut appliquées avec succès.")
        } catch {
            print("Erreur lors de l'application des données par défaut : \(error.localizedDescription)")
            if let nsError = error as NSError? {
                print("NSCocoaErrorDomain: \(nsError.domain)")
                print("Code d'erreur: \(nsError.code)")
                print("Informations utilisateur: \(nsError.userInfo)")
            }
        }
    }
}

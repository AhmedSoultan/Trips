import Foundation
import SwiftData

@Observable
final class TripsViewModel {
  var modelContext: ModelContext
  var trips: [Trip] = []
  
  init(modelContext: ModelContext) {
    self.modelContext = modelContext
    //modelContext.undoManager = UndoManager()
    fetchTrips()
  }
  
  private func fetchTrips() {
    let predicate = #Predicate<Trip> { trip in
      trip.name?.count ?? 0 > 5
    }
    var fetchDiscriptor = FetchDescriptor(
      predicate: predicate,
      sortBy: [SortDescriptor(\.date, order: .reverse)]
    )
    fetchDiscriptor.fetchLimit = 10
    fetchDiscriptor.propertiesToFetch = [\.name, \.date]
    fetchDiscriptor.relationshipKeyPathsForPrefetching = [\.livingAccommodation]
    
    try? modelContext.enumerate(fetchDiscriptor) { model in
      
    }
    
    do {
      trips = try modelContext.fetch(fetchDiscriptor)
    } catch {
      print(error)
    }
  }
}

@ModelActor
actor MyBackgroundModelContext {
  func update(_ persistentModelId: PersistentIdentifier) {
    guard let trip = modelContext.model(for: persistentModelId) as? Trip else { return }
    trip.name = "Updated name"
    do {
      try modelContext.save()
    } catch {
      print("SwiftData save failed: \(error)")
    }
  }
}

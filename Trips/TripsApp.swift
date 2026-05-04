//
//  TripsApp.swift
//  Trips
//
//  Created by Ahmed Sultan on 22/02/2026.
//

import SwiftUI
import SwiftData

@main
struct TripsApp: App {
  var body: some Scene {
    let container = makeContainer()
    WindowGroup {
      TripsView(
        modelContainer: container,
        viewModel: TripsViewModel(modelContext: container.mainContext)
      )
    }
     .modelContainer(container)
     //.modelContext(container.mainContext)
  }
  
  func makeContainer() -> ModelContainer {
    let fullSchema = Schema([Trip.self, LivingAccommodation.self])
    let modelConfigration = ModelConfiguration(
      schema: fullSchema,
      isStoredInMemoryOnly: false,
      allowsSave: true
      )
    let modelContainer = try? ModelContainer(
        for: fullSchema,
        configurations: modelConfigration
    )
    modelContainer?.mainContext.autosaveEnabled = false
    return modelContainer!
  }
}

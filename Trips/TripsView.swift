import SwiftUI
import SwiftData

private enum ViewConstants {
  static let verticalPadding: CGFloat = 8
  static let horizontalPadding: CGFloat = 16
}

struct TripsView: View {
    
  @Environment(\.modelContext) private var context
  let modelContainer: ModelContainer
  @State private var isShowingAddAlert = false
  @State private var newTripName = ""
  @Query(sort: [SortDescriptor(\Trip.date)]) var trips: [Trip] = []
  let viewModel: TripsViewModel
  
  var body: some View {
    NavigationStack {
      List {
        ForEach(trips) { trip in
          Text(trip.name ?? "name not available")
            .listRowInsets(EdgeInsets())
            .listRowBackground(Color.white)
          //.listRowSeparator(.hidden)
        }
        .onDelete { indexSet in
          for index in indexSet {
            let tripToDelete = self.trips[index]
            let model = context.model(for: tripToDelete.persistentModelID) as? Trip
            print("model: +++++ \(model?.name ?? "")")
            
            let registeredModel: Trip? = context.registeredModel(for: tripToDelete.persistentModelID)
            print("registeredModel: +++++ \(registeredModel?.name ?? "")")
            //context.undoManager?.undo()
            //self.context.delete(tripToDelete)
            try? self.context.save()
          }
        }
        .task {
          let trip = trips[0]
          let actor = MyBackgroundModelContext(modelContainer: modelContainer)
          await actor.update(trip.persistentModelID)
        }
      }
      .padding(8)
      .listStyle(.plain)
      .navigationTitle("Trips")
      .navigationBarTitleDisplayMode(.inline)
      .toolbar {
        ToolbarItem(placement: .topBarTrailing) {
          Button {
            isShowingAddAlert = true
          } label: {
            Image(systemName: "plus")
          }
        }
      }
      .toolbarBackground(Color.white, for: .navigationBar)
      
      .alert("Add trip", isPresented: $isShowingAddAlert) {
        TextField("Enter trip name", text: $newTripName)
          .font(.system(size: 16))
          .background(.white)
        Button("Add") {
          let trip = Trip(name: newTripName, date: Date())
          context.insert(trip)
          try? context.save()
          newTripName = ""
        }
        Button("Cancel", role: .cancel) {
          newTripName = ""
        }
      }
    }
  }
}

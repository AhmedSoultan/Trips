import Foundation
import SwiftData

enum migrationPlan: SchemaMigrationPlan {
  static var schemas: [any VersionedSchema.Type] = [SchemaVersion1.self]
  
  static var stages: [MigrationStage] = []
  
}

enum SchemaVersion1: VersionedSchema {
  static var models: [any PersistentModel.Type] = [
    Trip.self, LivingAccommodation.self
  ]
  static var versionIdentifier: Schema.Version = Schema.Version(1, 1, 1)
  
  @Model
  final class Trip {
    @Attribute(.unique) var name: String?
    var date: Date?
    @Relationship(.unique, deleteRule: .cascade) var livingAccommodation: LivingAccommodation?
    
    init(name: String? = nil, date: Date? = nil, livingAccommodation: LivingAccommodation? = nil) {
      self.name = name
      self.date = date
      self.livingAccommodation = livingAccommodation
    }
  }

  @Model
  final class LivingAccommodation {
    var name: String
    @Relationship(.unique, deleteRule: .cascade, inverse: \Trip.livingAccommodation)
    var trip: Trip?
    
    init(name: String, trip: Trip? = nil) {
      self.name = name
    }
  }
}

@Model
final class Trip {
  @Attribute(.unique) var name: String?
  var date: Date?
  @Relationship(.unique, deleteRule: .cascade) var livingAccommodation: LivingAccommodation?
  
  init(name: String? = nil, date: Date? = nil, livingAccommodation: LivingAccommodation? = nil) {
    self.name = name
    self.date = date
    self.livingAccommodation = livingAccommodation
  }
}

@Model
final class LivingAccommodation {
  var name: String
  @Relationship(.unique, deleteRule: .cascade, inverse: \Trip.livingAccommodation)
  var trip: Trip?
  
  init(name: String, trip: Trip? = nil) {
    self.name = name
  }
}

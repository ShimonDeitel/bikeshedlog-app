import Foundation

struct BikeItem: Identifiable, Codable, Equatable {
    var id: UUID = UUID()
    var name: String
    var components: String
    var mileage: String
    var notes: String = ""
    var dateAdded: Date = Date()
    var isFavorite: Bool = false
}

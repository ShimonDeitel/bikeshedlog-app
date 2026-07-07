import XCTest
@testable import BikeShedLog

@MainActor
final class BikeShedLogTests: XCTestCase {
    var store: Store!

    override func setUp() {
        super.setUp()
        store = Store()
    }

    func testSeedDataLoadsBelowFreeLimit() {
        XCTAssertLessThan(store.items.count, Store.freeTierLimit)
    }

    func testAddIncreasesCount() {
        let before = store.items.count
        store.add(BikeItem(name: "Test", components: "A", mileage: "B"))
        XCTAssertEqual(store.items.count, before + 1)
    }

    func testDeleteRemovesItem() {
        let item = BikeItem(name: "ToDelete", components: "A", mileage: "B")
        store.add(item)
        store.delete(item)
        XCTAssertFalse(store.items.contains(item))
    }

    func testIsAtFreeLimitFalseInitially() {
        XCTAssertFalse(store.isAtFreeLimit)
    }

    func testIsAtFreeLimitTrueAfterFilling() {
        while store.items.count < Store.freeTierLimit {
            store.add(BikeItem(name: "Filler \(store.items.count)", components: "A", mileage: "B"))
        }
        XCTAssertTrue(store.isAtFreeLimit)
    }

    func testUpdateChangesFields() {
        var item = BikeItem(name: "Orig", components: "A", mileage: "B")
        store.add(item)
        item.name = "Changed"
        store.update(item)
        XCTAssertEqual(store.items.first(where: { $0.id == item.id })?.name, "Changed")
    }

    func testDeleteAtOffsets() {
        let before = store.items.count
        store.delete(at: IndexSet(integer: 0))
        XCTAssertEqual(store.items.count, before - 1)
    }

    func testPersistenceRoundTrip() {
        store.add(BikeItem(name: "Persisted", components: "A", mileage: "B"))
        let reloaded = Store()
        XCTAssertTrue(reloaded.items.contains(where: { $0.name == "Persisted" }))
    }
}

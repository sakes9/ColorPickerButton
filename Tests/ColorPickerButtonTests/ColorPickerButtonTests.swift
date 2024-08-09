@testable import ColorPickerButton
import SwiftUI
import ViewInspector
import XCTest

// MARK: - Inspectable

extension ColorPickerButton: Inspectable {}
extension ColorPickerButton.Color: Inspectable {}

// MARK: - Tests

final class ColorPickerButtonTests: XCTestCase {
    /// Test the button image system name
    func testButtonImageSystemName() throws {
        let colors: [ColorPickerButton.Color] = [
            .init(id: 1, color: .black)
        ]
        let sut = ColorPickerButton(colors: colors, onSelected: { _ in })
        let inspection = try sut.inspect()

        let button = try inspection.find(viewWithId: "colorButton")
        let image = try button.find(ViewType.Image.self)
        let systemName = try image.actualImage().name()

        XCTAssertEqual(systemName, "paintpalette")
    }

    /// Test the button image color
    func testInitiallySelectedColor() throws {
        let colors: [ColorPickerButton.Color] = [
            .init(id: 1, color: .red),
            .init(id: 2, color: .green),
            .init(id: 3, color: .blue)
        ]
        let sut = ColorPickerButton(colors: colors, onSelected: { _ in })
        let inspection = try sut.inspect()

        let button = try inspection.find(viewWithId: "colorButton")
        let image = try button.find(ViewType.Image.self)
        let color = try image.foregroundColor()

        XCTAssertEqual(color, Color.red)
    }

    /// Test the initially selected color when a specific color ID is provided
    func testInitiallySelectedColorWithProvidedID() throws {
        let colors: [ColorPickerButton.Color] = [
            .init(id: 1, color: .red),
            .init(id: 2, color: .green),
            .init(id: 3, color: .blue)
        ]
        let sut = ColorPickerButton(colors: colors, selectedColorId: 2, onSelected: { _ in })
        let inspection = try sut.inspect()

        let button = try inspection.find(viewWithId: "colorButton")
        let image = try button.find(ViewType.Image.self)
        let color = try image.foregroundColor()

        XCTAssertEqual(color, Color.green) // Expecting the color associated with ID 2 (green) to be selected
    }
}

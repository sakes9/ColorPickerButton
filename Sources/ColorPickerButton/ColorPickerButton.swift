// The Swift Programming Language
// https://docs.swift.org/swift-book

import SwiftUI

// MARK: - Color Picker Button

public struct ColorPickerButton: View {
    // Color struct
    public struct Color: Identifiable, Hashable {
        public let id: Int // ID
        public let color: SwiftUI.Color // Color

        /// Initializer
        /// - Parameters:
        ///   - id: ID
        ///   - color: Color
        public init(id: Int, color: SwiftUI.Color) {
            self.id = id
            self.color = color
        }
    }

    // Properties
    private let colors: [ColorPickerButton.Color] // Color list
    private let onSelected: (Int?) -> Void // Action on color selection

    // State
    @State private var isPopoverPresented: Bool = false
    @State private var selectedColorId: Int?

    /// Initializer
    /// - Parameters:
    ///   - colors: List of colors
    ///   - onSelected: Action on color selection
    public init(colors: [ColorPickerButton.Color], onSelected: @escaping (Int?) -> Void) {
        self.colors = colors
        self.onSelected = onSelected
    }

    public var body: some View {
        VStack {
            GeometryReader { geometry in
                Button(action: {
                    isPopoverPresented.toggle()
                }, label: {
                    Image(systemName: "paintpalette")
                        .resizable()
                        .frame(width: geometry.size.width, height: geometry.size.height)
                        .foregroundColor(colors.first(where: { $0.id == selectedColorId })?.color ?? .black)
                })
                .popover(isPresented: $isPopoverPresented) {
                    ColorPickerView(selectedColorId: $selectedColorId, isPopoverPresented: $isPopoverPresented, colors: colors, colorSelected: onSelected)
                        .presentationCompactAdaptation(PresentationAdaptation.popover)
                }
            }
        }
    }
}

// MARK: - Color Picker View

private struct ColorPickerView: View {
    @Binding var selectedColorId: Int?
    @Binding var isPopoverPresented: Bool
    let colors: [ColorPickerButton.Color]
    let colorSelected: (Int?) -> Void

    var body: some View {
        VStack {
            ForEach(colors.chunked(into: 5), id: \.self) { row in
                HStack {
                    ForEach(row, id: \.self) { color in
                        Circle()
                            .fill(color.color)
                            .frame(width: 30, height: 30)
                            .onTapGesture {
                                selectedColorId = color.id
                                colorSelected(color.id)
                                isPopoverPresented = false // Close the popover when a color is selected
                            }
                    }
                }
            }
        }
        .padding()
    }
}

// MARK: - Array Extension

private extension Array {
    /// Split the array into chunks of a specified size
    /// - Parameter size: The size of each chunk
    /// - Returns: An array of chunks
    func chunked(into size: Int) -> [[Element]] {
        stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}

// MARK: - Preview

#Preview {
    let colors: [ColorPickerButton.Color] = [
        .init(id: 1, color: .black),
        .init(id: 2, color: .gray),
        .init(id: 3, color: .brown),
        .init(id: 4, color: .yellow),
        .init(id: 5, color: .orange),
        .init(id: 6, color: .green),
        .init(id: 7, color: .blue),
        .init(id: 8, color: .purple),
        .init(id: 9, color: .pink),
        .init(id: 10, color: .red)
    ]

    return
        VStack {
            ColorPickerButton(colors: colors, onSelected: { selectedColorId in
                print("Selected color ID: \(String(describing: selectedColorId))")
            })
            .frame(width: 30, height: 30)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        .background(Color(.systemGray6))
}

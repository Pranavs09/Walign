import SwiftUI

struct WheelBox: View {
    var label: String
    var offset: Double?
    var isSelected: Bool
    var isReadingDone: Bool
    var onTap: () -> Void
    
    var body: some View {
        VStack {
            Rectangle()
                .fill(isReadingDone ? Color.green : colorForOffset())
                .frame(maxWidth: 50, maxHeight: .infinity)
                .rotationEffect(.degrees(offset ?? 0))
                .animation(.easeInOut, value: offset)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(isSelected ? Color.clear : Color.clear, lineWidth: 2)
                )
                .onTapGesture {
                    onTap()
                }
        }
    }
    
    private func colorForOffset() -> Color {
        guard let offset = offset else { return Color.gray }
        return abs(offset) < 5 ? Color.green : Color.red
    }
}

#Preview {
    WheelBox(label: "LF", offset: 3.0, isSelected: false, isReadingDone: false, onTap: {})
}

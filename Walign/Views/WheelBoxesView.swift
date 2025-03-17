import SwiftUI

struct WheelBoxesView: View {
    var offset: Double?
    var label: String
    
    @Binding var selectedBox: String?
    var setAction: () -> Void
    var isReadingDone: Bool
    
    var body: some View {
        VStack {
            WheelBox(label: label, offset: offset, isSelected: selectedBox == label, isReadingDone: isReadingDone) {
                selectedBox = label
                setAction()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .edgesIgnoringSafeArea([.leading, .trailing])
        .background(.white)
    }
}

#Preview {
    WheelBoxesView(offset: 0, label: "LF", selectedBox: .constant(nil), setAction: {}, isReadingDone: false)
}

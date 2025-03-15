import SwiftUI

struct WheelBoxesView: View {
    var lfOffset: Double?
    var rfOffset: Double?
    var lrOffset: Double?
    var rrOffset: Double?
    
    @Binding var selectedBox: String?
    
    var setLF: () -> Void
    var setRF: () -> Void
    var setLR: () -> Void
    var setRR: () -> Void
    
    var isLFReadingDone: Bool
    var isRFReadingDone: Bool
    var isLRReadingDone: Bool
    var isRRReadingDone: Bool
    
    var body: some View {
        VStack {
            HStack {
                WheelBox(label: "LF", offset: lfOffset, isSelected: selectedBox == "LF", isReadingDone: isLFReadingDone) {
                    selectedBox = "LF"
                    setLF()
                }
                Spacer()
                WheelBox(label: "RF", offset: rfOffset, isSelected: selectedBox == "RF", isReadingDone: isRFReadingDone) {
                    selectedBox = "RF"
                    setRF()
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 30)
            
            if selectedBox == "LR" || selectedBox == "RR" {
                HStack {
                    WheelBox(label: "LR", offset: lrOffset, isSelected: selectedBox == "LR", isReadingDone: isLRReadingDone) {
                        selectedBox = "LR"
                        setLR()
                    }
                    Spacer()
                    WheelBox(label: "RR", offset: rrOffset, isSelected: selectedBox == "RR", isReadingDone: isRRReadingDone) {
                        selectedBox = "RR"
                        setRR()
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 30)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .edgesIgnoringSafeArea([.leading, .trailing])
        .background(.white)
    }
}

#Preview {
    WheelBoxesView(lfOffset: 0, rfOffset: 0, lrOffset: 0, rrOffset: 0, selectedBox: .constant(nil), setLF: {}, setRF: {}, setLR: {}, setRR: {}, isLFReadingDone: false, isRFReadingDone: false, isLRReadingDone: false, isRRReadingDone: false)
}

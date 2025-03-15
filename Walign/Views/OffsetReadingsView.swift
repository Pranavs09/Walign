import SwiftUI

struct OffsetReadingsView: View {
    var rfOffset: Double?
    var lrOffset: Double?
    var rrOffset: Double?

    var body: some View {
        VStack {
            if let rfOffset = rfOffset {
                Text("RF Offset: \(rfOffset, specifier: "%.2f")°")
                    .foregroundColor(.black)
            }
            if let lrOffset = lrOffset {
                Text("LR Offset: \(lrOffset, specifier: "%.2f")°")
                    .foregroundColor(.black)
            }
            if let rrOffset = rrOffset {
                Text("RR Offset: \(rrOffset, specifier: "%.2f")°")
                    .foregroundColor(.black)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea(.all)
        .background(.white)
    }
}

#Preview {
    OffsetReadingsView(rfOffset: 0, lrOffset: 0, rrOffset: 0)
} 

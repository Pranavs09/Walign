import SwiftUI
import CoreMotion

struct LevelingLinesView: View {
    @StateObject private var motionManager = MotionManager()
    
    var body: some View {
        ZStack {
            ForEach(-3...3, id: \.self) { i in
                Rectangle()
                    .frame(width: 100, height: 2)
                    .offset(y: CGFloat(i) * 15)
                    .opacity(0.3)
                    .foregroundColor(.gray)
            }
            
            Rectangle()
                .frame(width: 100, height: 4)
                .foregroundColor(motionManager.levelColor)
                .offset(x: motionManager.clampedRollOffset, y: motionManager.clampedPitchOffset)
                .rotationEffect(.degrees(motionManager.tiltAngle))
                .animation(.easeInOut(duration: 0.1), value: motionManager.clampedPitchOffset)
        }
        .frame(width: 200, height: 200)
        .onAppear {
            motionManager.startMotionUpdates()
        }
    }
}

class MotionManager: ObservableObject {
    private var motion = CMMotionManager()
    private let queue = OperationQueue()
    
    @Published var pitchOffset: CGFloat = 0.0
    @Published var rollOffset: CGFloat = 0.0
    @Published var tiltAngle: Double = 0.0
    @Published var levelColor: Color = .green
    
    var clampedPitchOffset: CGFloat {
        return max(-30, min(pitchOffset, 30))
    }
    
    var clampedRollOffset: CGFloat {
        return max(-30, min(rollOffset, 30))
    }
    
    func startMotionUpdates() {
        guard motion.isDeviceMotionAvailable else { return }
        
        motion.deviceMotionUpdateInterval = 0.1
        motion.startDeviceMotionUpdates(to: queue) { [weak self] (data, error) in
            guard let self = self, let data = data else { return }
            
            DispatchQueue.main.async {
                let attitude = data.attitude
                let pitch = attitude.pitch * (180 / .pi)
                let roll = attitude.roll * (180 / .pi)
                
                self.pitchOffset = CGFloat(pitch * 15)
                self.rollOffset = CGFloat(roll * 15)
                self.tiltAngle = roll * 2
                
                let isLeveled = abs(pitch) < 0.5 && abs(roll) < 0.5
                self.levelColor = isLeveled ? .green : (abs(pitch) < 2.0 && abs(roll) < 2.0 ? .yellow : .red)
            }
        }
    }
}

#Preview {
    LevelingLinesView()
}

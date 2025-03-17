import SwiftUI
import CoreMotion

struct MainView: View {
    @StateObject private var locationManager = LocationManager()
    @State private var selectedToePrecision = "0.05"
    @State private var selectedBox: String? = nil
    @State private var showCalibrationAlert = false
    
    let toePrecisionOptions = ["0.05", "0.02", "0.005"]
    
    var totalToe: String {
        let lfToe = locationManager.flToe
        let rfToe = locationManager.frToe
        
        if lfToe == nil && rfToe == nil {
            return "---"
        } else {
            let total = (lfToe ?? 0.0) - (rfToe ?? 0.0)
            return String(format: "%.2f", total)
        }
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Text("Front Wheels")
                    .frame(maxWidth: .infinity, maxHeight: 50)
                    .background(Color.blue.opacity(0.2))
                    .cornerRadius(8)
                    .foregroundColor(.black)
                    .padding(.horizontal, geometry.size.width * 0.05)
                
                HStack {
                    VStack {
                        HStack {
                            Text("FL Toe: \(locationManager.flToe != nil ? String(format: "%.2f", locationManager.flToe!) : "---")")
                                .foregroundColor(.black)
                        }
                        .padding(.horizontal, geometry.size.width * 0.01)
                        
                        WheelBoxesView(
                            offset: locationManager.calculateOffset(reading: locationManager.lfReading),
                            label: "LF",
                            selectedBox: $selectedBox,
                            setAction: {
                                locationManager.setLFReading(with: Double(selectedToePrecision) ?? 0.05)
                            },
                            isReadingDone: locationManager.flToe != nil
                        )
                    }
                    .padding(.horizontal, geometry.size.width * 0.01)
                    
                    VStack {
                        HStack {
                            Text("Total Toe: \(totalToe)")
                                .font(.headline)
                                .foregroundColor(.black)
                        }
                        .padding(.horizontal, geometry.size.width * 0.01)
                        
                        
                        HStack {
                                LevelingLinesView()
                            }
                        .padding(.horizontal, geometry.size.width * 0.01)
                        .padding(.vertical, geometry.size.height * 0.01)
                        }
                    .padding(.vertical, geometry.size.height * 0.01)
                    
                    VStack {
                        HStack {
                            Text("FR Toe: \(locationManager.frToe != nil ? String(format: "%.2f", locationManager.frToe!) : "---")")
                                .foregroundColor(.black)
                        }
                        .padding(.horizontal, geometry.size.width * 0.01)
                        
                        WheelBoxesView(
                            offset: locationManager.calculateOffset(reading: locationManager.rfReading),
                            label: "RF",
                            selectedBox: $selectedBox,
                            setAction: {
                                locationManager.setRFReading(with: Double(selectedToePrecision) ?? 0.05)
                            },
                            isReadingDone: locationManager.frToe != nil
                        )
                    }
                    .padding(.horizontal, geometry.size.width * 0.01)
                }
                .padding(.horizontal, geometry.size.width * 0.01)
                .padding(.vertical, geometry.size.height * 0.1)
                
                HStack {
                    Button("Reset") {
                        resetState()
                    }
                    .padding()
                    .frame(maxWidth: 400)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
                    .foregroundColor(.black)
                    
                    VStack {
                        Picker("Toe Precision", selection: $selectedToePrecision) {
                            ForEach(toePrecisionOptions, id: \.self) { option in
                                Text(option).tag(option)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .background(Color.gray.opacity(0.7))
                        .frame(maxWidth: .infinity)
                        .cornerRadius(8)
                        
                        Text("Toe Precision (inch)")
                            .foregroundColor(Color.black.opacity(0.3))
                            .font(.headline)
                    }
                }
                .padding()
                .edgesIgnoringSafeArea([.trailing, .leading, .bottom])
                
                // Calibration Button
                Button("Calibrate") {
                    locationManager.calibrate()
                    showCalibrationAlert = true
                }
                .padding()
                .frame(maxWidth: 400)
                .background(Color.blue.opacity(0.4))
                .cornerRadius(8)
                .foregroundColor(.black)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding()
            .background(Color.white)
            .alert(isPresented: $showCalibrationAlert) {
                Alert(
                    title: Text("Calibration Complete"),
                    message: Text("The calibration has been successfully completed."),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
    }
    
    private func resetState() {
        locationManager.lfReading = nil
        locationManager.rfReading = nil
        locationManager.flToe = nil
        locationManager.frToe = nil
        selectedToePrecision = "0.05"
        selectedBox = nil
    }
}

#Preview {
    MainView()
}

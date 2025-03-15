import SwiftUI

struct MainView: View {
    @StateObject private var locationManager = LocationManager()
    @State private var selectedWheelOption = 1
    @State private var selectedToePrecision = "0.05"
    @State private var selectedBox: String? = nil
    @State private var showCalibrationAlert = false
    
    let toePrecisionOptions = ["0.05", "0.02", "0.005"]
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Text("Select Wheels")
                    .font(.largeTitle)
                    .foregroundColor(.black)
                
                // Wheel Selection Buttons
                HStack {
                    Button(action: {
                        selectedWheelOption = 0
                        resetState()
                    }) {
                        Text("Front Wheels")
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(selectedWheelOption == 0 ? Color.blue.opacity(0.2) : Color.clear)
                            .cornerRadius(8)
                            .foregroundColor(.black)
                    }
                    
                    Button(action: {
                        selectedWheelOption = 1
                        resetState()
                    }) {
                        Text("All Wheels")
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(selectedWheelOption == 1 ? Color.blue.opacity(0.2) : Color.clear)
                            .cornerRadius(8)
                            .foregroundColor(.black)
                    }
                }
                .padding(.horizontal, geometry.size.width * 0.05)
                
                // Front Wheels Section
                VStack {
                    HStack {
                        Text("FL Toe: \(locationManager.flToe != nil ? String(format: "%.2f", locationManager.flToe!) : "---")")
                            .foregroundColor(.black)
                        
                        Spacer()
                        
                        Text("FR Toe: \(locationManager.frToe != nil ? String(format: "%.2f", locationManager.frToe!) : "---")")
                            .foregroundColor(.black)
                    }
                    .padding(.horizontal, geometry.size.width * 0.05)
                    
                    WheelBoxesView(
                        lfOffset: locationManager.calculateOffset(reading: locationManager.lfReading),
                        rfOffset: locationManager.calculateOffset(reading: locationManager.rfReading),
                        selectedBox: $selectedBox,
                        setLF: {
                            locationManager.setLFReading(with: Double(selectedToePrecision) ?? 0.05)
                        },
                        setRF: {
                            locationManager.setRFReading(with: Double(selectedToePrecision) ?? 0.05)
                        },
                        setLR: {},
                        setRR: {},
                        isLFReadingDone: locationManager.flToe != nil,
                        isRFReadingDone: locationManager.frToe != nil,
                        isLRReadingDone: false,
                        isRRReadingDone: false
                    )
                }
                .padding(.horizontal, geometry.size.width * 0.05)
                .padding(.vertical, geometry.size.height * 0.05)

                // Rear Wheels Section (Only if "All Wheels" is selected)
                if selectedWheelOption == 1 {
                    VStack {
                        WheelBoxesView(
                            lfOffset: locationManager.calculateOffset(reading: locationManager.lfReading),
                            rfOffset: locationManager.calculateOffset(reading: locationManager.rfReading),
                            selectedBox: $selectedBox,
                            setLF: {
                                locationManager.setLFReading(with: Double(selectedToePrecision) ?? 0.05)
                            },
                            setRF: {
                                locationManager.setRFReading(with: Double(selectedToePrecision) ?? 0.05)
                            },
                            setLR: {
                                locationManager.setLRReading(with: Double(selectedToePrecision) ?? 0.05)
                            },
                            setRR: {
                                locationManager.setRRReading(with: Double(selectedToePrecision) ?? 0.05)
                            },
                            isLFReadingDone: locationManager.flToe != nil,
                            isRFReadingDone: locationManager.frToe != nil,
                            isLRReadingDone: locationManager.rlToe != nil,
                            isRRReadingDone: locationManager.rrToe != nil
                        )
                    }
                    .padding(.horizontal, geometry.size.width * 0.05)
                    .padding(.vertical, geometry.size.height * 0.05)
                }
                
                // Reset and Toe Precision Picker
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
                .padding(.top, 20)
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
        locationManager.lrReading = nil
        locationManager.rrReading = nil
        locationManager.flToe = nil
        locationManager.frToe = nil
        locationManager.rlToe = nil
        locationManager.rrToe = nil
        
        selectedToePrecision = "0.05"
        selectedBox = nil
    }
}

// Preview
#Preview {
    MainView()
}

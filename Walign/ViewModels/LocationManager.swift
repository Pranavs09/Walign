import Foundation
import CoreLocation
import SwiftUI

class LocationManager: NSObject, CLLocationManagerDelegate, ObservableObject {
    private var locationManager: CLLocationManager
    @Published var heading: CLLocationDirection = 0.0
    @Published var lfReading: CLLocationDirection? = nil
    @Published var rfReading: CLLocationDirection? = nil
    @Published var lrReading: CLLocationDirection? = nil
    @Published var rrReading: CLLocationDirection? = nil
    
    @Published var flToe: Double? = nil
    @Published var frToe: Double? = nil
    @Published var rlToe: Double? = nil
    @Published var rrToe: Double? = nil

    override init() {
        self.locationManager = CLLocationManager()
        super.init()
        self.locationManager.delegate = self
        self.locationManager.startUpdatingHeading()
        self.locationManager.requestWhenInUseAuthorization()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        heading = newHeading.trueHeading
    }

    func setLFReading(with precision: Double) {
        lfReading = heading
        flToe = calculateToe(for: lfReading, precision: precision)
        resetOtherReadings(baseline: flToe)
    }

    func setRFReading(with precision: Double) {
        rfReading = heading
        frToe = calculateToe(for: rfReading, precision: precision)
    }
    
    func setLRReading(with precision: Double) {
        lrReading = heading
        rlToe = calculateToe(for: lrReading, precision: precision)
    }
    
    func setRRReading(with precision: Double) {
        rrReading = heading
        rrToe = calculateToe(for: rrReading, precision: precision)
    }

    func calculateToe(for reading: CLLocationDirection?, precision: Double) -> Double? {
        guard let reading = reading else { return nil }
        return Double(reading) * precision
    }

    func calibrate() {
        lfReading = nil
        rfReading = nil
        lrReading = nil
        rrReading = nil
        flToe = nil
        frToe = nil
        rlToe = nil
        rrToe = nil
    }

    func calculateOffset(reading: CLLocationDirection?) -> CLLocationDirection? {
        guard let lf = lfReading, let current = reading else { return nil }
        return current - lf
    }
    
    private func resetOtherReadings(baseline: Double?) {
        if let baseline = baseline {
            rfReading = nil
            lrReading = nil
            rrReading = nil
            
            frToe = nil 
            rlToe = nil 
            rrToe = nil
        }
    }
} 

//
//  ExoView.swift
//  GaitMate
//
//  Created by Abe Nidhiry on 11/29/23.
//

import SwiftUI
import Combine

struct ExoView: View {
    @State private var hipAngle: Double = 0.0
        @State private var kneeAngle: Double = 0.0
        @State private var ankleAngle: Double = 0.0
        @State private var legAcceleration: Double = 0.0
        @State private var gaitPhase: String = "Walking"
        
          
        var body: some View {
            VStack {
                // Joint Angles
                VStack(alignment: .leading, spacing: 8) {
                    Text("Joint Angles")
                        .font(.headline)
                        .foregroundColor(.blue)

                    Text("Hip Angle: \(String(format: "%.2f", hipAngle))°")
                    Text("Knee Angle: \(String(format: "%.2f", kneeAngle))°")
                    Text("Ankle Angle: \(String(format: "%.2f", ankleAngle))°")
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 10).foregroundColor(Color(.systemGray6)))

                // Leg Acceleration
                VStack(alignment: .leading, spacing: 8) {
                    Text("Leg Acceleration")
                        .font(.headline)
                        .foregroundColor(.blue)

                    Text("\(String(format: "%.2f", legAcceleration)) m/s²")
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 10).foregroundColor(Color(.systemGray6)))

                // Gait Phase
                VStack(alignment: .leading, spacing: 8) {
                    Text("Gait Phase")
                        .font(.headline)
                        .foregroundColor(.blue)

                    Text(gaitPhase)
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 10).foregroundColor(Color(.systemGray6)))

                Spacer()
            }
            .padding()
            .onReceive(BLEManager.shared.$receivedData) { data in
                // Update UI based on received BLE data (assuming data format is known)
                if let jointData = data.jointData {
                    hipAngle = jointData.hipAngle
                    kneeAngle = jointData.kneeAngle
                    ankleAngle = jointData.ankleAngle
                }
                legAcceleration = data.legAcceleration
                gaitPhase = data.gaitPhase
            }
            .navigationBarTitle("My Exoskeleton")
        }
            
}

class BLEManager: ObservableObject {
    static let shared = BLEManager()

    @Published var receivedData: ExoskeletonData = ExoskeletonData()
}

struct ExoskeletonData {
    var jointData: JointData?
    var legAcceleration: Double = 0.0
    var gaitPhase: String = "Walking"
}

struct JointData {
    var hipAngle: Double
    var kneeAngle: Double
    var ankleAngle: Double
}


#if DEBUG
struct ExoskeletonDataView_Previews: PreviewProvider {
    static var previews: some View {
        ExoView()
    }
}
#endif

//
//  HealthKitPermissionPrimingView.swift
//  ahowCaseHealthKit
//
//  Created by Arthur Nsereko Kahwa on 5/18/24.
//

import SwiftUI

struct HealthKitPermissionPrimingView: View {
    let description = """
This AApp displays your step and weight data in interactive charts."
You can also add new data to apple health from this app.te and

Your data is private and secured.
"""
    
    var body: some View {
        VStack(spacing: 130) {
            VStack(alignment: .leading, spacing: 8) {
                Image(.iconAppleHealth)
                    .resizable()
                    .frame(width: 90, height: 90)
                    .shadow(color: .gray.opacity(0.3), radius: 16)
                    .padding(.bottom, 16)
                
                Text("Apple Health Integration")
                    .font(.title2.bold())
                
                Text(description)
                    .foregroundStyle(.secondary)
            }

            Button("Connect Apple Health") {
                // toDo Code later
            }
            .buttonStyle(.borderedProminent)
            .tint(.pink)
        }
        .padding(32)
    }
}

#Preview {
    HealthKitPermissionPrimingView()
}

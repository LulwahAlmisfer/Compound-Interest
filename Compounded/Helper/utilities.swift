//
//  utilities.swift
//  Compounded
//
//  Created by lulwah on 30/12/2023.
//

import SwiftUI

extension Binding where Value == Double {
    var toString: Binding<String> {
        Binding<String>(
            get: {
                
                "\(wrappedValue)"
            },
            set: {
                
                wrappedValue = Double($0) ?? 0
            }
        )
    }
}
struct TextFieldStepper: View {
    @Binding var value: Double

    var body: some View {
        HStack(spacing: 0) {
            TextField("", text: $value.toString)
                .padding()
                .keyboardType(.asciiCapableNumberPad)
                .textFieldStyle(.roundedBorder)
            
             
            Stepper("", value: $value , in: 1...999999 )
          
        }
    }
}

extension Double {
    func englishFormatted() -> Double {
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits =  2
        let a = formatter.string(from: NSNumber(value: self)) ?? ""
        return Double(a) ?? 0
    }
}

extension String {
    func toDouble() -> Double? {
        return NumberFormatter().number(from: self)?.doubleValue
    }
    func toInt() -> Int? {
        return NumberFormatter().number(from: self)?.intValue
    }
}

struct Helper {
    static func goToAppSetting() {
        DispatchQueue.main.async {
            if let appSettings = URL(string: UIApplication.openSettingsURLString), UIApplication.shared.canOpenURL(appSettings) {
                UIApplication.shared.open(appSettings)
            }
        }
    }
}

struct Object: Identifiable {
    let id = UUID()
    let name: String
    var Data: [Double]
    
    var DataByYear: [(month: String, amount: Double)] {
        Data.enumerated().map { (offset, amount) in
            return (
                month: String(offset + 1),
                amount: amount
            )
        }
    }
}


struct PickerStyle {
    
    init() {
        // Sets the background color of the Picker
        //   UISegmentedControl.appearance().backgroundColor = UIColor.theme.Rectangles
        // Disappears the divider
        UISegmentedControl.appearance().setDividerImage(UIImage(), forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
        // Changes the color for the selected item
        UISegmentedControl.appearance().selectedSegmentTintColor = UIColor(named: "AccentColor")
        // Changes the text color for the selected item
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
        
    }
}

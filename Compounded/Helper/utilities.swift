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
        UISegmentedControl.appearance().setDividerImage(UIImage(), forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
        UISegmentedControl.appearance().selectedSegmentTintColor = UIColor(named: "AccentColor")
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
    }
}

extension NumberFormatter {
    static let latinDigitsFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX") 
        formatter.numberStyle = .decimal
        return formatter
    }()
}


extension Formatter {
    static let latinInteger: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 0
        return formatter
    }()
    static let withCommas: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = ","
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 0
        formatter.usesGroupingSeparator = true

        return formatter
    }()
}

extension String {
    var convertedToEnglishDigits: String {
        let map: [Character: Character] = [
            "٠": "0", "١": "1", "٢": "2", "٣": "3", "٤": "4",
            "٥": "5", "٦": "6", "٧": "7", "٨": "8", "٩": "9"
        ]
        return String(self.map { map[$0] ?? $0 })
    }
}

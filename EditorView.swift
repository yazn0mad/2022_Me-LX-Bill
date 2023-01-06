//
//  EditorView.swift
//  Me LX Bill
//
//  Created by Yazz Tanaka on 29/12/2022.
//

import SwiftUI

struct EditorRates {
    var editorBR: Double
    var editorL1: Double
    var editorL2: Double
    var editorR1: Double
    var editorR2: Double
    var editorR3: Double
    var editorFee: Double
    var editorLevy: Double
}

struct EditorStatus {
    var isEdited: Bool
}

struct EditorView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    @Binding var editorRates: EditorRates
    @Binding var editorStatus: EditorStatus
    
    // TextField input values
    @State private var basicRateInput: Double = 0.0
    @State private var l1Input: Double = 0.0
    @State private var l2Input: Double = 0.0
    @State private var r1Input: Double = 0.0
    @State private var r2Input: Double = 0.0
    @State private var r3Input: Double = 0.0
    @State private var feeInput: Double = 0.0
    @State private var levyInput: Double = 0.0
    // Setting up for numpad jumping with 'NEXT' button
    enum InputItem {
        case basicRateInput
        case l1Input
        case l2Input
        case r1Input
        case r2Input
        case r3Input
        case feeInput
        case levyInput
    }
    
    @FocusState private var focusedInput: InputItem?
    
    // Alerts
    @State private var showingL2Alert = false
    @State private var showingResetWarning = false
    
    var isSaved = UserDefaults.standard.bool(forKey: "isSaved")
    
    let localeString = Locale.current.language.languageCode?.identifier
    
    private static let formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.zeroSymbol = ""
        formatter.numberStyle = .decimal
        return formatter
    }()

    var body: some View {
        ZStack {
            Form {
                Section (header: Text(" ")) {
                    HStack {
                        Text("Basic Rate")
                        Text("=")
                        Text("¥")
                        TextField("0.00", value: $basicRateInput, formatter: Self.formatter)
                            .textFieldStyle(.roundedBorder)
                            .keyboardType(.decimalPad)
                            .foregroundColor(.red)
                            .focused($focusedInput, equals: .basicRateInput)
                    }
                }
                .listRowBackground(Color.cyan.opacity(0.2))
                
                Section {
                    HStack {
                        Text("Up to first")
                        TextField("0", value: $l1Input, formatter: Self.formatter)
                            .textFieldStyle(.roundedBorder)
                            .keyboardType(.numberPad)
                            .foregroundColor(.red)
                            .focused($focusedInput, equals: .l1Input)
                            
                        Text("kWh")
                        // Add a Japanese word
                        if localeString == "ja" {
                            Text("made").font(.caption)
                        }
                        Text("@")
                        Text("¥")
                        TextField("0.00", value: $r1Input, formatter:  Self.formatter)
                            .textFieldStyle(.roundedBorder)
                            .keyboardType(.decimalPad)
                            .foregroundColor(.red)
                            .focused($focusedInput, equals: .r1Input)
                            
                    }
                    HStack {
                        Text("More than above to")
                        
                        TextField("?", value: $l2Input, formatter: Self.formatter)
                            .textFieldStyle(.roundedBorder)
                            .keyboardType(.numberPad)
                            .foregroundColor(.red)
                            .focused($focusedInput, equals: .l2Input)
                            
                        Text("kWh")
                        // Add a Japanese word
                        if localeString == "ja" {
                            Text("made").font(.caption)
                        }
                        Text("@")
                        Text("¥")
                        TextField("0.00", value: $r2Input, formatter:  Self.formatter)
                            .textFieldStyle(.roundedBorder)
                            .keyboardType(.decimalPad)
                            .foregroundColor(.red)
                            .focused($focusedInput, equals: .r2Input)
                            
                    }
                    HStack {
                        if localeString != "ja" {
                            Text("Over")
                            l2Input == 0.0 ? Text("?") : Text("\(Int(l2Input))")
                            Text("kWh")
                        } else {
                            l2Input == 0.0 ? Text("?") : Text("\(Int(l2Input))")
                            Text("kWh")
                            Text("ijyo").font(.caption)
                        }
                        
                        Text("@")
                        Text("¥")
                        TextField("0.00", value: $r3Input, formatter:  Self.formatter)
                            .textFieldStyle(.roundedBorder)
                            .keyboardType(.decimalPad)
                            .foregroundColor(.red)
                            .focused($focusedInput, equals: .r3Input)
                            
                    }
                }
                .listRowBackground(Color.cyan.opacity(0.2))
                
                Section {
                    HStack {
                        Text("Fuel Cost Adjustment Fee")   // Fuel Cost Adjustment Fee
                        Text(" = ")
                        Text("¥")
                        TextField("0.00", value: $feeInput, formatter: Self.formatter)
                            .textFieldStyle(.roundedBorder)
                            .keyboardType(.decimalPad)
                            .foregroundColor(.red)
                            .focused($focusedInput, equals: .feeInput)
                            
                    }
                    HStack {
                        Text("Renewable Energy Generation Levy") // Renewable Energy Generation Levy
                        Text(" = ")
                        Text("¥")
                        TextField("0.00", value: $levyInput, formatter: Self.formatter)
                            .textFieldStyle(.roundedBorder)
                            .keyboardType(.decimalPad)
                            .foregroundColor(.red)
                            .focused($focusedInput, equals: .levyInput)
                            
                    }
                }
                .listRowBackground(Color.cyan.opacity(0.2))
                
                
                // SAVE button
                Section {
                    Button(action: {
                        // check for kWh range error
                        if l2Input <= l1Input {
                            showingL2Alert = true
                            focusedInput = .l2Input
                        } else {
                            // pass data to CalculatorView
                            editorRates = EditorRates(
                                editorBR: self.basicRateInput,
                                editorL1: self.l1Input,
                                editorL2: self.l2Input,
                                editorR1: self.r1Input,
                                editorR2: self.r2Input,
                                editorR3: self.r3Input,
                                editorFee: self.feeInput,
                                editorLevy: self.levyInput)
                            editorStatus = EditorStatus(isEdited: true)
                            // save data
                            UserDefaults.standard.set(self.basicRateInput, forKey: "basicRate")
                            UserDefaults.standard.set(self.l1Input, forKey: "limit_1")
                            UserDefaults.standard.set(self.l2Input, forKey: "limit_2")
                            UserDefaults.standard.set(self.r1Input, forKey: "rate_1")
                            UserDefaults.standard.set(self.r2Input, forKey: "rate_2")
                            UserDefaults.standard.set(self.r3Input, forKey: "rate_3")
                            UserDefaults.standard.set(self.feeInput, forKey: "fee")
                            UserDefaults.standard.set(self.levyInput, forKey: "levy")
                            UserDefaults.standard.set(true, forKey: "isSaved")
                            // back to Calculator
                            dismiss()
                        }
                    }, label: {
                        Text(disableSave ? "SAVE - value of 0 is not permitted" : "SAVE")
                            .foregroundColor(disableSave ? .gray : .blue)
                            .frame(maxWidth: .infinity, alignment: .center)
                    })
                }
                .disabled(disableSave)
                
                // RESET button
                Section {
                    Button("RESET") {
                        showingResetWarning = true
                    }
                    .alert("Your rates will be erased!\nAre you sure?", isPresented: $showingResetWarning) {
                        Button("RESET", role: .destructive) {
                            editorStatus = EditorStatus(isEdited: false)
                            UserDefaults.standard.set(false, forKey: "isSaved")
                            // Reset 'FirstTime' to load GuideView
                            UserDefaults.standard.set(true, forKey: "isFirstTime")
                            dismiss()
                        }
                        Button("Cancel", role: .cancel) {}
                    }
                    .foregroundColor(showingResetWarning ? .gray : .red).opacity(0.8)
                    .frame(maxWidth: .infinity, alignment: .center)
                }

            }
            // Numpad config
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Button("Done") {
                        hideKeyboard()
                    }
                    Spacer()
                    Button("Next") {
                        switch focusedInput {
                        case .basicRateInput : focusedInput = .l1Input
                        case .l1Input : focusedInput = .r1Input
                        case .r1Input : focusedInput = .l2Input
                        case .l2Input :
                            if l2Input > l1Input {
                                focusedInput = .r2Input
                            } else {
                                showingL2Alert = true
                            }
                        case .r2Input : focusedInput = .r3Input
                        case .r3Input : focusedInput = .feeInput
                        case .feeInput : focusedInput = .levyInput
                        default : focusedInput = nil
                            hideKeyboard()
                        }
                    }
                    .alert("Second kWh must be greater than the first kWh", isPresented: $showingL2Alert) {
                        Button("OK", role: .cancel) {}
                    }
                    
                }
            }
        }
        .navigationBarTitle(Text("Customise rates"), displayMode: .inline)
        .foregroundColor(AppColor._Black)
        .background(AppColor._CY)
        .scrollContentBackground(.hidden)
        .onAppear() {
            // Preload saved rates to TextField
            if isSaved {
                self.basicRateInput = editorRates.editorBR
                self.l1Input = editorRates.editorL1
                self.l2Input = editorRates.editorL2
                self.r1Input = editorRates.editorR1
                self.r2Input = editorRates.editorR2
                self.r3Input = editorRates.editorR3
                self.feeInput = editorRates.editorFee
                self.levyInput = editorRates.editorLevy
            }
        }
        .onDisappear() {
            hideKeyboard()
        }
    }
    
    var disableSave: Bool {
        basicRateInput.isZero ||
        l1Input.isZero ||
        l2Input.isZero ||
        r1Input.isZero ||
        r2Input.isZero ||
        r3Input.isZero ||
        feeInput.isZero ||
        levyInput.isZero
    }
    
}



struct FormView_Previews: PreviewProvider {
    static var previews: some View {
        let editorRates = EditorRates(
            editorBR: 0.0,
            editorL1: 0.0,
            editorL2: 0.0,
            editorR1: 0.0,
            editorR2: 0.0,
            editorR3: 0.0,
            editorFee: 0.0,
            editorLevy: 0.0)
        let editorStatus = EditorStatus(isEdited: true)
       
        EditorView(editorRates: .constant(editorRates), editorStatus: .constant(editorStatus))
            .environment(\.locale, .init(identifier: "ja"))
        
        EditorView(editorRates: .constant(editorRates), editorStatus: .constant(editorStatus))
            .environment(\.locale, .init(identifier: "en"))
    }
}



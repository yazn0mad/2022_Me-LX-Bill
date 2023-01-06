//
//  ConverterView.swift
//  Me LX Bill
//
//  Created by Yazz Tanaka on 26/12/2022.
//

import SwiftUI

struct ConverterView: View {
    
    @State private var wattInput: Double = 0
    @State private var hourInput: Double = 0
    // preset for nampad 'NEXT' button for jumping textfield
    enum InputItem {
        case wattInput
        case hourInput
    }
    
    @FocusState private var focusedInput: InputItem?
    
    @Binding var showConverter: Bool
    
    // limit hour input to max 24
    @State private var showingMax24Alert = false
    
    // formulae for W - kWh convesion
    private var kwh_day: Double { return wattInput * hourInput / 1000.0 }
    private var kwh_month: Double { return wattInput * hourInput / 1000.0 * 30.0 }
    
    private static let formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.zeroSymbol = ""
        formatter.numberStyle = .decimal
        return formatter
    }()

    var body: some View {
        ZStack {
            Form {
                Spacer()
                    .listRowBackground(Color.clear)
                Section {
                    Text("W - kWh Converter")
                        .font(.headline)
                        .frame(maxWidth: .infinity, alignment: .center)
                }
                .listRowBackground(Color.clear)

                Section {
                    HStack {
                        Text("Power in watts")
                        Text("=")
                        TextField("", value: $wattInput, formatter: Self.formatter)
                            .textFieldStyle(.roundedBorder)
                            .keyboardType(.numberPad)
                            .focused($focusedInput, equals: .wattInput)
                        Text("W")
                    }

                    HStack {
                        Text("Usage in hours")
                        Text("=")
                        TextField("", value: $hourInput, formatter: Self.formatter)
                            .textFieldStyle(.roundedBorder)
                            .keyboardType(.numberPad)
                            .focused($focusedInput, equals: .hourInput)
                            .onChange(of: hourInput) {
                                if $0 > 24 {
                                    showingMax24Alert = true
                                    hourInput = 0
                                }
                            }
                        Text("H")
                    }
                    .alert("Max 24 Hours!", isPresented: $showingMax24Alert) {
                        Button("OK", role: .cancel) {}
                    }
                }
                .padding(.leading)
                .padding(.trailing)
                .listRowBackground(Color.cyan.opacity(0.2))
                
                Section(header:
                            HStack {
                    Spacer()
                    Text("Results").textCase(nil)
                    Spacer()
                }) {
                    
                    HStack {
                        Text("\(kwh_day, specifier: "%.1f")")
                            .font(.title)
                        Text("kWh / day")
                    }
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    
                    HStack {
                        Text("\(kwh_month, specifier: "%.0f")")
                            .font(.title)
                        Text("kWh / month")
                    }
                    .frame(maxWidth: .infinity, alignment: .trailing)
                }
                .padding(.leading)
                .padding(.trailing)
                .listRowBackground(Color.cyan.opacity(0.2))
                
                Section {
                    Button(action: {
                        self.showConverter.toggle()
                    }) {
                        Image(systemName: "xmark.circle")
                            .imageScale(.large)
                            .font(.title)
                            .opacity(0.8)
                        
                    }
                }
                .listRowBackground(Color.blue)
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.top, -8)
            }
            .padding(.top)
            .foregroundColor(AppColor._Black)
            .background(.blue)
            .scrollContentBackground(.hidden)
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Button("Done") {
                        hideKeyboard()
                    }
                    Spacer()
                    Button("Next") {
                        switch focusedInput {
                        case .wattInput : focusedInput = .hourInput
                        case .hourInput : focusedInput = .wattInput
                        default : focusedInput = nil
                        }
                    }
                }
            }
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct ConverterView_Previews: PreviewProvider {
    static var previews: some View {
        ConverterView(showConverter: .constant(true))
            .environment(\.locale, .init(identifier: "ja"))
        
        ConverterView(showConverter: .constant(true))
            .environment(\.locale, .init(identifier: "en"))
    }
}

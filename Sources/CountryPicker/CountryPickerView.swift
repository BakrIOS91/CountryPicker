// The Swift Programming Language
// https://docs.swift.org/swift-book

import SwiftUI

public struct CountryPickerView<Content: View, NoData: View>: View {
    @Binding private var selectedCountry: Country
    @State private var showCountriesList: Bool = false
    
    private var locale: Locale
    private var sheetTitle: LocalizedStringKey = ""
    private var content: Content
    private var noData: () -> NoData
    
    public init(
        locale: Locale,
        selectedCountry: Binding<Country>,
        sheetTitle: LocalizedStringKey,
        @ViewBuilder content: () -> Content,
        @ViewBuilder noData: @escaping () -> NoData
    ) {
        self.locale = locale
        self._selectedCountry = selectedCountry
        self.sheetTitle = sheetTitle
        self.content = content()
        self.noData = noData
    }
    
    public var body: some View {
        Button {
            showCountriesList.toggle()
        } label: {
            content
        }
        .buttonStyle(.plain)
        .sheet(isPresented: $showCountriesList) {
            CountryListView(
                locale: locale,
                title: sheetTitle,
                selectedCountry: $selectedCountry,
                noDataView: noData
            )
        }
    }
}


struct CountryPickerExample: View {
    @State var selectedCountry: Country = .emptyCountry
    
    var body: some View {
        CountryPickerView(
            locale: Locale(identifier: "ar_SA"),
            selectedCountry: $selectedCountry,
            sheetTitle: "Countries"
        ) {
            HStack{
                Text(selectedCountry.flag)
                Text(selectedCountry.dial_code)
            }
                .frame(width: 100, height: 30, alignment: .center)
                .background (
                    Color.white
                        .shadow(color: .gray, radius: 8)
                )
        } noData: {
            Text("No Data")
        }
    }
}

struct CountryPicker_Preview: PreviewProvider {
    
    static var previews: some View {
        CountryPickerExample()
    }
}

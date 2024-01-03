//
//  SwiftUIView.swift
//  
//
//  Created by Bakr mohamed on 11/12/2023.
//

import SwiftUI

struct CountryListView<NoData: View> : View {
    @Environment(\.dismiss) private var dismiss
    @State private var countriesList: [Country] = []
    @State private var isLoading: Bool = true
    @State private var searchText: String = ""

    @Binding private var selectedCountry: Country
    private var title: LocalizedStringKey
    private var noDataView: () -> NoData
    
    init(
        title: LocalizedStringKey,
        selectedCountry: Binding<Country>,
        @ViewBuilder noDataView: @escaping () -> NoData
    ) {
        self.title = title
        self._selectedCountry = selectedCountry
        self.noDataView = noDataView
    }
    
    var body: some View {
        NavigationView {
            VStack {
                if countriesList.isEmpty {
                    if isLoading{
                        ProgressView()
                            .progressViewStyle(.circular)
                    } else {
                        noDataView()
                    }
                } else {
                    List {
                        ForEach(countriesList.filter {
                            searchText.isEmpty || $0.name.localizedCaseInsensitiveContains(searchText) || $0.dial_code.localizedCaseInsensitiveContains(searchText)
                        }) { country in
                            HStack{
                                Text(country.flag)
                                
                                Text(country.name)
                                
                                Spacer()
                                
                                Text(country.dial_code)
                            }
                            .onTapGesture {
                                selectedCountry = country
                                dismiss()
                            }
                        }
                    }
                    .searchable(text: $searchText)
                }
            }
            .task {
                await fetchCountries()
            }
            .navigationTitle(title)
            .navigationBarBackButtonHidden()
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button{
                        dismiss()
                    }label: {
                        Image(systemName: "chevron.backward")
                    }
                }
            }
        }
    }
    
    private func fetchCountries() async {
        do {
            // Determine the appropriate file name based on language
            let filename = Locale.current.languageCode == "ar" ? "Countries_Ar" : "Countries_En"
            
            // Access the file using Bundle.module for package context
            guard let fileURL = Bundle.module.url(forResource: filename, withExtension: "json"),
                  let data = try? Data(contentsOf: fileURL)
            else {
                throw NSError(domain: "YourPackageErrorDomain", code: 1, userInfo: nil)
            }
            
            let countries = try JSONDecoder().decode([Country].self, from: data)
            self.countriesList = countries
        } catch {
            // Handle error
            print("Error fetching countries: \(error)")
        }
        
        // Set isLoading to false when the data fetching is complete
        isLoading = false
    }
}

struct CountryListViewer: View {
    @State private var selectedCountry: Country = .emptyCountry
    
    var body: some View {
        CountryListView(
            title: "Countries",
            selectedCountry: $selectedCountry) {
                Text("No Data View")
            }
    }
}

struct CountryListViewer_Preview: PreviewProvider {
    
    static var previews: some View {
        CountryListViewer()
    }
}

//
//  ContentView.swift
//  FirmaDigital
//
//  Created by Brandon Luis Meneses Solorzano on 9/07/24.
//

import SwiftUI

struct UrlLoginView: View {
    @State private var url: String = "https://"
    @State private var isValidUrl: Bool = false
    @State private var isLoading: Bool = false
    @State private var isSuccess: Bool = false
    @State private var errorMessage: String = ""
    @State private var expanded: Bool = false
    @State private var autoCompleteSelected: Bool = false
    @State private var textFieldFocused: Bool = false

    let domainSuggestions = ["efirmalegal.com", "efirmalegal-dev.com"]

    var body: some View {
        NavigationView {
            VStack {
                Text("Ingrese la URL de su plataforma de firma")
                    .font(.title3)
                    .multilineTextAlignment(.center)
                    .padding()

                TextField("https://", text: $url, onEditingChanged: { isEditing in
                    self.textFieldFocused = isEditing
                    self.expanded = isEditing && !autoCompleteSelected && isValidUrl
                })
                .textInputAutocapitalization(.never)
                .disableAutocorrection(true)
                .border(Color.gray)
                .padding()
                

                if expanded {
                    Menu {
                        ForEach(domainSuggestions, id: \.self) { domain in
                            Button {
                                url = "https://\(domain)"
                                isValidUrl = validateUrl(url)
                                expanded = false
                                autoCompleteSelected = true
                            } label: {
                                Text("https://\(domain)")
                            }
                        }
                    } label: {
                        Text("Sugerencias")
                            .foregroundColor(.blue)
                    }
                }

                if errorMessage != "" {
                    Text(errorMessage)
                        .foregroundColor(.red)
                }

                Button("Validar y continuar") {
                    isLoading = true
                    verifyUrl(url: url) { exists in
                        isLoading = false
                        if exists {
                            isSuccess = true
                        } else {
                            errorMessage = "URL no válida o no accesible."
                            isSuccess = false
                        }
                    }
                }
                .disabled(!isValidUrl || isLoading)
                .padding()

                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                }

                Spacer()
            }
            .navigationBarTitle("Bienvenido a la aplicación de Firma", displayMode: .inline)
            .navigationBarItems(trailing: Button(action: {
                print("Acción del botón derecho")
            }) {
                Text("Acción")
            })
        }
    }

    private func validateUrl(_ url: String) -> Bool {
        guard let urlComponent = URLComponents(string: url), urlComponent.scheme == "https" else {
            return false
        }
        return urlComponent.host?.contains(".") ?? false && (urlComponent.path.isEmpty || urlComponent.path == "/")
    }

    private func verifyUrl(url: String, completion: @escaping (Bool) -> Void) {
        // Simular una verificación de URL
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            completion(true) // Suponer que la URL es siempre accesible
        }
    }
}


#Preview {
    UrlLoginView()
}

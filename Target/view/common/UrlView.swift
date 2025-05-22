//
//  UrlView.swift
//  Target
//
//  Created by Sávio Dutra on 05/01/25.
//

import SwiftUI

struct UrlView: View {
    @Binding var urlSource: String?
    @State var validUrl: Bool = false
    @State private var isShowingURLInput = false
    @State private var urlTemp: String = ""

    var body: some View {
        HStack(spacing: 20) {
            if urlSource != nil && !urlSource!.isEmpty {
                Button("Editar") {
                    print("Editar a url do objetivo")
                    urlTemp = urlSource!
                    isShowingURLInput.toggle()
                }
                .padding(.horizontal, 20)
                .buttonStyle(BorderlessButtonStyle())
                .foregroundColor(.white)
                .background(.blue.opacity(0.8))
                .cornerRadius(8.0)
                
                Button("Ir") {
                    if (validUrl) {
                        print("IR")
                        callNavigation()
                    }
                }
                .padding(.horizontal, 20)
                .buttonStyle(BorderlessButtonStyle())
                .foregroundColor(.white)
                .background(validUrl ? .blue.opacity(0.8) : .gray.opacity(0.8))
                .cornerRadius(8.0)
            } else {
                Button("Salvar") {
                    print("Salvar a url do objetivo")
                    isShowingURLInput.toggle()
                }
                .padding(.horizontal, 20)
                .buttonStyle(BorderlessButtonStyle())
                .foregroundColor(.white)
                .background(.blue.opacity(0.8))
                .cornerRadius(8.0)
            }
        }
        .onChange(of: urlSource) {
            validateUrl()
        }
        .alert("Url Target", isPresented: $isShowingURLInput) {
            TextField("Type or paste the web address", text: $urlTemp)
            Button("OK") {
                self.urlSource = self.urlTemp == "" ? nil : self.urlTemp
            }
            Button("CANCEL") {}
        }
        .onAppear {
            validateUrl()
        }
    }
    
    func validateUrl() {
        
        validUrl = false
        
        if (urlSource == nil) {
            return
        }
        
        /*guard let url = URL(string: urlSource!), UIApplication.shared.canOpenURL(url) else {
            validUrl = false
            return
        }*/
        if let url = URL(string: urlSource ?? "") {
            
            #if !os(macOS)
            if UIApplication.shared.canOpenURL(url) {
                validUrl = true
            }
            #else
            if NSWorkspace.shared.urlForApplication(toOpen: url) != nil {
                validUrl = true
            }
            #endif
        } else {
            validUrl = false
        }
    }
    
    func callNavigation() {
        guard let url = URL(string: urlSource ?? "") else { return }
        
        #if os(macOS)
        NSWorkspace.shared.open(url)
        #else
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
        #endif
    }
}


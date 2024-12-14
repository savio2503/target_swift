//
//  Logged.swift
//  target
//
//  Created by Sávio Dutra on 25/12/23.
//

import SwiftUI

struct LoggedView: View {
    
    @Environment(\.dismiss) private var dismiss
    @State var email: String = ""
    @State var historics: [Deposit] = []
    
    var body: some View {
        VStack {
            Spacer()
            Text(email)
                .padding(.bottom, 30)
                .padding(.top, 20)
            Text("Historic")
                .padding(.bottom, 10)
            Divider()
                .padding(.horizontal, 20)
            
            ScrollView {
                ForEach(historics) { historic in
                    //Text(historic.mes)
                    HStack {
                        Spacer()
                        Text("\(historic.valor < 0.0 ? "-" : "") \(String(format: "R$ %.02f", historic.valor))")
                        Spacer()
                        Text("\(historic.mes)")
                        Spacer()
                    }
                        .padding(.horizontal, 20)
                    
                    Divider()
                        .padding(.horizontal, 20)
                }
            }
            
            Spacer()
            Button(action: {
                
                removeAllSaves()
                
                KeysStorage.shared.token = nil
                KeysStorage.shared.recarregar = true
                
                dismiss()
                
            }) {
                //baseButton(text: "deslocar", color: Color.blue)
                HStack {
                    Spacer()
                    Text("Deslogar")
                        .foregroundStyle(.white)
                    Spacer()
                }
                .padding()
                .background(Color.blue)
                .cornerRadius(5.0)
            }
            .padding()
            Spacer()
        }.onAppear() {
            Task {
                await getInfoUser()
            }
            Task {
                await historicUser()
            }
        }
    }
    
    private func getInfoUser() async {
        do {
            let _mail = try await Api.shared.infoUser()
            
            self.email = _mail
        } catch {
            print("erro no getInfoUser()")
        }
    }
    
    private func historicUser() async {
        
        do {
            let result: [Deposit] = try await Api.shared.getHistoricUser()
            
            self.historics.removeAll()
            
            self.historics = result.map { $0 }
            
            for index in self.historics.indices {
                self.historics[index].id = index + 1
            }
            
            //print("res: \(self.historics)")
        } catch {
            print("erro no historicUser() \(error)")
        }
    }
}


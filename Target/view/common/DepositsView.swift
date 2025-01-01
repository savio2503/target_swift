//
//  DepositsView.swift
//  target
//
//  Created by Sávio Dutra on 21/03/24.
//

import SwiftUI
import ComponentsCommunication

struct DepositsView: View {
    
    @Binding var deposits: [Deposit]
    
    var body: some View {
        VStack {
            ForEach(deposits, id: \.self) { deposit in
                HStack {
                    Spacer()
                    if deposit.valor < 0.0 {
                        Text("-")
                    } else {
                        Text("+")
                    }
                    Spacer()
                    Text("\(String(format: "R$ %.02f", deposit.valor))")
                    Spacer()
                    Text("\(deposit.mes)")
                    Spacer()
                }
                Divider()
            }
        }
    }
}

/*#Preview {
    DepositsView()
}*/

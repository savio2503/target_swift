//
//  PriorityView.swift
//  target
//
//  Created by Sávio Dutra on 06/01/24.
//

import SwiftUI

struct PriorityView: View {
    @Binding var selectNumber: Int
    var itemIds: [Int] = Array(1...10)
    
    var body: some View {
        ScrollView(.horizontal) {
            HStack {
                ForEach(itemIds, id: \.self) { itemId in
                    if itemId == selectNumber {
                        Button("\(itemId)"){
                            selectNumber = itemId
                        }
                        .padding()
                        .foregroundColor(.black)
                        .background(.blue.opacity(0.8))
                        .cornerRadius(8)
                        .font(.title)
                    } else {
                        Button("\(itemId)"){
                            selectNumber = itemId
                        }
                        .padding()
                        .foregroundColor(.black)
                        .background(RoundedRectangle(cornerRadius: 8, style: .continuous).stroke(.blue))
                        .cornerRadius(8)
                        .font(.title)
                    }
                }
            }
        }
    }
}

#Preview {
    @State var number: Int = 1
    return PriorityView(selectNumber: $number)
}

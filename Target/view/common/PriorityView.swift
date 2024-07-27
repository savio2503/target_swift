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
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        ScrollViewReader { proxy in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(itemIds, id: \.self) { itemId in
                        Button("\(itemId)") {
                            selectNumber = itemId
                            withAnimation {
                                proxy.scrollTo(selectNumber, anchor: .center)
                            }
                        }
                        .padding()
                        .foregroundColor(itemId == selectNumber ? .black : (colorScheme == .dark ? .white : .black))
                        .background(itemId == selectNumber ? Color.blue.opacity(0.8) : Color.clear)
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.blue, lineWidth: itemId == selectNumber ? 0 : 1)
                        )
                        .font(.title)
                        .id(itemId)
                    }
                }
                .onAppear {
                    withAnimation {
                        proxy.scrollTo(selectNumber, anchor: .center)
                    }
                }
                .onChange(of: selectNumber) { _, _ in
                    withAnimation {
                        proxy.scrollTo(selectNumber, anchor: .center)
                    }
                }
            }
        }
    }
}

#Preview {
    @State var number: Int = 10
    return PriorityView(selectNumber: $number)
}

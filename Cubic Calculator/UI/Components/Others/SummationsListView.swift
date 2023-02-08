//
//  SummationsListView.swift
//  Cubic Calculator
//
//  Created by Paweł Sobaszek on 30/08/2022.
//

import SwiftUI

struct SummationsListView: View {
    private let allSummations: [SummationEntity]
    private let onDeleteAction: (_ offsets: IndexSet) -> Void
    
    init(allSummations: [SummationEntity], onDeleteAction: @escaping (_: IndexSet) -> Void) {
        self.allSummations = allSummations
        self.onDeleteAction = onDeleteAction
    }
    
    var body: some View {
        List {
            HStack {
                Text(Resources.strings.id())
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                Text(Resources.strings.dimensionDiameter())
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                Text(Resources.strings.dimensionLength())
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                Text(Resources.strings.sum())
                    .font(.headline)
                    .frame(maxWidth: .infinity)
            }
            
            ForEach(allSummations) { summation in
                HStack {
                    Text("\(summation.id)")
                        .frame(maxWidth: .infinity)
                    Text("\(summation.diameter)")
                        .frame(maxWidth: .infinity)
                    Text("\(summation.length)")
                        .frame(maxWidth: .infinity)
                    Text(String(format: "%.3f", summation.sum))
                        .frame(maxWidth: .infinity)
                }
            }.onDelete(perform: onDeleteAction)
        }
        .listStyle(.inset)
    }
}

struct SummationsList_Previews: PreviewProvider {
    static var previews: some View {
        SummationsListView(allSummations: [], onDeleteAction: { _ in })
    }
}

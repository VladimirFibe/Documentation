//
//  BackgroundView.swift
//  OpenMind
//
//  Created by Vladimir Fibe on 04.10.2022.
//

import SwiftUI

struct BackgroundView: View {
    @EnvironmentObject var cellStore: CellStore
    var body: some View {
        ZStack {
            Color.teal.opacity(0.7)
                .ignoresSafeArea()
                .onTapGesture { cellStore.selectedCell = nil }
            
            ForEach(cellStore.cells) { cell in
                CellView(cell: cell)
            }
        }
    }
}

struct BackgroundView_Previews: PreviewProvider {
    static var previews: some View {
        BackgroundView()
            .environmentObject(CellStore())
    }
}

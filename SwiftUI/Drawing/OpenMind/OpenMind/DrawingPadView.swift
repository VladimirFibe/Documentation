//
//  DrawingPadView.swift
//  OpenMind
//
//  Created by Vladimir Fibe on 07.10.2022.
//

import SwiftUI

struct DrawingPadView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var cellStore: CellStore
    
    @State private var drawing: Drawing?
    @State private var pickedColor = ColorPicker.Color.black
    @State private var sliderValue = 0.0
    var body: some View {
        VStack {
            HStack {
                Button("Cancel") { dismiss() }
                Spacer()
                Button("Save") {
                    if let cell = cellStore.selectedCell,
                       let drawing = drawing {
                        cellStore.updateDrawing(cell: cell, drawing: drawing)
                    }
                    dismiss() }
            }
            .padding()
            
            Divider()
            
            DrawingPad(pickedColor: pickedColor.color.opacity(1 - sliderValue), savedDrawing: $drawing)
            
            Divider()
            
            ColorSlider(sliderValue: $sliderValue, colors: [pickedColor.color, pickedColor.color.opacity(0)])
                .frame(height: 60)
                .padding(.horizontal)
            ColorPicker(pickedColor: $pickedColor)
                .frame(height: 80)
        }
        .task {
            drawing = cellStore.selectedCell?.drawing
        }
    }
}

struct DrawingPadView_Previews: PreviewProvider {
    static var previews: some View {
        DrawingPadView()
            .environmentObject(CellStore())
    }
}

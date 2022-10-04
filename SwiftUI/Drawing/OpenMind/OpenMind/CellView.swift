import SwiftUI

struct CellView: View {
    let cell: Cell
    @State private var text = ""
    
    var body: some View {
        ZStack {
            cell.shape?.shape
                .foregroundColor(.white)
            cell.shape?.shape
                .stroke(cell.color, lineWidth: 3)
            TextField("Enter cell text", text: $text)
                .padding()
                .multilineTextAlignment(.center)
        }
        .frame(width: cell.size.width, height: cell.size.height)
        .offset(cell.offset)
        .onAppear { text = cell.text }
    }
}

struct CellView_Previews: PreviewProvider {
    static var previews: some View {
        CellView(cell: Cell())
            .previewLayout(.sizeThatFits)
            .padding(20)
    }
}

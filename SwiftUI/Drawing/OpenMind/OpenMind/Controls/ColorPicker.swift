import SwiftUI

struct ColorPickerView: View {
    @State var pickedColor: ColorPicker.Color = .red
    var body: some View {
        VStack {
            Image("crayon")
                .font(.largeTitle)
                .foregroundColor(.teal)
            Circle()
                .foregroundColor(pickedColor.color)
                .padding(.horizontal, 50)
            ColorPicker(pickedColor: $pickedColor)
        }
    }
}
struct ColorPicker: View {
    let diameter = 40.0
    @Binding var pickedColor: Color
    var body: some View {
        HStack {
            ForEach(Color.allCases, id: \.self) { color in
                Circle()
                    .foregroundColor(color.color)
                    .frame(width: diameter, height: diameter)
                    .onTapGesture {
                        pickedColor = color
                    }
                    .overlay {
                        Circle()
                            .foregroundColor(SwiftUI.Color(uiColor: .systemBackground))
                            .frame(width: pickedColor == color ? diameter / 3 : 0)
                    }
            }
        }
        .frame(height: 3 * diameter)
    }
}

extension ColorPicker {
    enum Color: CaseIterable {
        case black, violet, blue, green, yellow, orange, red
        var color: SwiftUI.Color {
            SwiftUI.Color(uiColor: uiColor)
        }
        var uiColor: UIColor {
            switch self {
                
            case .black:
                return UIColor(named: "Black")!
            case .violet:
                return UIColor(named: "Violet")!
            case .blue:
                return UIColor(named: "Blue")!
            case .green:
                return UIColor(named: "Green")!
            case .yellow:
                return UIColor(named: "Yellow")!
            case .orange:
                return UIColor(named: "Orange")!
            case .red:
                return UIColor(named: "Red")!
            }
        }
    }
}
struct ColorPicker_Previews: PreviewProvider {
    static var previews: some View {
        ColorPickerView()
//            .preferredColorScheme(.dark)
    }
}

import SwiftUI

struct ColorSlider: View {
    @Binding var sliderValue: Double
    var range: ClosedRange<Double> = 0...1
    var colors: [Color] = [.black, .blue, .white]
    var body: some View {
        let gradient = LinearGradient(
            colors: colors,
            startPoint: .leading,
            endPoint: .trailing
        )
        
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                gradient
                    .cornerRadius(5)
                    .frame(height: 10)
                SliderCircleView(value: $sliderValue,
                                 range: range,
                                 sliderWidth: geometry.size.width)
            }
            .frame(
                width: geometry.size.width,
                height: geometry.size.height,
                alignment: .center
            )
        }
    }
}

extension ColorSlider {
    struct SliderCircleView: View {
        @Binding var value: Double
        let range: ClosedRange<Double>
        let sliderWidth: Double
        let diameter = 30.0
        @State private var offset: CGSize = .zero
        
        var sliderValue: Double {
            let percent = offset.width / (sliderWidth - diameter)
            let value = (range.upperBound - range.lowerBound) * percent + range.lowerBound
            return value
        }
        var body: some View {
            let drag = DragGesture()
                .onChanged {
                    offset.width = clampWidth($0.translation.width)
                    value = sliderValue
                }
            Circle()
                .foregroundColor(.white)
                .shadow(color: .gray, radius: 1)
                .frame(width: diameter, height: diameter)
                .gesture(drag)
                .offset(offset)
        }
        func clampWidth(_ translation: Double) -> Double {
            min(sliderWidth - diameter, max(0, offset.width + translation))
        }
    }
}
struct ColorSlider_Previews: PreviewProvider {
    @State static var sliderValue: Double = 0
    static var previews: some View {
        ColorSlider(sliderValue: $sliderValue)
            .padding(50)
            .background(.secondary)
    }
}

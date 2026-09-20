import SwiftUI

struct NiaNotificationDotView: View {
    let color: Color
    let size: CGFloat

    init(color: Color, size: CGFloat = 8) {
        self.color = color
        self.size = size
    }

    var body: some View {
        Circle()
            .fill(color)
            .frame(width: size, height: size)
    }
}

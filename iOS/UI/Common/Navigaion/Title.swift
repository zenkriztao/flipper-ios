import SwiftUI

struct Title: View {
    let title: String
    let description: String?

    init(_ title: String, description: String? = nil) {
        self.title = title
        self.description = description
    }

    var body: some View {
        VStack(spacing: 0) {
            Text(title)
                .lineLimit(1)
                .font(.system(size: 18, weight: .bold))
            if let description = description {
                Text(description)
                    .lineLimit(1)
                    .font(.system(size: 12, weight: .medium))
            }
        }
    }
}

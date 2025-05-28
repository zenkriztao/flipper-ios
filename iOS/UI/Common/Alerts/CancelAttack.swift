import SwiftUI

struct CancelAttackAlert: View {
    @Binding var isPresented: Bool
    var onAbort: () -> Void

    var body: some View {
        VStack(spacing: 24) {
            VStack(spacing: 4) {
                Text("Stop Keys Calculation?")
                    .font(.system(size: 14, weight: .bold))

                Text("You can restart it later")
                    .font(.system(size: 14, weight: .medium))
                    .multilineTextAlignment(.center)
                    .foregroundColor(.black40)
                    .padding(.horizontal, 12)
            }
            .padding(.top, 25)

            AlertButtons(
                isPresented: $isPresented,
                text: "Stop",
                cancel: "Continue"
            ) {
                onAbort()
            }
        }
    }
}

import ActivityKit
import WidgetKit
import SwiftUI
import Activity

struct LiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: UpdateActivityAttibutes.self) { context in
            LockScreenBanner(
                state: context.state,
                version: context.attributes.version
            )
            .padding(18)
            .activityBackgroundTint(.gray)
            .activitySystemActionForegroundColor(Color.orange)
        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.center) {
                    LockScreenBanner(
                        state: context.state,
                        version: context.attributes.version
                    )
                }
            } compactLeading: {
                CompactLeading()
            } compactTrailing: {
                CompactTrailing(state: context.state)
            } minimal: {
                CompactTrailing(state: context.state)
            }
        }
    }
}

struct ActivityWidgetLiveActivity_Previews: PreviewProvider {
    static let attributes = UpdateActivityAttibutes(version: .init(
        name: "1.0.0",
        channel: .beta))
    static let contentState = UpdateActivityAttibutes.ContentState
        .progress(.uploading(0.65))

    static var previews: some View {
        attributes
            .previewContext(contentState, viewKind: .dynamicIsland(.compact))
            .previewDisplayName("Compact Mode Progress")
        attributes
            .previewContext(contentState, viewKind: .dynamicIsland(.expanded))
            .previewDisplayName("Expanded Mode Progress")
        attributes
            .previewContext(contentState, viewKind: .dynamicIsland(.minimal))
            .previewDisplayName("Minimal Mode Progress")
        attributes
            .previewContext(contentState, viewKind: .content)
            .previewDisplayName("Notification with Progress")
    }
}

struct ActivityWidgetLiveActivity2_Previews: PreviewProvider {
    static let attributes = UpdateActivityAttibutes(version: .init(
        name: "1.0.0",
        channel: .beta))
    static let contentState = UpdateActivityAttibutes.ContentState
        .result(.started)

    static var previews: some View {
        attributes
            .previewContext(.result(.started), viewKind: .content)
            .previewDisplayName("Started Notification")
        attributes
            .previewContext(.result(.canceled), viewKind: .content)
            .previewDisplayName("Canceled Notification")
        attributes
            .previewContext(.result(.failed), viewKind: .content)
            .previewDisplayName("Failed Notification")
    }
}

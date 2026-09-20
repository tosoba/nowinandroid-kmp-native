import NiaKit
import SwiftUI

typealias AppStrings = AppSharedMR.strings
typealias BookmarksStrings = FeatureBookmarksApiMR.strings
typealias CoreUiStrings = CoreUiMR.strings
typealias ForYouStrings = FeatureForyouApiMR.strings
typealias InterestsStrings = FeatureInterestsApiMR.strings
typealias SearchStrings = FeatureSearchApiMR.strings
typealias TopicStrings = FeatureTopicApiMR.strings

extension String {
    init(_ resource: StringResource) {
        self.init(NiaResourcesKt.getString(stringResource: resource).localized())
    }

    init(_ resourceKeyPath: KeyPath<AppStrings, StringResource>) {
        self.init(NiaResourcesKt.getString(stringResource: AppStrings()[keyPath: resourceKeyPath]).localized())
    }

    init(_ resourceKeyPath: KeyPath<AppStrings, StringResource>, parameter: Any) {
        self.init(
            NiaResourcesKt.getString(
                stringResource: AppStrings()[keyPath: resourceKeyPath],
                parameter: parameter
            )
            .localized()
        )
    }

    init(_ resourceKeyPath: KeyPath<BookmarksStrings, StringResource>) {
        self.init(
            NiaResourcesKt.getString(
                stringResource: BookmarksStrings()[keyPath: resourceKeyPath]
            )
            .localized()
        )
    }

    init(_ resourceKeyPath: KeyPath<CoreUiStrings, StringResource>) {
        self.init(
            NiaResourcesKt.getString(stringResource: CoreUiStrings()[keyPath: resourceKeyPath])
                .localized()
        )
    }

    init(_ resourceKeyPath: KeyPath<CoreUiStrings, StringResource>, parameter: Any) {
        self.init(
            NiaResourcesKt.getString(
                stringResource: CoreUiStrings()[keyPath: resourceKeyPath],
                parameter: parameter
            )
            .localized()
        )
    }

    init(_ resourceKeyPath: KeyPath<ForYouStrings, StringResource>) {
        self.init(
            NiaResourcesKt.getString(stringResource: ForYouStrings()[keyPath: resourceKeyPath])
                .localized()
        )
    }

    init(_ resourceKeyPath: KeyPath<InterestsStrings, StringResource>) {
        self.init(
            NiaResourcesKt.getString(
                stringResource: InterestsStrings()[keyPath: resourceKeyPath]
            )
            .localized()
        )
    }

    init(_ resourceKeyPath: KeyPath<SearchStrings, StringResource>) {
        self.init(
            NiaResourcesKt.getString(stringResource: SearchStrings()[keyPath: resourceKeyPath])
                .localized()
        )
    }
    
    init(_ resourceKeyPath: KeyPath<SearchStrings, StringResource>, parameter: Any) {
        self.init(
            NiaResourcesKt.getString(
                stringResource: SearchStrings()[keyPath: resourceKeyPath],
                parameter: parameter
            )
            .localized()
        )
    }

    init(_ resourceKeyPath: KeyPath<TopicStrings, StringResource>) {
        self.init(
            NiaResourcesKt.getString(stringResource: TopicStrings()[keyPath: resourceKeyPath])
                .localized()
        )
    }
}

extension Image {
    init(_ resource: NiaKit.ImageResource) {
        self = Image(uiImage: resource.toUIImage() ?? UIImage()).renderingMode(.template)
    }
}

extension Label where Title == Text, Icon == Image {
    init(_ title: String, iconResource: NiaKit.ImageResource) {
        self.init(
            title: { Text(title) },
            icon: { Image(iconResource) }
        )
    }
}

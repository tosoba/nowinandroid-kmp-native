import NiaKit
import SwiftUI

typealias AppStrings = AppSharedMR.strings
typealias BookmarksStrings = FeatureBookmarksApiMR.strings
typealias CoreUiStrings = CoreUiMR.strings
typealias ForYouStrings = FeatureForyouApiMR.strings
typealias InterestsStrings = FeatureInterestsApiMR.strings
typealias SearchStrings = FeatureSearchApiMR.strings
typealias TopicStrings = FeatureTopicApiMR.strings

typealias BookmarksImages = FeatureBookmarksApiMR.images
typealias CoreDesignsystemImages = CoreDesignsystemMR.images
typealias ForYouImages = FeatureForyouApiMR.images

enum NiaResources {
    static let appStrings = AppStrings()
    static let bookmarksStrings = BookmarksStrings()
    static let coreUiStrings = CoreUiStrings()
    static let forYouStrings = ForYouStrings()
    static let interestsStrings = InterestsStrings()
    static let searchStrings = SearchStrings()
    static let topicStrings = TopicStrings()

    static let bookmarksImages = BookmarksImages()
    static let coreDesignsystemImages = CoreDesignsystemImages()
    static let forYouImages = ForYouImages()
}

extension String {
    init(_ resource: StringResource) {
        self.init(NiaResourcesKt.getString(stringResource: resource).localized())
    }

    init(_ resourceKeyPath: KeyPath<AppStrings, StringResource>) {
        self.init(
            NiaResourcesKt
                .getString(stringResource: NiaResources.appStrings[keyPath: resourceKeyPath])
                .localized()
        )
    }

    init(_ resourceKeyPath: KeyPath<AppStrings, StringResource>, parameter: Any) {
        self.init(
            NiaResourcesKt
                .getString(
                    stringResource: NiaResources.appStrings[keyPath: resourceKeyPath],
                    parameter: parameter
                )
                .localized()
        )
    }

    init(_ resourceKeyPath: KeyPath<BookmarksStrings, StringResource>) {
        self.init(
            NiaResourcesKt
                .getString(stringResource: NiaResources.bookmarksStrings[keyPath: resourceKeyPath])
                .localized()
        )
    }

    init(_ resourceKeyPath: KeyPath<CoreUiStrings, StringResource>) {
        self.init(
            NiaResourcesKt
                .getString(stringResource: NiaResources.coreUiStrings[keyPath: resourceKeyPath])
                .localized()
        )
    }

    init(_ resourceKeyPath: KeyPath<CoreUiStrings, StringResource>, parameter: Any) {
        self.init(
            NiaResourcesKt
                .getString(
                    stringResource: NiaResources.coreUiStrings[keyPath: resourceKeyPath],
                    parameter: parameter
                )
                .localized()
        )
    }

    init(_ resourceKeyPath: KeyPath<ForYouStrings, StringResource>) {
        self.init(
            NiaResourcesKt
                .getString(stringResource: NiaResources.forYouStrings[keyPath: resourceKeyPath])
                .localized()
        )
    }

    init(_ resourceKeyPath: KeyPath<InterestsStrings, StringResource>) {
        self.init(
            NiaResourcesKt
                .getString(
                    stringResource: NiaResources.interestsStrings[keyPath: resourceKeyPath]
                )
                .localized()
        )
    }

    init(_ resourceKeyPath: KeyPath<SearchStrings, StringResource>) {
        self.init(
            NiaResourcesKt
                .getString(stringResource: NiaResources.searchStrings[keyPath: resourceKeyPath])
                .localized()
        )
    }

    init(_ resourceKeyPath: KeyPath<SearchStrings, StringResource>, parameter: Any) {
        self.init(
            NiaResourcesKt
                .getString(
                    stringResource: NiaResources.searchStrings[keyPath: resourceKeyPath],
                    parameter: parameter
                )
                .localized()
        )
    }

    init(_ resourceKeyPath: KeyPath<TopicStrings, StringResource>) {
        self.init(
            NiaResourcesKt
                .getString(stringResource: NiaResources.topicStrings[keyPath: resourceKeyPath])
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

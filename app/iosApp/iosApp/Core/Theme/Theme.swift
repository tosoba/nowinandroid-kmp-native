import NiaKit
import SwiftUI

struct NiaThemeColors {
    let primary: Color
    let onPrimary: Color
    let primaryContainer: Color
    let onPrimaryContainer: Color
    let secondary: Color
    let onSecondary: Color
    let secondaryContainer: Color
    let onSecondaryContainer: Color
    let tertiary: Color
    let onTertiary: Color
    let tertiaryContainer: Color
    let onTertiaryContainer: Color
    let error: Color
    let onError: Color
    let errorContainer: Color
    let onErrorContainer: Color
    let background: Color
    let onBackground: Color
    let surface: Color
    let onSurface: Color
    let surfaceVariant: Color
    let onSurfaceVariant: Color
    let inverseSurface: Color
    let inverseOnSurface: Color
    let outline: Color
}

extension NiaThemeColors {
    static let light = NiaThemeColors(NiaIosThemeColors.shared.light)
    static let dark = NiaThemeColors(NiaIosThemeColors.shared.dark)
}

private extension NiaThemeColors {
    init(_ scheme: NiaIosColorScheme) {
        primary = Color(scheme.primary)
        onPrimary = Color(scheme.onPrimary)
        primaryContainer = Color(scheme.primaryContainer)
        onPrimaryContainer = Color(scheme.onPrimaryContainer)
        secondary = Color(scheme.secondary)
        onSecondary = Color(scheme.onSecondary)
        secondaryContainer = Color(scheme.secondaryContainer)
        onSecondaryContainer = Color(scheme.onSecondaryContainer)
        tertiary = Color(scheme.tertiary)
        onTertiary = Color(scheme.onTertiary)
        tertiaryContainer = Color(scheme.tertiaryContainer)
        onTertiaryContainer = Color(scheme.onTertiaryContainer)
        error = Color(scheme.error)
        onError = Color(scheme.onError)
        errorContainer = Color(scheme.errorContainer)
        onErrorContainer = Color(scheme.onErrorContainer)
        background = Color(scheme.background)
        onBackground = Color(scheme.onBackground)
        surface = Color(scheme.surface)
        onSurface = Color(scheme.onSurface)
        surfaceVariant = Color(scheme.surfaceVariant)
        onSurfaceVariant = Color(scheme.onSurfaceVariant)
        inverseSurface = Color(scheme.inverseSurface)
        inverseOnSurface = Color(scheme.inverseOnSurface)
        outline = Color(scheme.outline)
    }
}

private struct NiaThemeColorsKey: EnvironmentKey {
    static let defaultValue = NiaThemeColors.light
}

extension EnvironmentValues {
    var niaColors: NiaThemeColors {
        get { self[NiaThemeColorsKey.self] }
        set { self[NiaThemeColorsKey.self] = newValue }
    }
}

private struct NiaThemeModifier: ViewModifier {
    @Environment(\.colorScheme) private var colorScheme

    func body(content: Content) -> some View {
        let colors = colorScheme == .dark ? NiaThemeColors.dark : NiaThemeColors.light

        content
            .environment(\.niaColors, colors)
            .tint(colors.primary)
            .foregroundStyle(colors.onBackground)
            .background(colors.background.ignoresSafeArea())
    }
}

extension View {
    func niaTheme() -> some View {
        modifier(NiaThemeModifier())
    }
}

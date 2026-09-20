package com.skydoves.nowinandroid.core.designsystem.theme

import androidx.compose.ui.graphics.Color
import kotlinx.cinterop.DoubleVar
import kotlinx.cinterop.ExperimentalForeignApi
import kotlinx.cinterop.alloc
import kotlinx.cinterop.memScoped
import kotlinx.cinterop.ptr
import kotlinx.cinterop.value
import platform.UIKit.UIColor

@OptIn(ExperimentalForeignApi::class)
fun UIColor.toComposeColor(): Color = memScoped {
  val red = alloc<DoubleVar>()
  val green = alloc<DoubleVar>()
  val blue = alloc<DoubleVar>()
  val alpha = alloc<DoubleVar>()

  getRed(red = red.ptr, green = green.ptr, blue = blue.ptr, alpha = alpha.ptr)

  Color(
    red = red.value.toFloat(),
    green = green.value.toFloat(),
    blue = blue.value.toFloat(),
    alpha = alpha.value.toFloat(),
  )
}

fun Color.toUIColor(): UIColor =
  UIColor(
    red = red.toDouble(),
    green = green.toDouble(),
    blue = blue.toDouble(),
    alpha = alpha.toDouble(),
  )

class NiaIosColorScheme(
  val primary: UIColor,
  val onPrimary: UIColor,
  val primaryContainer: UIColor,
  val onPrimaryContainer: UIColor,
  val secondary: UIColor,
  val onSecondary: UIColor,
  val secondaryContainer: UIColor,
  val onSecondaryContainer: UIColor,
  val tertiary: UIColor,
  val onTertiary: UIColor,
  val tertiaryContainer: UIColor,
  val onTertiaryContainer: UIColor,
  val error: UIColor,
  val onError: UIColor,
  val errorContainer: UIColor,
  val onErrorContainer: UIColor,
  val background: UIColor,
  val onBackground: UIColor,
  val surface: UIColor,
  val onSurface: UIColor,
  val surfaceVariant: UIColor,
  val onSurfaceVariant: UIColor,
  val inverseSurface: UIColor,
  val inverseOnSurface: UIColor,
  val outline: UIColor,
)

object NiaIosThemeColors {
  val light =
    NiaIosColorScheme(
      primary = Purple40.toUIColor(),
      onPrimary = Color.White.toUIColor(),
      primaryContainer = Purple90.toUIColor(),
      onPrimaryContainer = Purple10.toUIColor(),
      secondary = Orange40.toUIColor(),
      onSecondary = Color.White.toUIColor(),
      secondaryContainer = Orange90.toUIColor(),
      onSecondaryContainer = Orange10.toUIColor(),
      tertiary = Blue40.toUIColor(),
      onTertiary = Color.White.toUIColor(),
      tertiaryContainer = Blue90.toUIColor(),
      onTertiaryContainer = Blue10.toUIColor(),
      error = Red40.toUIColor(),
      onError = Color.White.toUIColor(),
      errorContainer = Red90.toUIColor(),
      onErrorContainer = Red10.toUIColor(),
      background = DarkPurpleGray99.toUIColor(),
      onBackground = DarkPurpleGray10.toUIColor(),
      surface = DarkPurpleGray99.toUIColor(),
      onSurface = DarkPurpleGray10.toUIColor(),
      surfaceVariant = PurpleGray90.toUIColor(),
      onSurfaceVariant = PurpleGray30.toUIColor(),
      inverseSurface = DarkPurpleGray20.toUIColor(),
      inverseOnSurface = DarkPurpleGray95.toUIColor(),
      outline = PurpleGray50.toUIColor(),
    )

  val dark =
    NiaIosColorScheme(
      primary = Purple80.toUIColor(),
      onPrimary = Purple20.toUIColor(),
      primaryContainer = Purple30.toUIColor(),
      onPrimaryContainer = Purple90.toUIColor(),
      secondary = Orange80.toUIColor(),
      onSecondary = Orange20.toUIColor(),
      secondaryContainer = Orange30.toUIColor(),
      onSecondaryContainer = Orange90.toUIColor(),
      tertiary = Blue80.toUIColor(),
      onTertiary = Blue20.toUIColor(),
      tertiaryContainer = Blue30.toUIColor(),
      onTertiaryContainer = Blue90.toUIColor(),
      error = Red80.toUIColor(),
      onError = Red20.toUIColor(),
      errorContainer = Red30.toUIColor(),
      onErrorContainer = Red90.toUIColor(),
      background = DarkPurpleGray10.toUIColor(),
      onBackground = DarkPurpleGray90.toUIColor(),
      surface = DarkPurpleGray10.toUIColor(),
      onSurface = DarkPurpleGray90.toUIColor(),
      surfaceVariant = PurpleGray30.toUIColor(),
      onSurfaceVariant = PurpleGray80.toUIColor(),
      inverseSurface = DarkPurpleGray90.toUIColor(),
      inverseOnSurface = DarkPurpleGray10.toUIColor(),
      outline = PurpleGray60.toUIColor(),
    )
}

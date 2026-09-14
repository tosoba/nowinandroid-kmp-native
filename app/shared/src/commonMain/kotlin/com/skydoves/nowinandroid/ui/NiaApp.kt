/*
 * Designed and developed by 2026 skydoves (Jaewoong Eum)
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package com.skydoves.nowinandroid.ui

import androidx.compose.animation.AnimatedVisibility
import androidx.compose.animation.expandVertically
import androidx.compose.animation.shrinkVertically
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.WindowInsets
import androidx.compose.foundation.layout.consumeWindowInsets
import androidx.compose.foundation.layout.exclude
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.ime
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.safeDrawing
import androidx.compose.foundation.layout.windowInsetsPadding
import androidx.compose.material3.Icon
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Scaffold
import androidx.compose.material3.SnackbarDuration.Indefinite
import androidx.compose.material3.SnackbarHost
import androidx.compose.material3.SnackbarHostState
import androidx.compose.material3.Text
import androidx.compose.material3.TopAppBarDefaults
import androidx.compose.material3.adaptive.ExperimentalMaterial3AdaptiveApi
import androidx.compose.material3.adaptive.WindowAdaptiveInfo
import androidx.compose.material3.adaptive.currentWindowAdaptiveInfoV2
import androidx.compose.material3.adaptive.navigation3.rememberListDetailSceneStrategy
import androidx.compose.runtime.Composable
import androidx.compose.runtime.CompositionLocalProvider
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.saveable.rememberSaveable
import androidx.compose.runtime.setValue
import androidx.compose.ui.Modifier
import androidx.compose.ui.composed
import androidx.compose.ui.draw.drawWithContent
import androidx.compose.ui.geometry.Offset
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.platform.testTag
import androidx.compose.ui.unit.dp
import androidx.lifecycle.compose.collectAsStateWithLifecycle
import androidx.navigation3.runtime.entryProvider
import androidx.navigation3.ui.NavDisplay
import com.skydoves.nowinandroid.core.designsystem.component.NiaBackground
import com.skydoves.nowinandroid.core.designsystem.component.NiaGradientBackground
import com.skydoves.nowinandroid.core.designsystem.component.NiaNavigationSuiteScaffold
import com.skydoves.nowinandroid.core.designsystem.component.NiaTopAppBar
import com.skydoves.nowinandroid.core.designsystem.icon.NiaIcons
import com.skydoves.nowinandroid.core.designsystem.theme.GradientColors
import com.skydoves.nowinandroid.core.designsystem.theme.LocalGradientColors
import com.skydoves.nowinandroid.core.navigation.Navigator
import com.skydoves.nowinandroid.core.navigation.toEntries
import com.skydoves.nowinandroid.core.ui.platform.enableTestTagsAsResourceId
import com.skydoves.nowinandroid.feature.bookmarks.impl.navigation.LocalSnackbarHostState
import com.skydoves.nowinandroid.feature.bookmarks.impl.navigation.bookmarksEntry
import com.skydoves.nowinandroid.feature.foryou.api.navigation.ForYouNavKey
import com.skydoves.nowinandroid.feature.foryou.impl.navigation.forYouEntry
import com.skydoves.nowinandroid.feature.interests.impl.navigation.interestsEntry
import com.skydoves.nowinandroid.feature.search.api.navigation.SearchNavKey
import com.skydoves.nowinandroid.feature.search.impl.navigation.searchEntry
import com.skydoves.nowinandroid.feature.settings.impl.SettingsDialog
import com.skydoves.nowinandroid.feature.settings.impl.feature_settings_top_app_bar_action_icon_description
import com.skydoves.nowinandroid.feature.settings.impl.feature_settings_top_app_bar_navigation_icon_description
import com.skydoves.nowinandroid.feature.topic.impl.navigation.topicEntry
import com.skydoves.nowinandroid.navigation.TOP_LEVEL_NAV_ITEMS
import com.skydoves.nowinandroid.not_connected
import dev.icerock.moko.resources.compose.stringResource
import com.skydoves.nowinandroid.MR as Res
import com.skydoves.nowinandroid.feature.settings.impl.MR as SettingsRes

@Composable
fun NiaApp(
  appState: NiaAppState,
  modifier: Modifier = Modifier,
  windowAdaptiveInfo: WindowAdaptiveInfo = currentWindowAdaptiveInfoV2(),
) {
  val shouldShowGradientBackground = appState.navigationState.currentTopLevelKey == ForYouNavKey
  var showSettingsDialog by rememberSaveable { mutableStateOf(false) }

  NiaBackground(modifier = modifier) {
    NiaGradientBackground(
      gradientColors =
        if (shouldShowGradientBackground) {
          LocalGradientColors.current
        } else {
          GradientColors()
        }
    ) {
      val snackbarHostState = remember { SnackbarHostState() }
      val isOffline by appState.isOffline.collectAsStateWithLifecycle()
      val notConnectedMessage = stringResource(Res.strings.not_connected)
      LaunchedEffect(isOffline) {
        if (isOffline) {
          snackbarHostState.showSnackbar(
            message = notConnectedMessage,
            duration = Indefinite,
          )
        }
      }

      CompositionLocalProvider(LocalSnackbarHostState provides snackbarHostState) {
        NiaApp(
          appState = appState,
          showSettingsDialog = showSettingsDialog,
          onSettingsDismissed = { showSettingsDialog = false },
          onTopAppBarActionClick = { showSettingsDialog = true },
          windowAdaptiveInfo = windowAdaptiveInfo,
        )
      }
    }
  }
}

@Composable
@OptIn(ExperimentalMaterial3AdaptiveApi::class)
internal fun NiaApp(
  appState: NiaAppState,
  showSettingsDialog: Boolean,
  onSettingsDismissed: () -> Unit,
  onTopAppBarActionClick: () -> Unit,
  modifier: Modifier = Modifier,
  windowAdaptiveInfo: WindowAdaptiveInfo = currentWindowAdaptiveInfoV2(),
) {
  val unreadNavKeys by appState.topLevelNavKeysWithUnreadResources.collectAsStateWithLifecycle()

  if (showSettingsDialog) {
    SettingsDialog(onDismiss = { onSettingsDismissed() })
  }

  val snackbarHostState = LocalSnackbarHostState.current

  val navigator = remember { Navigator(appState.navigationState) }

  NiaNavigationSuiteScaffold(
    navigationSuiteItems = {
      TOP_LEVEL_NAV_ITEMS.forEach { (navKey, navItem) ->
        val hasUnread = unreadNavKeys.contains(navKey)
        val selected = navKey == appState.navigationState.currentTopLevelKey
        item(
          selected = selected,
          onClick = { navigator.navigate(navKey) },
          icon = {
            Icon(
              imageVector = navItem.unselectedIcon,
              contentDescription = null,
            )
          },
          selectedIcon = {
            Icon(
              imageVector = navItem.selectedIcon,
              contentDescription = null,
            )
          },
          label = { Text(stringResource(navItem.iconText)) },
          modifier =
            Modifier.testTag("NiaNavItem")
              .then(if (hasUnread) Modifier.notificationDot() else Modifier),
        )
      }
    },
    windowAdaptiveInfo = windowAdaptiveInfo,
  ) {
    Scaffold(
      modifier = modifier.enableTestTagsAsResourceId(),
      containerColor = Color.Transparent,
      contentColor = MaterialTheme.colorScheme.onBackground,
      snackbarHost = {
        SnackbarHost(
          snackbarHostState,
          modifier =
            Modifier.windowInsetsPadding(WindowInsets.safeDrawing.exclude(WindowInsets.ime)),
        )
      },
    ) { padding ->
      Column(modifier = Modifier.fillMaxSize().padding(padding).consumeWindowInsets(padding)) {
        AnimatedVisibility(
          appState.navigationState.currentKey in appState.navigationState.topLevelKeys,
          enter = expandVertically(),
          exit = shrinkVertically(),
        ) {
          val destination =
            TOP_LEVEL_NAV_ITEMS[appState.navigationState.currentTopLevelKey]
              ?: error(
                "Top level nav item not found for " +
                  "${appState.navigationState.currentTopLevelKey}"
              )

          NiaTopAppBar(
            titleRes = destination.titleText,
            navigationIcon = NiaIcons.Search,
            navigationIconContentDescription =
              stringResource(
                SettingsRes.strings.feature_settings_top_app_bar_navigation_icon_description
              ),
            actionIcon = NiaIcons.Settings,
            actionIconContentDescription =
              stringResource(
                SettingsRes.strings.feature_settings_top_app_bar_action_icon_description
              ),
            colors = TopAppBarDefaults.topAppBarColors(containerColor = Color.Transparent),
            onActionClick = { onTopAppBarActionClick() },
            onNavigationClick = { navigator.navigate(SearchNavKey) },
          )
        }

        val entryProvider = entryProvider {
          forYouEntry(navigator)
          bookmarksEntry(navigator)
          interestsEntry(navigator)
          topicEntry(navigator)
          searchEntry(navigator)
        }

        NavDisplay(
          entries = appState.navigationState.toEntries(entryProvider),
          sceneStrategies = listOf(rememberListDetailSceneStrategy()),
          onBack = { navigator.goBack() },
          modifier = Modifier.fillMaxWidth().weight(1f),
        )
      }
    }
  }
}

private fun Modifier.notificationDot(): Modifier = composed {
  val tertiaryColor = MaterialTheme.colorScheme.tertiary
  drawWithContent {
    drawContent()
    drawCircle(
      tertiaryColor,
      radius = 5.dp.toPx(),
      // This is based on the dimensions of the NavigationBar's "indicator pill";
      // however, its parameters are private, so we must depend on them implicitly
      // (NavigationBarTokens.ActiveIndicatorWidth = 64.dp)
      center =
        center +
          Offset(
            64.dp.toPx() * .45f,
            32.dp.toPx() * -.45f - 6.dp.toPx(),
          ),
    )
  }
}

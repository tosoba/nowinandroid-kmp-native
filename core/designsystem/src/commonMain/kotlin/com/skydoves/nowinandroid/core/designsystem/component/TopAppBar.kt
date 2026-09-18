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

package com.skydoves.nowinandroid.core.designsystem.component

import androidx.compose.material3.CenterAlignedTopAppBar
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.Icon
import androidx.compose.material3.IconButton
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Text
import androidx.compose.material3.TopAppBarColors
import androidx.compose.material3.TopAppBarDefaults
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.vector.ImageVector
import androidx.compose.ui.platform.testTag
import dev.icerock.moko.resources.ImageResource
import dev.icerock.moko.resources.compose.painterResource
import dev.icerock.moko.resources.compose.stringResource
import dev.icerock.moko.resources.StringResource

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun NiaTopAppBar(
  titleRes: StringResource,
  navigationIcon: ImageResource,
  navigationIconContentDescription: String,
  actionIcon: ImageResource,
  actionIconContentDescription: String,
  modifier: Modifier = Modifier,
  colors: TopAppBarColors = TopAppBarDefaults.topAppBarColors(),
  onNavigationClick: () -> Unit = {},
  onActionClick: () -> Unit = {},
) {
  CenterAlignedTopAppBar(
    title = { Text(text = stringResource(titleRes)) },
    navigationIcon = {
      IconButton(onClick = onNavigationClick) {
        Icon(
          painter = painterResource(navigationIcon),
          contentDescription = navigationIconContentDescription,
          tint = MaterialTheme.colorScheme.onSurface,
        )
      }
    },
    actions = {
      IconButton(onClick = onActionClick) {
        Icon(
          painter = painterResource(actionIcon),
          contentDescription = actionIconContentDescription,
          tint = MaterialTheme.colorScheme.onSurface,
        )
      }
    },
    colors = colors,
    modifier = modifier.testTag("niaTopAppBar"),
  )
}

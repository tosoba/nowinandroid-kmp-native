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

package com.skydoves.nowinandroid.core.designsystem.icon

import com.skydoves.nowinandroid.core.designsystem.CoreDesignsystemMR
import com.skydoves.nowinandroid.core.designsystem.ic_add
import com.skydoves.nowinandroid.core.designsystem.ic_arrow_back
import com.skydoves.nowinandroid.core.designsystem.ic_bookmark
import com.skydoves.nowinandroid.core.designsystem.ic_bookmark_border
import com.skydoves.nowinandroid.core.designsystem.ic_bookmarks
import com.skydoves.nowinandroid.core.designsystem.ic_bookmarks_border
import com.skydoves.nowinandroid.core.designsystem.ic_check
import com.skydoves.nowinandroid.core.designsystem.ic_close
import com.skydoves.nowinandroid.core.designsystem.ic_grid_3x3
import com.skydoves.nowinandroid.core.designsystem.ic_person
import com.skydoves.nowinandroid.core.designsystem.ic_search
import com.skydoves.nowinandroid.core.designsystem.ic_settings
import com.skydoves.nowinandroid.core.designsystem.ic_upcoming
import com.skydoves.nowinandroid.core.designsystem.ic_upcoming_border
import dev.icerock.moko.resources.ImageResource

/**
 * Now in Android icons. Every icon is a moko [ImageResource] backed by an SVG in
 * `src/commonMain/moko-resources/images`, so it renders in Compose via `painterResource` and is
 * available to native platforms (e.g. `UIImage` on iOS) from the generated `MR` class.
 */
object NiaIcons {
  val Add: ImageResource = CoreDesignsystemMR.images.ic_add
  val ArrowBack: ImageResource = CoreDesignsystemMR.images.ic_arrow_back
  val Bookmark: ImageResource = CoreDesignsystemMR.images.ic_bookmark
  val BookmarkBorder: ImageResource = CoreDesignsystemMR.images.ic_bookmark_border
  val Bookmarks: ImageResource = CoreDesignsystemMR.images.ic_bookmarks
  val BookmarksBorder: ImageResource = CoreDesignsystemMR.images.ic_bookmarks_border
  val Check: ImageResource = CoreDesignsystemMR.images.ic_check
  val Close: ImageResource = CoreDesignsystemMR.images.ic_close
  val Grid3x3: ImageResource = CoreDesignsystemMR.images.ic_grid_3x3
  val Person: ImageResource = CoreDesignsystemMR.images.ic_person
  val Search: ImageResource = CoreDesignsystemMR.images.ic_search
  val Settings: ImageResource = CoreDesignsystemMR.images.ic_settings
  val Upcoming: ImageResource = CoreDesignsystemMR.images.ic_upcoming
  val UpcomingBorder: ImageResource = CoreDesignsystemMR.images.ic_upcoming_border
}

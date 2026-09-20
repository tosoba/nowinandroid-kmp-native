package com.skydoves.nowinandroid.feature.bookmarks.impl

import androidx.lifecycle.viewModelScope
import com.skydoves.nowinandroid.core.ui.NewsFeedUiState
import kotlinx.coroutines.flow.launchIn
import kotlinx.coroutines.flow.onEach

class BookmarksViewModelWrapper(val wrapped: BookmarksViewModel) {
  fun observeFeedUiState(onChange: (NewsFeedUiState) -> Unit) {
    wrapped.feedUiState.onEach { onChange(it) }.launchIn(wrapped.viewModelScope)
  }

  val shouldDisplayUndoBookmark: Boolean
    get() = wrapped.shouldDisplayUndoBookmark
}

package com.skydoves.nowinandroid.feature.search.impl

import androidx.lifecycle.viewModelScope
import kotlinx.coroutines.flow.launchIn
import kotlinx.coroutines.flow.onEach

class SearchViewModelWrapper(val wrapped: SearchViewModel) {
  fun observeSearchQuery(onChange: (String) -> Unit) {
    wrapped.searchQuery.onEach { onChange(it) }.launchIn(wrapped.viewModelScope)
  }

  fun observeSearchResultUiState(onChange: (SearchResultUiState) -> Unit) {
    wrapped.searchResultUiState.onEach { onChange(it) }.launchIn(wrapped.viewModelScope)
  }

  fun observeRecentSearchQueriesUiState(onChange: (RecentSearchQueriesUiState) -> Unit) {
    wrapped.recentSearchQueriesUiState.onEach { onChange(it) }.launchIn(wrapped.viewModelScope)
  }
}

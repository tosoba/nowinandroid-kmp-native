package com.skydoves.nowinandroid.feature.interests.impl

import androidx.lifecycle.viewModelScope
import kotlinx.coroutines.flow.launchIn
import kotlinx.coroutines.flow.onEach

class InterestsViewModelWrapper(val wrapped: InterestsViewModel) {
  fun observeUiState(onChange: (InterestsUiState) -> Unit) {
    wrapped.uiState.onEach { onChange(it) }.launchIn(wrapped.viewModelScope)
  }
}

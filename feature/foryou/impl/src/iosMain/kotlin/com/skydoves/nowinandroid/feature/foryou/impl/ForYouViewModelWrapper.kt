package com.skydoves.nowinandroid.feature.foryou.impl

import androidx.lifecycle.viewModelScope
import com.skydoves.nowinandroid.core.model.data.UserNewsResource
import com.skydoves.nowinandroid.core.ui.NewsFeedUiState
import kotlinx.coroutines.flow.launchIn
import kotlinx.coroutines.flow.onEach

class ForYouViewModelWrapper(val wrapped: ForYouViewModel) {
  fun observeIsSyncing(onChange: (Boolean) -> Unit) {
    wrapped.isSyncing.onEach { onChange(it) }.launchIn(wrapped.viewModelScope)
  }

  fun observeDeepLinkedNewsResource(onChange: (UserNewsResource?) -> Unit) {
    wrapped.deepLinkedNewsResource.onEach { onChange(it) }.launchIn(wrapped.viewModelScope)
  }

  fun observeFeedState(onChange: (NewsFeedUiState) -> Unit) {
    wrapped.feedState.onEach { onChange(it) }.launchIn(wrapped.viewModelScope)
  }

  fun observeOnboardingUiState(onChange: (OnboardingUiState) -> Unit) {
    wrapped.onboardingUiState.onEach { onChange(it) }.launchIn(wrapped.viewModelScope)
  }
}

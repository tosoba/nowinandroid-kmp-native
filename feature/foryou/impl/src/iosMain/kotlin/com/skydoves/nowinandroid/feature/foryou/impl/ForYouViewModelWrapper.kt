package com.skydoves.nowinandroid.feature.foryou.impl

import androidx.lifecycle.viewModelScope
import kotlinx.coroutines.flow.launchIn
import kotlinx.coroutines.flow.onEach

class ForYouViewModelWrapper(val wrapped: ForYouViewModel) {
  fun observeIsSyncing(onChange: (Boolean) -> Unit) {
    wrapped.isSyncing.onEach { onChange(it) }.launchIn(wrapped.viewModelScope)
  }
}

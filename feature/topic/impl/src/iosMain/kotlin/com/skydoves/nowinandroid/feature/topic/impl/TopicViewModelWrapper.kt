package com.skydoves.nowinandroid.feature.topic.impl

import androidx.lifecycle.viewModelScope
import kotlinx.coroutines.flow.launchIn
import kotlinx.coroutines.flow.onEach

class TopicViewModelWrapper(val wrapped: TopicViewModel) {
  val topicId: String
    get() = wrapped.topicId

  fun observeTopicUiState(onChange: (TopicUiState) -> Unit) {
    wrapped.topicUiState.onEach { onChange(it) }.launchIn(wrapped.viewModelScope)
  }

  fun observeNewsUiState(onChange: (NewsUiState) -> Unit) {
    wrapped.newsUiState.onEach { onChange(it) }.launchIn(wrapped.viewModelScope)
  }
}

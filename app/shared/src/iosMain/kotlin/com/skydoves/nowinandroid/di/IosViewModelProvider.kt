package com.skydoves.nowinandroid.di

import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewmodel.CreationExtras
import com.skydoves.nowinandroid.feature.bookmarks.impl.BookmarksViewModel
import com.skydoves.nowinandroid.feature.foryou.impl.ForYouViewModel
import com.skydoves.nowinandroid.feature.interests.api.navigation.InterestsNavKey
import com.skydoves.nowinandroid.feature.interests.impl.InterestsViewModel
import com.skydoves.nowinandroid.feature.interests.impl.InterestsViewModel.Factory
import com.skydoves.nowinandroid.feature.search.impl.SearchViewModel
import com.skydoves.nowinandroid.feature.topic.impl.TopicViewModel
import kotlin.reflect.KClass

object IosViewModelProvider {
  fun createForYouViewModel() = create(ForYouViewModel::class)

  fun createBookmarksViewModel() = create(BookmarksViewModel::class)

  fun createSearchViewModel() = create(SearchViewModel::class)

  fun createInterestsViewModel(initialTopicId: String?): InterestsViewModel =
    appGraph.metroViewModelFactory
      .createManuallyAssistedFactory(Factory::class)
      .invoke()
      .create(InterestsNavKey(initialTopicId = initialTopicId))

  fun createTopicViewModel(topicId: String): TopicViewModel =
    appGraph.metroViewModelFactory
      .createManuallyAssistedFactory(TopicViewModel.Factory::class)
      .invoke()
      .create(topicId)

  private fun <T : ViewModel> create(modelClass: KClass<T>): T =
    appGraph.metroViewModelFactory.create(
      modelClass,
      CreationExtras.Empty,
    )
}

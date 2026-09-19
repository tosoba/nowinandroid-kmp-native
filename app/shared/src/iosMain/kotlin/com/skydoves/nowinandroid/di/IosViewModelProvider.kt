package com.skydoves.nowinandroid.di

import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewmodel.CreationExtras
import com.skydoves.nowinandroid.feature.foryou.impl.ForYouViewModel
import kotlin.reflect.KClass

object IosViewModelProvider {
  fun createForYouViewModel() = create(ForYouViewModel::class)

  private fun <T : ViewModel> create(modelClass: KClass<T>): T =
    appGraph.metroViewModelFactory.create(
      modelClass,
      CreationExtras.Empty,
    )
}


package com.skydoves.nowinandroid

import androidx.lifecycle.ViewModel
import androidx.lifecycle.ViewModelStore
import kotlin.uuid.ExperimentalUuidApi
import kotlin.uuid.Uuid

class IosViewModelStoreOwner {
  private val store = ViewModelStore()

  @OptIn(ExperimentalUuidApi::class)
  fun put(viewModel: ViewModel) {
    store.put(Uuid.generateV7().toString(), viewModel)
  }

  fun clear() {
    store.clear()
  }
}

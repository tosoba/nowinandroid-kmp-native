package com.skydoves.nowinandroid.ui

import dev.icerock.moko.resources.StringResource
import dev.icerock.moko.resources.desc.Resource
import dev.icerock.moko.resources.desc.ResourceFormatted
import dev.icerock.moko.resources.desc.StringDesc

fun getString(stringResource: StringResource): StringDesc = StringDesc.Resource(stringResource)

fun getString(stringResource: StringResource, parameter: Any): StringDesc =
  StringDesc.ResourceFormatted(stringResource, parameter)

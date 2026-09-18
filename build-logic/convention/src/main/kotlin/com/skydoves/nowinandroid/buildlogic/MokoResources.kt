package com.skydoves.nowinandroid.buildlogic

import dev.icerock.gradle.MRVisibility
import dev.icerock.gradle.MultiplatformResourcesPluginExtension
import org.gradle.api.Project
import org.gradle.kotlin.dsl.dependencies
import org.gradle.kotlin.dsl.getByType

/**
 * Every module that owns `moko-resources/` gets its own generated `MR` class, living under the
 * module's package. Without this they would all land on the same fully qualified name and the last
 * one to be compiled would win.
 */
internal fun Project.configureMokoResources() {
  val resources = extensions.getByType<MultiplatformResourcesPluginExtension>()
  resources.resourcesPackage.set(
    "com.skydoves.nowinandroid" + path.replace(":", ".").replace("-", "")
  )
  resources.resourcesVisibility.set(MRVisibility.Public)

  // Each module gets a unique generated class name instead of the default `MR`. Without this,
  // every exported `MR` collides on its simple ObjC name in the iOS framework header and
  // Kotlin/Native mangles them into unusable `MR_`, `MR__`, … names that also shift whenever
  // a module is added or removed. `:feature:foryou:api` becomes `FeatureForyouApiMR`, etc.
  resources.resourcesClassName.set(
    path.split(":").filter(String::isNotEmpty).joinToString("") { segment ->
      segment.split("-").joinToString("") { it.replaceFirstChar(Char::uppercaseChar) }
    } + "MR"
  )

  // The generated `MR` class references the moko runtime, and modules reach for the Compose
  // accessors of resources owned by their `api` dependencies, so both ship as `api`.
  dependencies {
    add("commonMainApi", libs.findLibrary("moko-resources").get())
    add("commonMainApi", libs.findLibrary("moko-resources-compose").get())
  }
}

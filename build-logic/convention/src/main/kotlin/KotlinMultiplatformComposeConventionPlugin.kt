/*
 * Designed and developed by 2026 skydoves (Jaewoong Eum)
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import com.skydoves.nowinandroid.buildlogic.configureMokoResources
import org.gradle.api.Plugin
import org.gradle.api.Project
import org.gradle.kotlin.dsl.configure
import org.jetbrains.kotlin.compose.compiler.gradle.ComposeCompilerGradlePluginExtension

class KotlinMultiplatformComposeConventionPlugin : Plugin<Project> {
  override fun apply(target: Project) {
    with(target) {
      pluginManager.apply("nowinandroid.kmp.multiplatform")
      pluginManager.apply("org.jetbrains.compose")
      pluginManager.apply("org.jetbrains.kotlin.plugin.compose")
      pluginManager.apply("dev.icerock.mobile.multiplatform-resources")

      extensions.configure<ComposeCompilerGradlePluginExtension> {
        reportsDestination.set(layout.buildDirectory.dir("compose_compiler"))
      }

      configureMokoResources()
    }
  }
}

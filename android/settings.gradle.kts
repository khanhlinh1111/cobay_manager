pluginManagement {
    val flutterSdkPath =
        run {
            val properties = java.util.Properties()
            file("local.properties").inputStream().use { properties.load(it) }
            val flutterSdkPath = properties.getProperty("flutter.sdk")
            require(flutterSdkPath != null) { "flutter.sdk not set in local.properties" }
            flutterSdkPath
        }

    includeBuild("$flutterSdkPath/packages/flutter_tools/gradle")

    repositories {
        google()
        mavenCentral()
        gradlePluginPortal()
    }
}

plugins {
    id("dev.flutter.flutter-plugin-loader") version "1.0.0"
    id("com.android.application") version "8.11.1" apply false
    id("org.jetbrains.kotlin.android") version "2.2.20" apply false
}

include(":app")

// Workaround for libraries not specifying namespace (AGP 8+)
gradle.lifecycle.beforeProject {
    if (file("src/main/AndroidManifest.xml").exists()) {
        try {
            val manifest = file("src/main/AndroidManifest.xml").readText()
            val packageNameRegex = "package=\"([^\"]+)\"".toRegex()
            val packageName = packageNameRegex.find(manifest)?.groupValues?.get(1)

            if (packageName != null) {
                extensions.configure<com.android.build.gradle.BaseExtension> {
                    if (namespace == null) {
                        namespace = packageName
                    }
                }
            }
        } catch (e: Exception) {
            // Ignore errors if extension configuration fails
        }
    }
}
// =====================================================================
// ===>> BLOCK GRADLE 2: Android Settings Configuration (Plugin Management) <<===
// =====================================================================

pluginManagement {
    val flutterSdkPath = run {
        val properties = java.util.Properties()
        val localPropertiesFile = file("local.properties")
        if (localPropertiesFile.exists()) {
            localPropertiesFile.reader(Charsets.UTF_8).use { reader ->
                properties.load(reader)
            }
        }
        properties.getProperty("flutter.sdk")
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
    id("com.android.application") version "8.1.0" apply false
    id("org.jetbrains.kotlin.android") version "1.8.22" apply false
}

include(":app")

// =====================================================================
// ===>> END OF BLOCK GRADLE 2 file : android/settings.gradle.kts <<===
// =====================================================================
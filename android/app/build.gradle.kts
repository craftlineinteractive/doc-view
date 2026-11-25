import java.util.Properties
import java.io.FileInputStream

plugins {
    id("com.android.application")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

val keystorePropertiesFile = rootProject.file("key.properties")
val keystoreProperties = Properties()
val hasKeyProperties = keystorePropertiesFile.exists()
if (hasKeyProperties) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}

val allowDebugSigning = project.hasProperty("allowDebugSigning") && project.property("allowDebugSigning") == "true"
val allowTestAdIds = project.hasProperty("allowTestAdIds") && project.property("allowTestAdIds") == "true"

// Google's public sample test App ID
val googleTestAppId = "ca-app-pub-3940256099942544~3347511713"
val configuredAdMobAppId: String = if (project.hasProperty("admobAppId")) {
    project.property("admobAppId") as String
} else {
    val localPropertiesFile = rootProject.file("local.properties")
    val localProps = Properties()
    if (localPropertiesFile.exists()) {
        localProps.load(FileInputStream(localPropertiesFile))
    }
    localProps.getProperty("admobAppId") ?: googleTestAppId
}

android {
    namespace = "com.craftlineinteractive.docview"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        isCoreLibraryDesugaringEnabled = true
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    signingConfigs {
        if (hasKeyProperties) {
            create("release") {
                keyAlias = keystoreProperties.getProperty("keyAlias")
                keyPassword = keystoreProperties.getProperty("keyPassword")
                storeFile = keystoreProperties.getProperty("storeFile")?.let { file(it) }
                storePassword = keystoreProperties.getProperty("storePassword")
            }
        }
    }

    defaultConfig {
        applicationId = "com.craftlineinteractive.docview"
        minSdk = 24
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
        manifestPlaceholders["admobAppId"] = configuredAdMobAppId
    }

    buildTypes {
        release {
            if (hasKeyProperties) {
                signingConfig = signingConfigs.getByName("release")
            } else if (allowDebugSigning) {
                signingConfig = signingConfigs.getByName("debug")
            } else {
                signingConfig = null
            }

            isMinifyEnabled = true
            isShrinkResources = true
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }
    }

    packaging {
        jniLibs {
            excludes += listOf(
                "lib/x86/**",
                "lib/armeabi-v7a/**"
            )
        }
    }
}

kotlin {
    compilerOptions {
        jvmTarget = org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17
    }
}

flutter {
    source = "../.."
}

dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")
}

// Release build safety verification checks
tasks.configureEach {
    if (name.contains("Release", ignoreCase = true) && (name.startsWith("bundle") || name.startsWith("assemble"))) {
        doFirst {
            if (!hasKeyProperties && !allowDebugSigning) {
                throw GradleException(
                    "RELEASE BUILD BLOCKED: android/key.properties was not found and -PallowDebugSigning=true was not specified. Release builds must not use debug keys silently. Provide android/key.properties or explicitly pass -PallowDebugSigning=true for test builds."
                )
            }
            if (configuredAdMobAppId == googleTestAppId && !allowTestAdIds) {
                throw GradleException(
                    "RELEASE BUILD BLOCKED: AdMob App ID is set to Google's public test App ID ($googleTestAppId). Release builds require a production admobAppId (via -PadmobAppId=... or ~/.gradle/gradle.properties or local.properties) or explicit pass of -PallowTestAdIds=true for test builds."
                )
            }
        }
    }
}

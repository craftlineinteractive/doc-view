# ProGuard / R8 Rules for Doc View Release

# Flutter & Engine Internals
-keepattributes *Annotation*
-keepattributes SourceFile,LineNumberTable
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

# Google Mobile Ads & UMP Consent
-keep class com.google.android.gms.ads.** { *; }
-keep class com.google.ads.** { *; }
-keep class com.google.android.ump.** { *; }

# InAppWebView & Offline Document Viewer
-keep class android.webkit.** { *; }
-keep class com.pichillilorenzo.flutter_inappwebview_android.** { *; }

# Play Billing
-keep class com.android.vending.billing.** { *; }
-keep class com.android.billingclient.api.** { *; }

# Failure justification: Flutter embedding PlayStoreDeferredComponentManager references optional
# Google Play Core splitinstall & tasks classes. Doc View does not use deferred components.
-dontwarn com.google.android.play.core.splitcompat.SplitCompatApplication
-dontwarn com.google.android.play.core.splitinstall.SplitInstallException
-dontwarn com.google.android.play.core.splitinstall.SplitInstallManager
-dontwarn com.google.android.play.core.splitinstall.SplitInstallManagerFactory
-dontwarn com.google.android.play.core.splitinstall.SplitInstallRequest$Builder
-dontwarn com.google.android.play.core.splitinstall.SplitInstallRequest
-dontwarn com.google.android.play.core.splitinstall.SplitInstallSessionState
-dontwarn com.google.android.play.core.splitinstall.SplitInstallStateUpdatedListener
-dontwarn com.google.android.play.core.tasks.OnFailureListener
-dontwarn com.google.android.play.core.tasks.OnSuccessListener
-dontwarn com.google.android.play.core.tasks.Task

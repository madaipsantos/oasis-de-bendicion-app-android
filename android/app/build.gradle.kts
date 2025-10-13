
import java.util.Properties

plugins {
    id("com.android.application")
    id("org.jetbrains.kotlin.android")
    id("dev.flutter.flutter-gradle-plugin")
}

val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("key.properties")
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(keystorePropertiesFile.inputStream())
}

android {
    namespace = "com.madai.webradiooasis" //Preciso alterar aqui!!
    compileSdkVersion(flutter.compileSdkVersion)
    ndkVersion = flutter.ndkVersion

    defaultConfig {
        applicationId = "com.madai.webradiooasis" //Preciso alterar aqui!!
        minSdkVersion(flutter.minSdkVersion)
        targetSdkVersion(flutter.targetSdkVersion)
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    signingConfigs {
        create("release") {
            storeFile = if (keystoreProperties["storeFile"] != null) file(keystoreProperties["storeFile"] as String) else null
            storePassword = keystoreProperties["storePassword"] as? String
            keyAlias = keystoreProperties["keyAlias"] as? String
            keyPassword = keystoreProperties["keyPassword"] as? String
        }
    }

    buildTypes {
        getByName("release") {
            signingConfig = signingConfigs.getByName("release")
            isMinifyEnabled = true // Or true for production
            isShrinkResources = true
            proguardFiles(getDefaultProguardFile("proguard-android.txt"), "proguard-rules.pro")
        }
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17 // Para Java 17
        targetCompatibility = JavaVersion.VERSION_17 // Para Java 17
    }

    kotlinOptions {
        jvmTarget = "17" // Java 17
    }
}

flutter {
    source = "../.."
}
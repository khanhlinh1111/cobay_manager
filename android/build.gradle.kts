allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}

// WORKAROUND: Fix lỗi thiếu namespace ở thư viện cũ (như isar_flutter_libs) khi dùng AGP 8
subprojects {
    afterEvaluate {
        // Kiểm tra xem project con này có phải là Android Library không
        if (project.plugins.hasPlugin("com.android.library")) {
            val android = project.extensions.getByName("android") as com.android.build.gradle.LibraryExtension
            // Nếu chưa có namespace thì tự tạo
            if (android.namespace == null) {
                val defaultNamespace = "com.example.${project.name.replace("-", "_")}"
                println("AUTO-FIX: Setting namespace for ${project.name} to $defaultNamespace")
                android.namespace = defaultNamespace
            }
        }
    }
}
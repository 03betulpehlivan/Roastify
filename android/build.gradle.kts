allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val rootBuildDir = rootProject.layout.projectDirectory.dir("../build")
rootProject.layout.buildDirectory.set(rootBuildDir)

subprojects {
    val newSubprojectBuildDir = rootBuildDir.dir(project.name)
    project.layout.buildDirectory.set(newSubprojectBuildDir)
}

subprojects {
    if (project.path != ":app") {
        evaluationDependsOn(":app")
    }
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}

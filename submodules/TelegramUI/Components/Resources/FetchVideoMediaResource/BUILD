load("@build_bazel_rules_swift//swift:swift.bzl", "swift_library")

swift_library(
    name = "FetchVideoMediaResource",
    module_name = "FetchVideoMediaResource",
    srcs = glob([
        "Sources/**/*.swift",
    ]),
    copts = [
        "-warnings-as-errors",
    ],
    deps = [
        "//submodules/TelegramUI/Components/MediaEditor",
        "//submodules/Postbox",
        "//submodules/SSignalKit/SSignalKit",
        "//submodules/SSignalKit/SwiftSignalKit",
        "//submodules/TelegramCore",
        "//submodules/LegacyComponents",
        "//submodules/FFMpegBinding",
        "//submodules/LocalMediaResources",
        "//submodules/LegacyMediaPickerUI",
    ],
    visibility = [
        "//visibility:public",
    ],
)

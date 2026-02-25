# Lean Build Status

**Goal:** Create a stripped-down Telegram iOS build with only essential features: basic chat, group chat, voice messages, and text input.

## Progress (2026-02-24)

### ✅ Successfully Removed (~230MB)

**Modules removed:**
- webrtc (131MB) + TelegramCallsUI + CallListUI + TgVoipWebrtc + TelegramVoip
- Stories components (2MB)
- Gifts components (2MB)  
- Stars components (1MB)
- PremiumUI (2MB)
- BotPaymentsUI (1MB)
- PassportUI (1MB)
- InstantPageUI (1MB)
- DrawingUI (1MB)
- Stripe (1MB)
- RMIntro (1MB)
- MediaEditor + MediaEditorScreen (2MB)
- Premium-related UI components (PremiumAlertController, PremiumLockButtonSubtitleComponent, etc.)

**Third-party libraries removed:**
- libvpx (26MB) - VP8/VP9 video codec
- openh264 (7MB) - H.264 video codec
- recaptcha (14MB) - ReCAPTCHA library
- libjxl (33MB) - JPEG XL image format

**BUILD file cleanup:**
- Removed all references to deleted modules from ~50+ BUILD files across submodules
- Cleaned up TelegramUI/BUILD, Telegram/BUILD, and component-level BUILD files

### 🚧 Current Blocker: ffmpeg Dependencies

**Problem:**
The `ffmpeg` BUILD file contains genrule targets that reference libvpx and openh264 in $(location) expressions:

```python
genrule(
    name = "libffmpeg_build",
    srcs = [
        "//third-party/libvpx:Public/vpx/vp8.h",  # <-- Missing
        "//third-party/openh264:...",             # <-- Missing
        # ... ffmpeg sources
    ],
    # ...
)
```

**Why it matters:**
- ffmpeg is **essential** for voice messages (audio encoding/decoding via Opus)
- Can't remove ffmpeg entirely
- Current build tightly couples ffmpeg with video codecs
- Removing deps causes Bazel analysis errors

**Attempted solutions:**
1. ❌ Simply deleting libvpx/openh264 references from deps → genrule fails (location expressions invalid)
2. ❌ Commenting out video codec deps → Build file syntax errors

**Why libvpx/openh264 were included:**
They were primarily for video calls (webrtc), which we've fully removed. ffmpeg may reference them for video container support, but that's not needed for audio-only voice messages.

### 🔍 Next Steps (Requires Deeper Investigation)

**Option 1: Stub targets (cleanest)**
Create empty BUILD targets for libvpx/openh264 that satisfy the ffmpeg genrule references without actual implementation:

```python
# third-party/libvpx/BUILD
filegroup(
    name = "Public/vpx/vp8.h",
    srcs = ["stub_vp8.h"],
    visibility = ["//visibility:public"],
)
```

**Option 2: Rewrite ffmpeg BUILD (more complex)**
Modify `submodules/ffmpeg/BUILD` to:
- Remove video codec configuration flags
- Remove $(location) references to libvpx/openh264
- Ensure audio codecs (Opus, AAC) still work

**Option 3: Keep minimal codecs (compromise)**
Restore just the header files from libvpx/openh264 (not the binaries) to satisfy build deps. Won't add much size back (~500KB).

**Option 4: Fork ffmpeg submodule (maintenance burden)**
Create a custom ffmpeg configuration with audio-only support, but this adds long-term maintenance complexity.

### 📊 Impact So Far

- **Disk space saved:** ~230MB
- **Build still broken:** Yes (ffmpeg genrule failure)
- **Custom commits preserved:** ✅ All 3 (USB mic fix, remove All topic tab, remove reaction button)
- **Branch:** `lean` (pushed to fork: hanxiao/Telegram-iOS)

### 🎯 Recommended Path Forward

1. **Short-term:** Implement Option 3 (keep codec headers only) to unblock the build
2. **Medium-term:** Investigate Option 1 (stub targets) for a cleaner solution
3. **Long-term:** Document ffmpeg build requirements and consider upstreaming audio-only configuration

### 📝 Files Changed

See commit: `Remove calls, stories, gifts, premium features and large unused codecs`

- ~20 top-level modules deleted
- ~50+ BUILD files modified
- third-party/ directory reduced from ~211MB to ~117MB
- submodules/ directory: removed ~8 UI modules

### ⚠️ Known Issues

1. Build currently fails at Bazel analysis phase (ffmpeg deps)
2. May need to restore some chat message UI components that depended on removed features (e.g., gift bubbles, premium indicators)
3. Runtime behavior unknown until build succeeds

### 🧪 Testing Checklist (Once Build Works)

- [ ] Basic 1-on-1 chat messaging
- [ ] Group chat messaging  
- [ ] Voice message recording (USB-C mic)
- [ ] Voice message playback
- [ ] Text input and sending
- [ ] Image preview (no editing, just viewing)
- [ ] No crashes on missing gift/stories/premium features

---

**Last updated:** 2026-02-24
**Branch:** `lean`
**Estimated compilation time improvement:** TBD (pending successful build)

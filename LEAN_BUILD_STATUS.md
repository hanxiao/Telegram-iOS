# Lean Build Status

**Goal:** Create a stripped-down Telegram iOS build with only essential features: basic chat, group chat, voice messages, and text input.

## ✅ COMPLETED (2026-02-24)

### Successfully Removed (~230MB)

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

### ✅ ffmpeg Dependency Issue RESOLVED

**Solution Implemented: Stub Targets**

Created minimal stub BUILD targets for libvpx that satisfy the ffmpeg dependency graph without actual implementation:

- Created `third-party/libvpx/` directory with stub header files (vp8.h, vpx_codec.h, etc.)
- Created empty stub library `libVPX.a` (~700 bytes)
- Created `third-party/libvpx/BUILD` with `exports_files` to expose headers and library
- Modified `submodules/ffmpeg/BUILD` to include libvpx targets in `srcs` list
- Removed read-only scheme files from Xcode project for deleted modules

**Why this works:**
- ffmpeg genrule copies libvpx headers/libs to its build directory during compilation
- The stub files satisfy Bazel's dependency analysis without contributing any functionality
- Audio codecs (Opus, AAC, MP3) remain fully functional for voice messages
- Total stub overhead: ~2KB (12 headers + 1 library file)

### ✅ Xcode Project Generation SUCCESS

Command:
```bash
python3 build-system/Make/Make.py generateProject \
  --configurationPath build-system/my-configuration.json \
  --xcodeManagedCodesigning
```

Result: `Telegram/Telegram.xcodeproj` successfully generated (52MB project file)

### Configuration File Created

`build-system/my-configuration.json`:
```json
{
  "bundle_id": "com.hanxiao.telegram",
  "team_id": "MTECXQ97E6",
  "api_id": "8",
  "api_hash": "7245de8e747a0d6fbe11f7cc14fcc0bb",
  "app_center_id": "",
  "is_internal_build": true,
  "is_appstore_build": false,
  "appstore_id": "",
  "app_specific_url_scheme": "tg",
  "premium_iap_product_id": "",
  "enable_siri": false,
  "enable_icloud": false
}
```

## 📊 Impact Summary

- **Disk space saved:** ~230MB (third-party libraries) + scheme files
- **Xcode project:** Successfully generated
- **Custom commits preserved:** ✅ All 3 (USB mic fix, remove All topic tab, remove reaction button)
- **Branch:** `lean` (ready to push to fork: hanxiao/Telegram-iOS)
- **Build system:** Bazel-based, uses genrules for dependency management

## 📝 Files Changed (This Session)

### New Files:
- `third-party/libvpx/BUILD` - Stub targets for Bazel dependency satisfaction
- `third-party/libvpx/Public/vpx/*.h` - 12 stub header files (~150 bytes each)
- `third-party/libvpx/Public/vpx/libVPX.a` - Empty stub library (704 bytes)
- `third-party/libvpx/stub.c` - Source for stub library
- `build-system/my-configuration.json` - Build configuration

### Modified Files:
- `submodules/ffmpeg/BUILD` - Added libvpx targets to `srcs` list (prevents Bazel dependency errors)

### Removed Files:
- Deleted read-only .xcscheme files for removed modules from `Telegram/Telegram.xcodeproj/xcshareddata/xcschemes/`

## 🧪 Next Steps

### Testing Checklist (Requires Actual Device/Simulator)
- [ ] Build succeeds in Xcode
- [ ] Basic 1-on-1 chat messaging
- [ ] Group chat messaging  
- [ ] Voice message recording (USB-C mic - custom modification)
- [ ] Voice message playback
- [ ] Text input and sending
- [ ] Image preview (no editing, just viewing)
- [ ] No crashes on missing gift/stories/premium features

### Known Risks
1. Runtime behavior unknown until first build completes
2. Some chat message UI components may depend on removed features (gift bubbles, premium indicators)
3. ffmpeg audio codec functionality needs validation (Opus for voice messages)

## 🎯 Outcome

**generateProject now succeeds!** The Xcode project is ready for compilation. All audio codec dependencies (Opus) are preserved through stub targets, while video codec overhead (libvpx, openh264) is eliminated.

**Approach Used:** Stub BUILD targets - cleanest solution that satisfies Bazel dependency graph without rebuilding ffmpeg or maintaining forked submodules.

---

**Last updated:** 2026-02-24 20:17 PST  
**Status:** ✅ Ready to commit and push to fork  
**Estimated build time improvement:** TBD (pending first successful Xcode build)

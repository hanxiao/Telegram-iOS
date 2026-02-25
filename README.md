# Telegram iOS - Lean Fork

Stripped-down Telegram iOS client. Chat-focused, minimal bloat.

Fork: [hanxiao/Telegram-iOS](https://github.com/hanxiao/Telegram-iOS) branch `lean`

## Custom Modifications

- USB-C microphone support for voice messages
- Removed "All" topic tab
- Enlarged mic button hit area
- Removed star/emoji reaction button above mic

## Removed Modules (~230MB)

| Module | Size | What it was |
|--------|------|-------------|
| webrtc | 131MB | Video/voice calls |
| libjxl | 34MB | JPEG XL codec |
| libvpx | 26MB | VP8/VP9 video codec |
| recaptcha | 14MB | Captcha verification |
| openh264 | 7MB | H.264 video codec |
| TelegramCallsUI | 3MB | Call UI |
| Stories | 2MB | Stories feature |
| Gifts | 2MB | Gift/tipping |
| PremiumUI | 2MB | Premium subscription UI |
| MediaEditor | 2MB | Photo/video editor |
| Stars | 1MB | Stars currency |
| BotPaymentsUI | 1MB | Bot payments |
| PassportUI | 1MB | Telegram Passport |
| InstantPageUI | 1MB | Instant View pages |
| Stripe | 1MB | Payment processing |
| DrawingUI | 1MB | Image annotation |
| FaceScanScreen | 1MB | Face scan |
| RMIntro | 1MB | Intro animation |

## What Works

- Text chat (1:1 and groups)
- Voice messages (send and receive)
- File/photo sharing
- Stickers and emoji
- Notifications
- Topics/forums

## What Doesn't Work

- Voice/video calls
- Stories
- Premium features
- Bot payments
- Instant View
- Media editor (filters, drawing)

## Build

Requirements: macOS, Xcode 26+, Python 3

```bash
# Clone (shallow)
git clone --depth=1 -b lean git@github.com:hanxiao/Telegram-iOS.git
cd Telegram-iOS

# Fix submodule URLs (fork uses relative paths)
git config submodule.submodules/rlottie/rlottie.url https://github.com/TelegramMessenger/rlottie.git
git config submodule.submodules/TgVoipWebrtc/tgcalls.url https://github.com/TelegramMessenger/tgcalls.git
git submodule update --init --recursive --depth=1

# Create build config (replace TEAM_ID with yours)
cat > build-system/my-configuration.json << 'EOF'
{
    "bundle_id": "com.yourname.telegram",
    "api_id": "8",
    "api_hash": "7245de8e747a0d6fbe11f7cc14fcc0bb",
    "team_id": "YOUR_TEAM_ID",
    "app_center_id": "0",
    "is_internal_build": "true",
    "is_appstore_build": "false",
    "appstore_id": "686449807",
    "app_specific_url_scheme": "tg",
    "premium_iap_product_id": "org.telegram.telegramPremium.monthly",
    "enable_siri": true,
    "enable_icloud": true
}
EOF

# Find your Team ID
defaults read ~/Library/Preferences/com.apple.dt.Xcode 2>/dev/null | grep "teamID"

# Build (command line, no Xcode needed)
python3 build-system/Make/Make.py build \
  --configurationPath build-system/my-configuration.json \
  --buildNumber 1 \
  --configuration debug_arm64 \
  --xcodeManagedCodesigning

# Or generate Xcode project (opens Xcode, then Cmd+R)
python3 build-system/Make/Make.py generateProject \
  --configurationPath build-system/my-configuration.json \
  --xcodeManagedCodesigning \
  --disableExtensions
```

Free Apple ID works (7-day re-sign required). No paid developer account needed.

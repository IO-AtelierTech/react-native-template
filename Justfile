# React Native Template - Development Commands
# Usage: just <recipe>

# Android SDK path (for Waydroid compatibility)
android_sdk := env_var_or_default("ANDROID_HOME", home_directory() / "Android/Sdk")

# App package name (change this for your project)
APP_PKG := env_var_or_default("APP_PKG", "com.template.app")

# Set environment
set export
ANDROID_HOME := android_sdk
PATH := android_sdk / "platform-tools:" + env_var("PATH")

# Default - show available commands
default:
    @just --list

# ─────────────────────────────────────────────────────────────
# Metro Bundler
# ─────────────────────────────────────────────────────────────

# Start Metro dev server (foreground)
dev:
    npx expo start

# Start Metro with cache cleared
dev-clean:
    npx expo start --clear

# Start Metro in tunnel mode (for remote devices)
dev-tunnel:
    npx expo start --tunnel

# Start Metro in background
metro-bg:
    @echo "Starting Metro bundler in background..."
    npx expo start --port 8081 > /tmp/metro.log 2>&1 &
    @echo "Metro logs: /tmp/metro.log"
    @sleep 5
    @curl -s http://localhost:8081/status > /dev/null && echo "✓ Metro started!" || echo "⏳ Metro may still be starting..."

# Stop Metro bundler
metro-stop:
    @echo "Stopping Metro bundler..."
    -@pkill -f "expo start" 2>/dev/null
    @echo "Metro stopped."

# View Metro logs (live)
metro-logs:
    @tail -f /tmp/metro.log

# ─────────────────────────────────────────────────────────────
# Native Builds
# ─────────────────────────────────────────────────────────────

# Build and run on Android
run-android:
    npx expo run:android

# Build and run on iOS simulator
run-ios:
    npx expo run:ios

# Generate native projects
prebuild:
    npx expo prebuild

# Regenerate native projects (clean)
prebuild-clean:
    npx expo prebuild --clean

# ─────────────────────────────────────────────────────────────
# Code Quality
# ─────────────────────────────────────────────────────────────

# Run all checks (lint + format + typecheck + test)
check: lint format-check typecheck test

# Run ESLint
lint:
    npm run lint

# Run ESLint with auto-fix
lint-fix:
    npm run lint:fix

# Check formatting with Prettier
format-check:
    npm run format:check

# Format code with Prettier
format:
    npm run format

# Run TypeScript type check
typecheck:
    npm run typecheck

# Fix all auto-fixable issues
fix: lint-fix format

# ─────────────────────────────────────────────────────────────
# Testing
# ─────────────────────────────────────────────────────────────

# Run all tests
test:
    npm test

# Run tests in watch mode
test-watch:
    npm run test:watch

# Run tests with coverage
test-coverage:
    npm run test:coverage

# Run CI checks
ci:
    npm run ci

# ─────────────────────────────────────────────────────────────
# Database (Docker + Drizzle)
# ─────────────────────────────────────────────────────────────

# Start PostgreSQL database
db-up:
    docker compose up -d postgres

# Stop PostgreSQL database
db-down:
    docker compose down

# View database logs
db-logs:
    docker compose logs -f postgres

# Connect to database with psql
db-shell:
    docker compose exec postgres psql -U postgres -d template_db

# Reset database (WARNING: destroys all data)
db-reset:
    docker compose down -v && docker compose up -d postgres

# Generate migration from schema changes
db-generate:
    npm run db:generate

# Apply pending migrations
db-migrate:
    npm run db:migrate

# Push schema directly (dev only)
db-push:
    npm run db:push

# Open Drizzle Studio
db-studio:
    npm run db:studio

# ─────────────────────────────────────────────────────────────
# EAS Cloud Builds
# ─────────────────────────────────────────────────────────────

# Development build - Android
eas-dev-android:
    eas build --profile development --platform android

# Development build - iOS
eas-dev-ios:
    eas build --profile development --platform ios

# Development build - All platforms
eas-dev:
    eas build --profile development --platform all

# Preview build - Android
eas-preview-android:
    eas build --profile preview --platform android

# Preview build - iOS
eas-preview-ios:
    eas build --profile preview --platform ios

# Production build - Android
eas-prod-android:
    eas build --profile production --platform android

# Production build - iOS
eas-prod-ios:
    eas build --profile production --platform ios

# Production build - All platforms
eas-prod:
    eas build --profile production --platform all

# ─────────────────────────────────────────────────────────────
# Dependencies & Cleanup
# ─────────────────────────────────────────────────────────────

# Install dependencies
install:
    yarn install

# Clean install (remove node_modules first)
install-clean:
    rm -rf node_modules && yarn install

# Clean build caches
clean:
    rm -rf node_modules/.cache
    rm -rf android/.gradle 2>/dev/null || true
    rm -rf android/app/build 2>/dev/null || true
    rm -rf .expo 2>/dev/null || true
    @echo "Caches cleared."

# Show project info
info:
    npx expo-env-info

# ─────────────────────────────────────────────────────────────
# Waydroid (Linux Android Emulator)
# ─────────────────────────────────────────────────────────────

# Full Waydroid setup (start + connect + ports)
waydroid-setup: waydroid-start
    @sleep 3
    @just adb-connect
    @sleep 1
    @just adb-ports

# Start Waydroid container session
waydroid-start:
    #!/usr/bin/env bash
    echo "Starting Waydroid session..."
    if waydroid status 2>/dev/null | grep -q "RUNNING"; then
        echo "Waydroid already running"
    else
        waydroid session start &
        sleep 5
        if waydroid status 2>/dev/null | grep -q "RUNNING"; then
            echo "✓ Waydroid started"
        else
            echo "⏳ Waydroid still starting..."
            sleep 5
        fi
    fi

# Stop Waydroid session
waydroid-stop:
    @echo "Stopping Waydroid session..."
    waydroid session stop

# Check Waydroid status
waydroid-status:
    @waydroid status

# ─────────────────────────────────────────────────────────────
# ADB / Device Connection
# ─────────────────────────────────────────────────────────────

# Connect ADB to Waydroid
adb-connect:
    #!/usr/bin/env bash
    echo "Connecting ADB to Waydroid..."
    WAYDROID_IP=$(waydroid status 2>/dev/null | grep -oP 'IP address:\s*\K[\d.]+' || echo "192.168.240.112")
    if [ -z "$WAYDROID_IP" ] || [ "$WAYDROID_IP" = "192.168.240.112" ]; then
        if ! waydroid status &>/dev/null; then
            echo "Warning: Waydroid may not be running. Start it first with: just waydroid-start"
        fi
        WAYDROID_IP="192.168.240.112"
    fi
    adb connect "$WAYDROID_IP:5555"
    echo "Connected to $WAYDROID_IP:5555"

# Set up ADB reverse port forwarding
adb-ports:
    #!/usr/bin/env bash
    echo "Setting up ADB reverse port forwarding..."
    DEVICE=$(adb devices | grep -oP '[\d.]+:5555' | head -1)
    if [ -z "$DEVICE" ]; then
        echo "No device connected. Run: just adb-connect"
        exit 1
    fi
    adb -s "$DEVICE" reverse tcp:8081 tcp:8081
    echo "  ✓ Port 8081 (Metro bundler)"
    adb -s "$DEVICE" reverse tcp:3000 tcp:3000
    echo "  ✓ Port 3000 (API server)"
    echo ""
    echo "Port forwarding complete!"

# Restart ADB server (fixes connection issues)
adb-restart:
    @echo "Restarting ADB server..."
    adb kill-server
    adb start-server
    @echo "ADB restarted. Run 'just adb-connect' to reconnect."

# List connected devices
adb-devices:
    adb devices

# ─────────────────────────────────────────────────────────────
# App Control (on device)
# ─────────────────────────────────────────────────────────────

# Launch app on device
app-launch:
    #!/usr/bin/env bash
    DEVICE=$(adb devices | grep -oP '[\d.]+:5555' | head -1)
    if [ -z "$DEVICE" ]; then
        echo "No device connected. Run: just adb-connect"
        exit 1
    fi
    echo "Launching app..."
    adb -s "$DEVICE" shell am start -n {{APP_PKG}}/.MainActivity

# Restart app (force stop + launch)
app-restart:
    #!/usr/bin/env bash
    DEVICE=$(adb devices | grep -oP '[\d.]+:5555' | head -1)
    if [ -z "$DEVICE" ]; then
        echo "No device connected. Run: just adb-connect"
        exit 1
    fi
    echo "Restarting app..."
    adb -s "$DEVICE" shell am force-stop {{APP_PKG}}
    sleep 1
    adb -s "$DEVICE" shell am start -n {{APP_PKG}}/.MainActivity
    echo "App restarted!"

# Clear app data (fixes state/login issues)
app-clear:
    #!/usr/bin/env bash
    DEVICE=$(adb devices | grep -oP '[\d.]+:5555' | head -1)
    if [ -z "$DEVICE" ]; then
        echo "No device connected. Run: just adb-connect"
        exit 1
    fi
    echo "Clearing app data..."
    adb -s "$DEVICE" shell pm clear {{APP_PKG}}
    echo "App data cleared. Run 'just app-launch' to restart."

# Install APK from path
app-install APK_PATH:
    #!/usr/bin/env bash
    DEVICE=$(adb devices | grep -oP '[\d.]+:5555' | head -1)
    if [ -z "$DEVICE" ]; then
        echo "No device connected. Run: just adb-connect"
        exit 1
    fi
    echo "Installing APK..."
    adb -s "$DEVICE" install "{{APK_PATH}}"

# Take a screenshot from device
app-screenshot:
    #!/usr/bin/env bash
    DEVICE=$(adb devices | grep -oP '[\d.]+:5555' | head -1)
    TIMESTAMP=$(date +%Y%m%d_%H%M%S)
    FILEPATH="/tmp/screenshot_$TIMESTAMP.png"
    adb -s "$DEVICE" exec-out screencap -p > "$FILEPATH"
    echo "Screenshot saved to $FILEPATH"

# ─────────────────────────────────────────────────────────────
# Status & Troubleshooting
# ─────────────────────────────────────────────────────────────

# Check all service statuses
status:
    #!/usr/bin/env bash
    echo "=== Service Status ==="
    echo ""
    # Metro
    if curl -s http://localhost:8081/status > /dev/null 2>&1; then
        echo "✓ Metro (8081):       Running"
    else
        echo "✗ Metro (8081):       Not running"
    fi
    # Waydroid
    if waydroid status 2>/dev/null | grep -q "RUNNING"; then
        echo "✓ Waydroid:           Running"
    else
        echo "✗ Waydroid:           Not running"
    fi
    # ADB
    DEVICE=$(adb devices 2>/dev/null | grep -oP '[\d.]+:5555' | head -1)
    if [ -n "$DEVICE" ]; then
        echo "✓ ADB:                Connected ($DEVICE)"
        if adb -s "$DEVICE" reverse --list 2>/dev/null | grep -q "8081"; then
            echo "✓ Port Forwarding:    Configured"
        else
            echo "⚠ Port Forwarding:    Not configured (run: just adb-ports)"
        fi
    else
        echo "✗ ADB:                Not connected"
    fi
    echo ""

# Kill ALL processes on dev ports (nuclear option)
kill-ports:
    #!/usr/bin/env bash
    echo "Killing all processes on development ports..."
    pkill -f "expo start" 2>/dev/null || true
    pkill -f "metro" 2>/dev/null || true
    fuser -k 8081/tcp 2>/dev/null || true
    fuser -k 3000/tcp 2>/dev/null || true
    sleep 1
    echo ""
    echo "Port status:"
    echo "  8081 (Metro): $(lsof -ti:8081 >/dev/null 2>&1 && echo 'IN USE' || echo 'free')"
    echo "  3000 (API):   $(lsof -ti:3000 >/dev/null 2>&1 && echo 'IN USE' || echo 'free')"
    echo ""
    echo "Ready to restart services."

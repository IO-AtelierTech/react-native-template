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
# Development
# ─────────────────────────────────────────────────────────────

# Start Expo development server
dev:
    npx expo start

# Start with cache cleared
dev-clean:
    npx expo start --clear

# Start in tunnel mode (for remote devices)
dev-tunnel:
    npx expo start --tunnel

# ─────────────────────────────────────────────────────────────
# Build
# ─────────────────────────────────────────────────────────────

# Run on Android (Waydroid compatible)
android:
    npx expo run:android

# Run on iOS simulator
ios:
    npx expo run:ios

# Prebuild native projects
prebuild:
    npx expo prebuild

# Prebuild with clean
prebuild-clean:
    npx expo prebuild --clean

# ─────────────────────────────────────────────────────────────
# Code Quality
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

# Run all checks (lint + format + typecheck + test)
check: lint format-check typecheck test

# Run CI checks
ci:
    npm run ci

# Fix all auto-fixable issues
fix: lint-fix format

# ─────────────────────────────────────────────────────────────
# Database (Docker)
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

# ─────────────────────────────────────────────────────────────
# Drizzle ORM
# ─────────────────────────────────────────────────────────────

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
# EAS Build (Cloud Builds)
# ─────────────────────────────────────────────────────────────

# Development build for Android
eas-dev-android:
    eas build --profile development --platform android

# Development build for iOS
eas-dev-ios:
    eas build --profile development --platform ios

# Preview build for Android (internal distribution)
eas-preview-android:
    eas build --profile preview --platform android

# Preview build for iOS (internal distribution)
eas-preview-ios:
    eas build --profile preview --platform ios

# Production build for Android
eas-prod-android:
    eas build --profile production --platform android

# Production build for iOS
eas-prod-ios:
    eas build --profile production --platform ios

# Build both platforms (development)
eas-dev-all:
    eas build --profile development --platform all

# Build both platforms (production)
eas-prod-all:
    eas build --profile production --platform all

# ─────────────────────────────────────────────────────────────
# Dependencies
# ─────────────────────────────────────────────────────────────

# Install dependencies
install:
    yarn install

# Clean install
clean-install:
    rm -rf node_modules && yarn install

# ─────────────────────────────────────────────────────────────
# Utilities
# ─────────────────────────────────────────────────────────────

# Clear Metro cache
clear-cache:
    npx expo start --clear

# Deep clean (all caches)
deep-clean:
    rm -rf node_modules/.cache
    rm -rf android/.gradle 2>/dev/null || true
    rm -rf android/app/build 2>/dev/null || true
    @echo "Caches cleared. Run 'just install' to reinstall."

# Show project info
info:
    npx expo-env-info

# ─────────────────────────────────────────────────────────────
# Waydroid Management (Linux Android Emulator)
# ─────────────────────────────────────────────────────────────

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

# Full Waydroid setup (start + connect + ports)
waydroid-setup: waydroid-start
    @sleep 3
    @just adb-connect
    @sleep 1
    @just adb-ports

# ─────────────────────────────────────────────────────────────
# ADB / Device Management
# ─────────────────────────────────────────────────────────────

# List connected devices (including Waydroid)
devices:
    adb devices

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
    echo "Port forwarding complete! App can now reach localhost services."

# Restart ADB server (fixes connection issues)
adb-restart:
    @echo "Restarting ADB server..."
    adb kill-server
    adb start-server
    @echo "ADB restarted. Run 'just adb-connect' to reconnect."

# ─────────────────────────────────────────────────────────────
# App Management
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

# Clear app data (fixes corrupted state, login issues)
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

# Force stop and restart app (reload with fresh state)
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
screenshot:
    #!/usr/bin/env bash
    DEVICE=$(adb devices | grep -oP '[\d.]+:5555' | head -1)
    TIMESTAMP=$(date +%Y%m%d_%H%M%S)
    FILEPATH="/tmp/screenshot_$TIMESTAMP.png"
    adb -s "$DEVICE" exec-out screencap -p > "$FILEPATH"
    echo "Screenshot saved to $FILEPATH"

# ─────────────────────────────────────────────────────────────
# Background Services & Status
# ─────────────────────────────────────────────────────────────

# Start Metro bundler in background
dev-bg:
    @echo "Starting Metro bundler in background..."
    npx expo start --port 8081 > /tmp/metro.log 2>&1 &
    @echo "Metro logs: /tmp/metro.log"
    @sleep 5
    @curl -s http://localhost:8081/status > /dev/null && echo "✓ Metro started!" || echo "⏳ Metro may still be starting..."

# Stop all background services
dev-stop:
    @echo "Stopping development services..."
    -@pkill -f "expo start" 2>/dev/null
    @echo "Services stopped."

# Kill ALL processes on dev ports (nuclear option)
kill-all:
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

# View Metro logs (live)
metro-logs:
    @tail -f /tmp/metro.log

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

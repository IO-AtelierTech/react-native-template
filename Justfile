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
# Waydroid / Android Device (Linux Android development)
# ─────────────────────────────────────────────────────────────

# List connected devices (including Waydroid)
devices:
    adb devices

# Set up ADB port forwarding for Waydroid
adb-ports:
    adb reverse tcp:8081 tcp:8081
    adb reverse tcp:3000 tcp:3000

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

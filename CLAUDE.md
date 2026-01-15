# React Native Template - Claude Code Instructions

## Project Overview

This is a React Native + Expo SDK 54 template with TypeScript, NativeWind (Tailwind CSS), Drizzle ORM, and best practices for mobile development.

## Tech Stack

- **Framework**: React Native 0.81 + Expo SDK 54
- **Language**: TypeScript (strict mode)
- **Routing**: Expo Router (file-based routing in `src/app/`)
- **Styling**: NativeWind (Tailwind CSS) - configure in `tailwind.config.js`
- **Database**: Drizzle ORM with PostgreSQL - schemas in `src/db/schema/`
- **Navigation**: React Navigation v7 (native stack + bottom tabs)
- **Testing**: Jest + React Testing Library
- **Architecture**: React Native New Architecture enabled (required for Worklets/Reanimated)

## Justfile Commands

All development is done through the Justfile. Run `just` to see all commands.

### Most Used Commands

```bash
just dev              # Start Metro dev server
just check            # Run all quality checks (lint, format, typecheck, test)
just run-android      # Build and run on Android
just run-ios          # Build and run on iOS
```

### Command Naming Conventions

Commands follow consistent prefixes:

| Prefix      | Purpose                        |
| ----------- | ------------------------------ |
| `dev-*`     | Metro foreground variants      |
| `metro-*`   | Metro background/control       |
| `run-*`     | Native builds                  |
| `db-*`      | Database operations            |
| `adb-*`     | Device connection              |
| `app-*`     | App control on device          |
| `waydroid-*`| Waydroid session management    |
| `eas-*`     | EAS cloud builds               |
| `test-*`    | Testing variants               |

## Key Files

- `src/app/` - Expo Router screens (file-based routing)
- `src/components/` - Reusable components
- `src/db/` - Drizzle ORM client and schemas
- `src/services/` - API and external service integrations
- `src/utils/` - Utility functions (including `cn()` for class merging)
- `Justfile` - Development commands
- `app.json` - Expo configuration

## Styling with NativeWind

Use Tailwind classes directly in components:

```tsx
<View className="flex-1 items-center justify-center bg-white">
  <Text className="text-2xl font-bold text-gray-900">Hello</Text>
</View>
```

Use `cn()` utility for conditional classes:

```tsx
import { cn } from '@/utils/cn';

<View className={cn("p-4", isActive && "bg-blue-500")} />
```

## Database (Drizzle ORM)

Define schemas in `src/db/schema/`:

```typescript
import { pgTable, serial, text, timestamp } from 'drizzle-orm/pg-core';

export const items = pgTable('items', {
  id: serial('id').primaryKey(),
  name: text('name').notNull(),
  createdAt: timestamp('created_at').defaultNow(),
});
```

Database commands:

```bash
just db-up            # Start PostgreSQL container
just db-generate      # Generate migrations from schema changes
just db-migrate       # Apply migrations
just db-push          # Push schema directly (dev only)
just db-studio        # Open Drizzle Studio GUI
```

## Testing with Waydroid (Linux)

For testing on Linux without a physical device:

```bash
just waydroid-setup   # Start Waydroid + connect ADB + port forwarding
just metro-bg         # Start Metro in background
just app-launch       # Launch the app
just status           # Check all services
```

App control commands:

```bash
just app-restart      # Force restart app
just app-clear        # Clear app data (fixes login/state issues)
just app-screenshot   # Take device screenshot to /tmp/
just kill-ports       # Kill all dev processes (nuclear option)
```

## EAS Build (Production)

```bash
# Development builds
just eas-dev-android
just eas-dev-ios

# Preview builds (internal distribution)
just eas-preview-android
just eas-preview-ios

# Production builds
just eas-prod-android
just eas-prod-ios
```

See README.md for full EAS setup instructions.

## Important Notes

- Always run `just check` before committing
- The template uses Yarn Berry v4 with `node_modules` linker
- New Architecture is enabled in `android/gradle.properties` (required for Worklets)
- Keep dependencies updated to match Expo SDK version expectations
- App package name is configured in Justfile as `APP_PKG` variable

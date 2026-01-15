# React Native Template

A modern React Native template with TypeScript, NativeWind (Tailwind CSS), Drizzle ORM, and Docker-based PostgreSQL.

## Stack

- **Framework:** React Native 0.81 + Expo SDK 54
- **Language:** TypeScript (strict mode)
- **Styling:** NativeWind (Tailwind CSS for React Native)
- **Navigation:** React Navigation v7 + Expo Router
- **Database:** PostgreSQL (via Docker Compose)
- **ORM:** Drizzle ORM
- **Testing:** Jest + React Testing Library
- **Package Manager:** Yarn Berry (v4)
- **Commands:** Justfile
- **Architecture:** React Native New Architecture enabled

## Prerequisites

- Node.js 20+
- Yarn (via Corepack)
- Docker & Docker Compose
- Just command runner (`cargo install just` or via package manager)
- For Android: Waydroid (Linux), Android Studio, or physical device

## Quick Start

```bash
# Install dependencies
just install

# Start PostgreSQL database
just db-up

# Start Metro dev server
just dev
```

## Available Commands

Run `just` to see all available commands.

### Metro Bundler

| Command        | Description                              |
| -------------- | ---------------------------------------- |
| `just dev`     | Start Metro dev server (foreground)      |
| `just dev-clean` | Start with cache cleared               |
| `just dev-tunnel` | Start in tunnel mode (remote devices) |
| `just metro-bg` | Start Metro in background               |
| `just metro-stop` | Stop Metro bundler                     |
| `just metro-logs` | View Metro logs (live)                 |

### Native Builds

| Command             | Description                    |
| ------------------- | ------------------------------ |
| `just run-android`  | Build and run on Android       |
| `just run-ios`      | Build and run on iOS simulator |
| `just prebuild`     | Generate native projects       |
| `just prebuild-clean` | Regenerate native projects   |

### Code Quality

| Command          | Description               |
| ---------------- | ------------------------- |
| `just check`     | Run all quality checks    |
| `just lint`      | Run ESLint                |
| `just lint-fix`  | Run ESLint with auto-fix  |
| `just format`    | Format code with Prettier |
| `just format-check` | Check formatting        |
| `just typecheck` | Run TypeScript type check |
| `just fix`       | Fix all auto-fixable issues |

### Testing

| Command             | Description            |
| ------------------- | ---------------------- |
| `just test`         | Run Jest tests         |
| `just test-watch`   | Run tests in watch mode |
| `just test-coverage` | Run tests with coverage |
| `just ci`           | Run CI checks          |

### Database

| Command            | Description                 |
| ------------------ | --------------------------- |
| `just db-up`       | Start PostgreSQL container  |
| `just db-down`     | Stop PostgreSQL container   |
| `just db-shell`    | Open psql shell             |
| `just db-logs`     | View database logs          |
| `just db-reset`    | Reset database (WARNING: destroys data) |
| `just db-generate` | Generate Drizzle migrations |
| `just db-migrate`  | Apply migrations            |
| `just db-push`     | Push schema directly (dev)  |
| `just db-studio`   | Open Drizzle Studio         |

### EAS Cloud Builds

| Command                | Description                  |
| ---------------------- | ---------------------------- |
| `just eas-dev`         | Development build (all)      |
| `just eas-dev-android` | Development build (Android)  |
| `just eas-dev-ios`     | Development build (iOS)      |
| `just eas-preview-android` | Preview build (Android)  |
| `just eas-preview-ios` | Preview build (iOS)          |
| `just eas-prod`        | Production build (all)       |
| `just eas-prod-android` | Production build (Android)  |
| `just eas-prod-ios`    | Production build (iOS)       |

### Dependencies & Cleanup

| Command           | Description                      |
| ----------------- | -------------------------------- |
| `just install`    | Install dependencies             |
| `just install-clean` | Clean install (remove node_modules) |
| `just clean`      | Clean build caches               |
| `just info`       | Show project info                |

## Waydroid Development (Linux)

This template includes full automation for Waydroid development on Linux.

### Quick Start with Waydroid

```bash
# One command to set up everything
just waydroid-setup   # Starts Waydroid + connects ADB + sets up ports

# Start Metro in background
just metro-bg

# Launch the app
just app-launch

# Check everything is running
just status
```

### Waydroid Commands

| Command              | Description                           |
| -------------------- | ------------------------------------- |
| `just waydroid-setup` | Full setup (start + connect + ports) |
| `just waydroid-start` | Start Waydroid session               |
| `just waydroid-stop`  | Stop Waydroid session                |
| `just waydroid-status` | Check Waydroid status               |

### ADB / Device Commands

| Command           | Description                          |
| ----------------- | ------------------------------------ |
| `just adb-connect` | Connect ADB to Waydroid             |
| `just adb-ports`   | Set up reverse port forwarding      |
| `just adb-restart` | Restart ADB server (fixes issues)   |
| `just adb-devices` | List connected devices              |

### App Control (on device)

| Command              | Description                        |
| -------------------- | ---------------------------------- |
| `just app-launch`    | Launch app on device               |
| `just app-restart`   | Force restart app                  |
| `just app-clear`     | Clear app data (fixes state issues)|
| `just app-install <path>` | Install APK from path         |
| `just app-screenshot` | Take screenshot to /tmp/          |

### Status & Troubleshooting

| Command          | Description                           |
| ---------------- | ------------------------------------- |
| `just status`    | Check all service statuses            |
| `just kill-ports` | Kill all processes on dev ports      |

## Project Structure

```
├── src/
│   ├── app/              # Expo Router screens (file-based routing)
│   ├── components/       # Reusable components
│   │   └── common/       # Generic UI components
│   ├── db/               # Drizzle ORM setup
│   │   └── schema/       # Database schema definitions
│   ├── services/         # API services
│   ├── types/            # TypeScript type definitions
│   └── utils/            # Utility functions
├── __tests__/            # Test files
├── __mocks__/            # Jest mocks
├── assets/               # App icons and images
├── drizzle/              # Generated migrations
├── App.tsx               # Root component
├── app.json              # Expo configuration
├── docker-compose.yml    # PostgreSQL setup
├── Justfile              # Command runner recipes
├── CLAUDE.md             # AI assistant instructions
└── tailwind.config.js    # Tailwind/NativeWind config
```

## Configuration Files

| File                 | Purpose                                    |
| -------------------- | ------------------------------------------ |
| `tsconfig.json`      | TypeScript configuration with path aliases |
| `eslint.config.js`   | ESLint flat config                         |
| `babel.config.js`    | Babel with NativeWind preset               |
| `metro.config.js`    | Metro bundler with NativeWind + SVG        |
| `tailwind.config.js` | Tailwind/NativeWind theme                  |
| `drizzle.config.ts`  | Drizzle ORM configuration                  |

## Path Aliases

The following path aliases are configured:

- `@/*` → `./src/*`
- `@components/*` → `./src/components/*`
- `@screens/*` → `./src/app/*`
- `@services/*` → `./src/services/*`
- `@utils/*` → `./src/utils/*`
- `@db/*` → `./src/db/*`

## Environment Variables

Copy `.env.example` to `.env` and configure:

```env
# Database
DATABASE_URL=postgresql://postgres:postgres@localhost:5432/template_db
DB_USER=postgres
DB_PASSWORD=postgres
DB_NAME=template_db

# App
API_URL=http://localhost:3000
```

## EAS Build Setup

To build and distribute your app via Expo Application Services (EAS):

### 1. Create Expo Account

Sign up at [expo.dev](https://expo.dev) if you don't have an account.

### 2. Install EAS CLI

```bash
npm install -g eas-cli
```

### 3. Login and Initialize

```bash
# Login to your Expo account
eas login

# Initialize EAS for this project (creates projectId in app.json)
eas init

# Configure build profiles (creates eas.json)
eas build:configure
```

### 4. Build Your App

```bash
# Development build (for testing with dev tools)
just eas-dev-android
just eas-dev-ios

# Preview build (internal distribution)
just eas-preview-android
just eas-preview-ios

# Production build
just eas-prod-android
just eas-prod-ios
```

### Build Profiles

After running `eas build:configure`, you'll have an `eas.json` with these profiles:

| Profile       | Purpose                              |
| ------------- | ------------------------------------ |
| `development` | Debug builds with dev client enabled |
| `preview`     | Internal testing builds (APK/IPA)    |
| `production`  | App store release builds             |

> **Note:** First builds require additional setup for signing credentials. EAS will guide you through this process.

## Adding New Screens

1. Create screen in `src/app/` (Expo Router uses file-based routing):

   ```tsx
   // src/app/profile.tsx
   import { View, Text } from 'react-native';

   export default function ProfileScreen() {
     return (
       <View className="flex-1 items-center justify-center bg-white">
         <Text className="text-2xl font-bold">Profile</Text>
       </View>
     );
   }
   ```

2. The screen is automatically available at `/profile`

## Adding Database Tables

1. Create schema in `src/db/schema/`:

   ```ts
   // src/db/schema/users.ts
   import { pgTable, serial, text, timestamp } from 'drizzle-orm/pg-core';

   export const users = pgTable('users', {
     id: serial('id').primaryKey(),
     email: text('email').notNull().unique(),
     createdAt: timestamp('created_at').defaultNow().notNull(),
   });
   ```

2. Export from `src/db/schema/index.ts`

3. Generate migration: `just db-generate`

4. Apply migration: `just db-migrate`

## Styling with NativeWind

Use Tailwind classes directly in components:

```tsx
<View className="flex-1 items-center justify-center bg-white">
  <Text className="text-2xl font-bold text-gray-900">Hello</Text>
</View>
```

Use the `cn()` utility for conditional classes:

```tsx
import { cn } from '@/utils/cn';

<View className={cn("p-4", isActive && "bg-blue-500")} />
```

## License

MIT

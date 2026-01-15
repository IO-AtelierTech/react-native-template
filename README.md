# React Native Template

A modern React Native template with TypeScript, NativeWind (Tailwind CSS), Drizzle ORM, and Docker-based PostgreSQL.

## Stack

- **Framework:** React Native + Expo SDK 54
- **Language:** TypeScript (strict mode)
- **Styling:** NativeWind (Tailwind CSS for React Native)
- **Navigation:** React Navigation v7
- **Database:** PostgreSQL (via Docker Compose)
- **ORM:** Drizzle ORM
- **Testing:** Jest + React Testing Library
- **Package Manager:** Yarn Berry (v4)
- **Commands:** Justfile

## Prerequisites

- Node.js 20+
- Yarn (via Corepack)
- Docker & Docker Compose
- Just command runner (`cargo install just` or via package manager)
- For Android: Waydroid, Android Studio, or physical device

## Quick Start

```bash
# Install dependencies
just install

# Start PostgreSQL database
just db-up

# Start Expo development server
just dev
```

## Available Commands

Run `just` to see all available commands. Key commands:

### Development

| Command          | Description                    |
| ---------------- | ------------------------------ |
| `just dev`       | Start Expo development server  |
| `just dev-clean` | Start with cache cleared       |
| `just android`   | Run on Android device/emulator |
| `just ios`       | Run on iOS simulator           |

### Code Quality

| Command          | Description               |
| ---------------- | ------------------------- |
| `just lint`      | Run ESLint                |
| `just format`    | Format code with Prettier |
| `just typecheck` | Run TypeScript type check |
| `just test`      | Run Jest tests            |
| `just check`     | Run all quality checks    |

### Database

| Command            | Description                 |
| ------------------ | --------------------------- |
| `just db-up`       | Start PostgreSQL container  |
| `just db-down`     | Stop PostgreSQL container   |
| `just db-shell`    | Open psql shell             |
| `just db-generate` | Generate Drizzle migrations |
| `just db-migrate`  | Apply migrations            |
| `just db-studio`   | Open Drizzle Studio         |

## Project Structure

```
├── src/
│   ├── app/              # Screen components
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

## Waydroid Development (Linux)

This template is optimized for development with Waydroid on Linux:

```bash
# List connected devices
just devices

# Set up port forwarding
just adb-ports

# Launch app
just waydroid-launch
```

## Adding New Screens

1. Create screen in `src/app/`:

   ```tsx
   // src/app/profile.tsx
   export default function ProfileScreen() {
     return (
       <SafeAreaView className="flex-1 bg-white">
         <Text className="text-2xl font-bold">Profile</Text>
       </SafeAreaView>
     );
   }
   ```

2. Add to navigation in `App.tsx`:
   ```tsx
   <Tab.Screen name="Profile" component={ProfileScreen} />
   ```

## Adding Database Tables

1. Create schema in `src/db/schema/`:

   ```ts
   // src/db/schema/users.ts
   export const users = pgTable('users', {
     id: serial('id').primaryKey(),
     email: text('email').notNull().unique(),
     createdAt: timestamp('created_at').defaultNow().notNull(),
   });
   ```

2. Export from `src/db/schema/index.ts`

3. Generate migration: `just db-generate`

4. Apply migration: `just db-migrate`

## License

MIT

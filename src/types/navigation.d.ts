/**
 * Navigation Type Definitions
 *
 * Define your navigation stack types here for type-safe navigation.
 */

export type RootStackParamList = {
  Main: undefined;
};

export type TabParamList = {
  Home: undefined;
  Settings: undefined;
};

declare global {
  namespace ReactNavigation {
    // eslint-disable-next-line @typescript-eslint/no-empty-object-type
    interface RootParamList extends RootStackParamList {}
  }
}

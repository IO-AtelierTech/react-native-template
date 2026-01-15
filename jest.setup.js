// Jest setup file
global.__DEV__ = true;

// Increase timeout for slower CI environments
jest.setTimeout(10000);

// Silence console warnings in tests
const originalWarn = console.warn;
console.warn = (...args) => {
  if (
    typeof args[0] === 'string' &&
    (args[0].includes('Require cycle') || args[0].includes('ReactNativeCSSInterop'))
  ) {
    return;
  }
  originalWarn(...args);
};

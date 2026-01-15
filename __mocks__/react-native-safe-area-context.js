// Mock for react-native-safe-area-context
const React = require('react');
const { View } = require('react-native');

module.exports = {
  SafeAreaProvider: ({ children }) => children,
  SafeAreaView: ({ children, style, ...props }) =>
    React.createElement(View, { style, ...props }, children),
  useSafeAreaInsets: () => ({ top: 0, bottom: 0, left: 0, right: 0 }),
  useSafeAreaFrame: () => ({ x: 0, y: 0, width: 390, height: 844 }),
};

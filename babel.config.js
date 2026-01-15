module.exports = function (api) {
  api.cache(true);
  return {
    presets: [
      ['babel-preset-expo', { jsxImportSource: 'nativewind' }],
      'nativewind/babel',
      '@babel/preset-typescript',
    ],
    // Add 'react-native-reanimated/plugin' here when using animations
  };
};

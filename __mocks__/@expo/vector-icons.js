// Mock for @expo/vector-icons
import React from 'react';
import { Text } from 'react-native';

const createIconMock = (name) => {
  const IconMock = ({ name: iconName, ...props }) => (
    <Text {...props}>{iconName || name}</Text>
  );
  IconMock.displayName = name;
  return IconMock;
};

export const MaterialIcons = createIconMock('MaterialIcons');
export const MaterialCommunityIcons = createIconMock('MaterialCommunityIcons');
export const Ionicons = createIconMock('Ionicons');
export const FontAwesome = createIconMock('FontAwesome');
export const FontAwesome5 = createIconMock('FontAwesome5');
export const Feather = createIconMock('Feather');
export const AntDesign = createIconMock('AntDesign');
export const Entypo = createIconMock('Entypo');
export const EvilIcons = createIconMock('EvilIcons');
export const Foundation = createIconMock('Foundation');
export const Octicons = createIconMock('Octicons');
export const SimpleLineIcons = createIconMock('SimpleLineIcons');
export const Zocial = createIconMock('Zocial');

export default {
  MaterialIcons,
  MaterialCommunityIcons,
  Ionicons,
  FontAwesome,
  FontAwesome5,
  Feather,
  AntDesign,
  Entypo,
  EvilIcons,
  Foundation,
  Octicons,
  SimpleLineIcons,
  Zocial,
};

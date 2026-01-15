import { View, Text, Pressable } from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';

export default function SettingsScreen() {
  return (
    <SafeAreaView className="flex-1 bg-white">
      <View className="flex-1 p-4">
        <Text className="mb-4 text-2xl font-bold text-gray-900">Settings</Text>
        <View className="space-y-2">
          <Pressable className="rounded-lg bg-gray-100 p-4 active:bg-gray-200">
            <Text className="text-gray-900">Account</Text>
            <Text className="text-sm text-gray-500">Manage your account settings</Text>
          </Pressable>
          <Pressable className="mt-2 rounded-lg bg-gray-100 p-4 active:bg-gray-200">
            <Text className="text-gray-900">Notifications</Text>
            <Text className="text-sm text-gray-500">Configure push notifications</Text>
          </Pressable>
          <Pressable className="mt-2 rounded-lg bg-gray-100 p-4 active:bg-gray-200">
            <Text className="text-gray-900">About</Text>
            <Text className="text-sm text-gray-500">App version and info</Text>
          </Pressable>
        </View>
      </View>
    </SafeAreaView>
  );
}

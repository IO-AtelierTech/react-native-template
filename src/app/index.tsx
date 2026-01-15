import { View, Text } from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';

export default function HomeScreen() {
  return (
    <SafeAreaView className="flex-1 bg-white">
      <View className="flex-1 items-center justify-center p-4">
        <Text className="text-2xl font-bold text-gray-900">Welcome to the Template</Text>
        <Text className="mt-2 text-center text-gray-600">
          Start building your app by editing src/app/index.tsx
        </Text>
        <View className="mt-8 rounded-lg bg-primary-100 p-4">
          <Text className="text-center text-primary-800">
            NativeWind is configured and ready to use!
          </Text>
        </View>
      </View>
    </SafeAreaView>
  );
}

import { Pressable, Text, type PressableProps } from 'react-native';
import { cn } from '@utils/cn';

interface ButtonProps extends PressableProps {
  title: string;
  variant?: 'primary' | 'secondary' | 'outline';
}

export default function Button({ title, variant = 'primary', className, ...props }: ButtonProps) {
  return (
    <Pressable
      className={cn(
        'items-center justify-center rounded-lg px-4 py-3',
        variant === 'primary' && 'bg-primary-600 active:bg-primary-700',
        variant === 'secondary' && 'bg-gray-600 active:bg-gray-700',
        variant === 'outline' && 'border border-primary-600 bg-transparent active:bg-primary-50',
        className
      )}
      {...props}
    >
      <Text
        className={cn('font-semibold', variant === 'outline' ? 'text-primary-600' : 'text-white')}
      >
        {title}
      </Text>
    </Pressable>
  );
}

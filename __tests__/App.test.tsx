import React from 'react';
import { render, screen } from '@testing-library/react-native';

// Test just the Home screen without navigation
import HomeScreen from '@screens/index';

describe('App', () => {
  it('renders home screen without crashing', () => {
    render(<HomeScreen />);
    expect(screen).toBeDefined();
  });

  it('displays welcome message', () => {
    render(<HomeScreen />);
    expect(screen.getByText('Welcome to the Template')).toBeTruthy();
  });

  it('shows NativeWind configuration message', () => {
    render(<HomeScreen />);
    expect(screen.getByText(/NativeWind is configured/)).toBeTruthy();
  });
});

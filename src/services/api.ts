/**
 * API Service
 *
 * This is a placeholder for your API service.
 * Configure your API base URL and create typed fetch functions here.
 */

const API_BASE_URL = process.env.API_URL || 'http://localhost:3000';

interface FetchOptions extends RequestInit {
  params?: Record<string, string>;
}

/**
 * Generic fetch wrapper with error handling
 */
export async function apiFetch<T>(endpoint: string, options: FetchOptions = {}): Promise<T> {
  const { params, ...fetchOptions } = options;

  let url = `${API_BASE_URL}${endpoint}`;

  if (params) {
    const searchParams = new URLSearchParams(params);
    url += `?${searchParams.toString()}`;
  }

  const response = await fetch(url, {
    headers: {
      'Content-Type': 'application/json',
      ...fetchOptions.headers,
    },
    ...fetchOptions,
  });

  if (!response.ok) {
    throw new Error(`API Error: ${response.status} ${response.statusText}`);
  }

  return response.json();
}

/**
 * Example API functions - replace with your actual API calls
 */
export const api = {
  // Example: Get items
  getItems: () => apiFetch<{ items: unknown[] }>('/api/items'),

  // Example: Create item
  createItem: (data: { title: string; description?: string }) =>
    apiFetch<{ id: number }>('/api/items', {
      method: 'POST',
      body: JSON.stringify(data),
    }),

  // Example: Health check
  healthCheck: () => apiFetch<{ status: string }>('/api/health'),
};

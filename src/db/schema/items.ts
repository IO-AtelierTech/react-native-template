import { pgTable, serial, text, timestamp, boolean } from 'drizzle-orm/pg-core';

/**
 * Example items table schema.
 * Replace with your actual domain models.
 */
export const items = pgTable('items', {
  id: serial('id').primaryKey(),
  title: text('title').notNull(),
  description: text('description'),
  completed: boolean('completed').notNull().default(false),
  createdAt: timestamp('created_at').defaultNow().notNull(),
  updatedAt: timestamp('updated_at').defaultNow().notNull(),
});

// TypeScript types inferred from schema
export type Item = typeof items.$inferSelect;
export type NewItem = typeof items.$inferInsert;

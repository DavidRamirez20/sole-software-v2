"use client";

import { SidebarProvider } from '@/context/SidebarContext';
import { ThemeProvider } from '@/context/ThemeContext';
import ApolloProviders from '@/app/apollo-provider';

export default function Providers({ children }: { children: React.ReactNode }) {
  return (
    <ApolloProviders>
      <ThemeProvider> 
        <SidebarProvider>
          {children}
        </SidebarProvider>
      </ThemeProvider>
    </ApolloProviders>
  );
}
import { defineConfig } from 'vite';
import react from '@vitejs/plugin-react';

export default defineConfig({
  plugins: [react()],
  base: './',  
  build: {
    outDir: 'build',
    sourcemap: true, // Source maps oluşturmak için
    minify: false, // Minify edilmemiş build
  },
});

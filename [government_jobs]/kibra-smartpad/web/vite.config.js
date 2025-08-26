import { defineConfig } from 'vite';
import react from '@vitejs/plugin-react';
import path from 'path';

export default defineConfig({
  plugins: [react()],
  resolve: {
    alias: {
      '@': path.resolve(__dirname, 'src')
    }
  },
  server: {
    watch: {
      usePolling: true,
      interval: 300
    }
  },
  base: './',  
  build: {
    outDir: 'build',
    sourcemap: true, // Source maps oluşturmak için
    minify: false, // Minify edilmemiş build
    rollupOptions: {
      output: {
        entryFileNames: 'assets/[name].js', // Ana dosya isimleri
        chunkFileNames: 'assets/[name].js', // Parça dosya isimleri
        assetFileNames: (assetInfo) => {
          const ext = assetInfo.name.split('.').pop(); // Dosya uzantısını al
          if (ext === 'png' || ext === 'jpg' || ext === 'ttf' || ext === 'otf') {
            return 'assets/[name].[ext]'; // Hash olmadan kaydet
          }
          return 'assets/[name]-[hash].[ext]'; // Diğer varlıklar hash'lenir
        },
      },
    },
  },
});

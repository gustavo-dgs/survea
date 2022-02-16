const path = require('path')

module.exports = {
  lintOnSave: false,
  outputDir: path.resolve(__dirname, '../server/src/dist'),
  pwa: {
    name: "survea",
    themeColor: "#21930d",
    appleMobileWebAppCapable: 'yes',
    // workboxPluginMode: 'InjectManifest',
    // workboxOptions: {
    //   swSrc: 'src/service-worker.js',
    //   swDest: './dist/service-worker.js',
    //   globDirectory: './dist',
    //   globPatterns: [
    //     '**/*.js',
    //     '**/*.css',
    //     '**/*.svg',
    //     '**/*.ico',
    //     '**/*.png'
    //   ]
    // },
    iconPaths: {
      favicon32: 'img/icons/favicon-32x32.png',
      favicon16: 'img/icons/favicon-16x16.png',
      appleTouchIcon: 'img/icons/apple-touch-icon.png',
      maskIcon: 'img/icons/safari-pinned-tab.svg',
      msTileImage: 'img/icons/mstile-150x150.png'
    },
    manifestOptions: {
      "background_color": "#2c2525",
      "scope": "/",
      "description": "Application for make and share surveys"
    }
  }
}

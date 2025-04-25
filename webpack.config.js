const ForkTsCheckerWebpackPlugin = require('fork-ts-checker-webpack-plugin');
const fs = require('node:fs');
const path = require('node:path');
const TsconfigPathsPlugin = require('tsconfig-paths-webpack-plugin');

const basePath = path.join(__dirname, 'services');
const services = fs.readdirSync(basePath);
const handlers = services.map((service) => {
  const handlers = fs.readdirSync(path.join(basePath, service, 'handlers'));
  return handlers.map((handler) => {
    const fileName = handler.substring(0, handler.lastIndexOf('.'));
    const handlerName = `${service}-handler-${fileName}`;
    const handlerPath = path.join(basePath, service, 'handlers', handler);
    return [handlerName, handlerPath];
  });
});

/**
 * @type {import('webpack').Configuration[]}
 */
module.exports = handlers.flat().map((entry) => ({
  mode: process.env.NODE_ENV === 'production' ? 'production' : 'development',
  entry: entry[1],
  output: {
    path: path.join(__dirname, '.webpack', entry[0]),
    filename: 'index.js',
    libraryTarget: 'commonjs2',
  },
  resolve: {
    extensions: ['.js', '.ts'],
    plugins: [new TsconfigPathsPlugin()],
  },
  target: 'node',
  module: {
    rules: [
      {
        test: /\.ts$/,
        loader: 'esbuild-loader',
      },
    ],
  },
  plugins: [new ForkTsCheckerWebpackPlugin()],
  watchOptions: {
    ignored: /node_modules/,
  },
}));

'use strict'

const path = require('path')
const context = path.resolve(__dirname, 'src');

require('expose-loader')
require('babel-polyfill')

module.exports = {
  context,
  entry: './server.js',
  devtool: 'eval',
  output: {
    path: path.join(__dirname, '/dist'),
    filename: 'server.js'
  },
  module: {
    loaders: [
      {
        include: [
          path.resolve(__dirname, './src'),
          path.resolve(__dirname, "node_modules/react-datepicker/dist/")
        ],
        loaders: [
          'style-loader',
          'css-loader?importLoader=1&modules&localIdentName=[path]___[name]__[local]___[hash:base64:5]'
        ],
        test: /\.s?css$/
      },
      {
        include: path.resolve(__dirname, './src'),
        loader: 'babel-loader',
        query: {
          plugins: [
            'transform-react-jsx',
            [
              'react-css-modules',
              {
                context,
                "filetypes": {
                  ".scss": {
                    "syntax": "postcss-scss"
                  }
                }
              }
            ]
          ]
        },
        test: /\.js$/
      }
    ]
  },
  resolve: {
    extensions: ['.js', '.jsx']
  }
}

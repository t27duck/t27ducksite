const { environment } = require('@rails/webpacker');

const webpack = require('webpack');
environment.plugins.set('Provide', new webpack.ProvidePlugin({
  $: 'jquery',
  jQuery: 'jquery'
}));

const jqueryLoader = {
  test: require.resolve('jquery'),
  use: [{
    loader: 'expose-loader',
    options: 'jQuery'
  }, {
    loader: 'expose-loader',
    options: '$'
  }]
};

environment.loaders.append('expose-loader-jquery', jqueryLoader);

module.exports = environment;

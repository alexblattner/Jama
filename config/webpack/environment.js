const { environment } = require('@rails/webpacker')

const webpack = require('webpack')
const erb = require('./loaders/erb')
environment.plugins.prepend('Provide',
  new webpack.ProvidePlugin({
    $: 'jquery',
    jQuery: 'jquery'
  })
);

const aliasConfig = {
    'jquery': 'jquery-ui-dist/external/jquery/jquery.js',
    'jquery-ui': 'jquery-ui-dist/jquery-ui.js'
};

environment.config.set('resolve.alias', aliasConfig);

environment.loaders.prepend('erb', erb);
module.exports = environment;
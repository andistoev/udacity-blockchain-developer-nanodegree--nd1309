const webpack = require('webpack')
const path = require('path')
const nodeExternals = require('webpack-node-externals')
const StartServerPlugin = require('start-server-nestjs-webpack-plugin')

module.exports = {
    mode: 'development',
    entry: [
        'webpack/hot/poll?1000',
        './src/server/index'
    ],
    watch: true,
    target: 'node',
    experiments: {topLevelAwait: true},
    externals: [nodeExternals({
        allowlist: ['webpack/hot/poll?1000']
    })],
    module: {
        rules: [{
            test: /\.js?$/,
            use: 'babel-loader',
            exclude: /node_modules/
        }]
    },
    plugins: [
        new StartServerPlugin({
            name: 'server.js'
        }),
        new webpack.HotModuleReplacementPlugin(),
        new webpack.NoEmitOnErrorsPlugin(),
        new webpack.DefinePlugin({
            "process.env": {
                "BUILD_TARGET": 'server'
            }
        }),
    ],
    output: {
        path: path.join(__dirname, 'build/server'),
        filename: 'server.js'
    }
}

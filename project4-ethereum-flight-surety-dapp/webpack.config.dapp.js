const path = require('path');
const HtmlWebpackPlugin = require('html-webpack-plugin');
const NodePolyfillPlugin = require('node-polyfill-webpack-plugin');

module.exports = {
    mode: 'development',
    entry: ['babel-polyfill', path.join(__dirname, "src/dapp")],
    module: {
        rules: [
            {
                test: /\.(js|jsx)$/,
                use: "babel-loader",
                exclude: /node_modules/
            },
            {
                test: /\.css$/,
                use: ["style-loader", "css-loader"]
            },
            {
                test: /\.(png|svg|jpg|gif)$/,
                use: [
                    'file-loader'
                ]
            },
            {
                test: /\.html$/,
                use: "html-loader",
                exclude: /node_modules/
            }
        ]
    },
    plugins: [
        new NodePolyfillPlugin(),
        new HtmlWebpackPlugin({
            template: path.join(__dirname, "src/dapp/index.html")
        })
    ],
    resolve: {
        extensions: [".js"]
    },
    devServer: {
        contentBase: path.join(__dirname, "dapp"),
        port: 8000,
        stats: "minimal"
    },
    output: {
        path: path.join(__dirname, 'build/dapp'),
        filename: 'bundle.js'
    }
};

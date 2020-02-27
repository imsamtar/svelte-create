npx degit sveltejs/template-webpack .
npm install
npm i -D @fullhuman/postcss-purgecss postcss postcss-load-config svelte-preprocess tailwindcss
npx tailwind init

#############################################################################
echo "Updating postcss.config.js..."
echo "const purgecss = require('@fullhuman/postcss-purgecss')({
  content: [
    './src/**/*.html',
    './src/**/*.svelte'
  ],

  whitelistPatterns: [/svelte-/],

  defaultExtractor: content => content.match(/[A-Za-z0-9-_:/]+/g) || []
});

const production = !process.env.ROLLUP_WATCH

module.exports = {
  plugins: [
    require('tailwindcss'),
    ...(production ? [purgecss] : [])
  ]
};" > postcss.config.js
#############################################################################
echo "Creating src/Tailwind.svelte..."
echo "<style global>
  @tailwind base;
  @tailwind components;
  @tailwind utilities;
</style>" > src/Tailwind.svelte
#############################################################################
echo "Updateing src/App.svelte..."
echo "<script>
	import Tailwind from './Tailwind.svelte';
	export let name;
</script>

<style>
	h1 {
		@apply bg-black text-white;
	}
</style>

<h1>Hello {name}!</h1>" > src/App.svelte
#############################################################################
echo "Updating src/webpack.config.js..."
echo "const MiniCssExtractPlugin = require('mini-css-extract-plugin');
const path = require('path');

const mode = process.env.NODE_ENV || 'development';
const prod = mode === 'production';

module.exports = {
	entry: {
		bundle: ['./src/main.js']
	},
	resolve: {
		alias: {
			svelte: path.resolve('node_modules', 'svelte')
		},
		extensions: ['.mjs', '.js', '.svelte'],
		mainFields: ['svelte', 'browser', 'module', 'main']
	},
	output: {
		path: __dirname + '/public',
		filename: '[name].js',
		chunkFilename: '[name].[id].js'
	},
	module: {
		rules: [
			{
				test: /\.svelte$/,
				use: {
					loader: 'svelte-loader',
					options: {
						emitCss: true,
						hotReload: true,
						preprocess: require('svelte-preprocess')({ postcss: true })
					}
				}
			},
			{
				test: /\.css$/,
				use: [
					/**
					 * MiniCssExtractPlugin doesn't support HMR.
					 * For developing, use 'style-loader' instead.
					 * */
					prod ? MiniCssExtractPlugin.loader : 'style-loader',
					'css-loader'
				]
			}
		]
	},
	mode,
	plugins: [
		new MiniCssExtractPlugin({
			filename: '[name].css'
		})
	],
	devtool: prod ? false: 'source-map'
};
" > webpack.config.js

#############################################################################
clear
#############################################################################
read -p "Do you want to install sveltefire? [Y] " sveltefire
if [ -z $sveltefire ]; then sveltefire="y"; fi
if [ $sveltefire != "n" ] && [ $sveltefire != "N" ]; then
    npm i -D sveltefire
    npm i -D firebase
fi
#############################################################################
clear
#############################################################################
read -p "Do you want to install @conposi/gestures? [Y] " gestures
if [ -z $gestures ]; then gestures="y"; fi
if [ $gestures != "n" ] && [ $gestures != "N" ]; then
    npm i -D @composi/gestures
fi
#############################################################################
clear
#############################################################################
read -p "Do you want to install Cypress? [Y] " cypress
if [ -z $cypress ]; then cypress="y"; fi
if [ $cypress != "n" ] && [ $cypress != "N" ]; then
    if [ $sveltefire != "n" ] && [ $sveltefire != "N" ]; then
        npm i -D cypress-firebase
    fi
    echo "It can take a long time! It is recommended to install cypress globally."
    read -p "Are you sure to install cypress as a dev-dependency? [N] " cypress
    if [ -z $cypress ]; then cypress="n"; fi
    if [ $cypress = "y" ] || [ $cypress = "Y" ]; then
        npm i -D cypress
    fi
fi
#############################################################################
clear
#############################################################################

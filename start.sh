npx degit sveltejs/template-webpack .
npm install
npm i -D @fullhuman/postcss-purgecss postcss postcss-load-config svelte-preprocess tailwindcss
npx tailwind init --full

####
clear
read -p "Enter package name (small letters): " pkgname
sed -i 's/svelte-app/'$pkgname'/g' package.json

####
echo "Updating postcss.config.js..."
echo -e "const purgecss = require('@fullhuman/postcss-purgecss')({
\tcontent: ['./src/**/*.html', './src/**/*.svelte'],
\twhitelistPatterns: [/svelte-/],
\tdefaultExtractor: content => content.match(/[A-Za-z0-9-_:/]+/g) || []
});
const production = process.env.NODE_ENV==='production';
module.exports = {
\tplugins: [
\t\trequire('tailwindcss'),
\t\t...(production ? [purgecss] : [])
\t]
};" > postcss.config.js

####
echo "Creating src/Tailwind.svelte..."
echo -e "<style global>
\t@tailwind base;
\t@tailwind components;
\t@tailwind utilities;
</style>" > src/Tailwind.svelte

####
echo "Updateing src/App.svelte..."
sed -i "s/<script>/<script>\n\timport Tailwind from \'.\/Tailwind.svelte';/g" src/App.svelte

####
echo "Updating webpack.config.js..."
sed -i "s/options: {/options: {\n\t\t\t\t\t\tpreprocess: require('svelte-preprocess')({ postcss: true }),/g" webpack.config.js

####
clear
read -p "Do you want to install sveltefire? [Y] " sveltefire
if [ -z $sveltefire ]; then sveltefire="y"; fi
if [ $sveltefire != "n" ] && [ $sveltefire != "N" ]; then
    npm i -D sveltefire
    npm i -D firebase
fi
####
clear
read -p "Do you want to install @conposi/gestures? [Y] " gestures
if [ -z $gestures ]; then gestures="y"; fi
if [ $gestures != "n" ] && [ $gestures != "N" ]; then
    npm i -D @composi/gestures
fi
####
clear
read -p "Do you want to install Cypress? [Y] " cypress
if [ -z $cypress ]; then cypress="y"; fi
if [ $cypress != "n" ] && [ $cypress != "N" ]; then
    if [ $sveltefire != "n" ] && [ $sveltefire != "N" ]; then
        npm i -D cypress-firebase
    fi
    echo "It can take a long time! It is recommended to install cypress globally."
    read -p "Are you sure to install cypress as a devDependency? [N] " cypress
    if [ -z $cypress ]; then cypress="n"; fi
    if [ $cypress = "y" ] || [ $cypress = "Y" ]; then
        npm i -D cypress
    fi
fi
####
clear
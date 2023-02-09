const fs = require('fs');
const sass = require('sass');

module.exports = () => {
  if (fs.existsSync('public')) {
    fs.rmSync('public', {
      recursive: true,
    });
  }

  fs.mkdirSync('public/stylesheets', {
    recursive: true,
  });

  fs.writeFileSync('public/stylesheets/main.css', sass.renderSync({
    file: 'app/assets/sass/main.scss',
    outputStyle: 'compressed',
  }).css);
};

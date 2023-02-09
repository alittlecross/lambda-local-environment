const { configure } = require('nunjucks');

module.exports = (app) => {
  const paths = [
    './app/views',
    './node_modules/govuk-frontend',
  ];

  const options = {
    express: app,
  };

  const env = configure(paths, options);

  env.addFilter('formatResponse', (response) => JSON.stringify(response, null, 2));

  app.set('view engine', 'njk');
};

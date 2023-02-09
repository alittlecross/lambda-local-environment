const express = require('express');

const build = require('./build');
const nunjucks = require('./middleware/nunjucks');
const routes = require('./app/routes');

const assetsUrl = '/assets';
const govuk = './node_modules/govuk-frontend/govuk';

const app = express();

build();

app.use(assetsUrl, express.static('./public'));
app.use(assetsUrl, express.static(`${govuk}`));
app.use(assetsUrl, express.static(`${govuk}/assets`, { maxAge: 1000 * 60 * 60 * 24 }));

nunjucks(app);

app.use(express.json());
app.use(express.urlencoded({ extended: true }));

app.use('/', routes);

module.exports = app;

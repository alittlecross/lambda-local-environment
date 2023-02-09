const express = require('express');

const routes = require('./app/routes');

const app = express();

app.use(express.json());
app.use(express.urlencoded({ extended: true }));

app.use('/', routes);

module.exports = app;

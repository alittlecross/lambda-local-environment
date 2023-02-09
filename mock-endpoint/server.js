const app = require('./app');

const port = process.env.PORT;

app.listen(port, () => {
  console.log(`\nlistening on: http://172.17.0.1:${port}\n`);
});

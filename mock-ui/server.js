const app = require('./app');

const port = process.env.PORT;

app.listen(port, () => {
  console.log(`\nlistening on: http://localhost:${port}\n`);
});

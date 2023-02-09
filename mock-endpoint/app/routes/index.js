const express = require('express');

const router = express.Router();

router.post('/my-endpoint', (req, res) => {
  try {
    console.log(JSON.stringify(req.body));

    res.sendStatus(200);
  } catch (err) {
    console.error(err);

    res.sendStatus(500);
  }
});

module.exports = router;

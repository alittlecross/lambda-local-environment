const express = require('express');

const publishEvent = require('../../lib/publish-event');

const router = express.Router();

const page = 'index';
const url = '/';

router.get(url, (req, res) => {
  res.render(page);
});

router.post(url, async (req, res) => {
  let response;

  console.log(req.body);

  try {
    response = await publishEvent(req.body);
  } catch (err) {
    console.error(err);

    response = err.stack;
  }

  console.log(response);

  res.render(page, {
    details: {
      ...req.body,
    },
    response,
  });
});

module.exports = router;

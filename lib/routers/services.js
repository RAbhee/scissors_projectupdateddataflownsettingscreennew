


// routes/services.js

const express = require('express');
const router = express.Router();
const serviceController = require('../controllers/serviceController');

router.get('/services', serviceController.getAllServices);
router.post('/services', serviceController.createService);

module.exports = router;

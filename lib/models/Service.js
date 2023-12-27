


// models/Service.js

const mongoose = require('mongoose');

const serviceSchema = new mongoose.Schema({
  name: {
    type: String,
    required: true,
  },
  // Add other fields based on your requirements
});

module.exports = mongoose.model('Service', serviceSchema);

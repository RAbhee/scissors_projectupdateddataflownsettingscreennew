const express = require('express');
const mongoose = require('mongoose');

const app = express();
const port = 3000;

// MongoDB connection
mongoose.connect('mongodb://localhost:27017/yourDatabaseName', {
  useNewUrlParser: true,
  useUnifiedTopology: true,
});

// Create a MongoDB schema for the Service model
const serviceSchema = new mongoose.Schema({
  serviceName: String,
  description: String,
  price: Number,
  // Add other fields as needed
});

// Create a MongoDB model for the Service collection
const Service = mongoose.model('Service', serviceSchema);

// Express middleware to parse JSON requests
app.use(express.json());

// Express route to handle service form submission
app.post('/api/addService', async (req, res) => {
  try {
    // Extract data from the request body
    const { serviceName, description, price } = req.body;

    // Create a new Service document
    const newService = new Service({
      serviceName,
      description,
      price,
      // Add other fields as needed
    });

    // Save the new service to the database
    await newService.save();

    // Respond with success message
    res.json({ success: true, message: 'Service added successfully' });
  } catch (error) {
    // Handle errors
    console.error(error);
    res.status(500).json({ success: false, message: 'Internal server error' });
  }
});

// Start the Express server
app.listen(port, () => {
  console.log(`Server is running on http://localhost:${port}`);
});

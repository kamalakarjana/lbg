const express = require('express');
const cors = require('cors');
const helmet = require('helmet');

const app = express();
const PORT = process.env.PORT || 3000;

// Middleware
app.use(helmet());
app.use(cors());
app.use(express.json());

// Health check endpoint
app.get('/health', (req, res) => {
  res.status(200).json({ 
    status: 'OK', 
    service: 'patient-service',
    timestamp: new Date().toISOString()
  });
});

// Get all patients
app.get('/patients', (req, res) => {
  res.json([
    { id: 1, name: 'John Doe', age: 45, condition: 'Stable' },
    { id: 2, name: 'Jane Smith', age: 32, condition: 'Recovering' }
  ]);
});

// Get patient by ID
app.get('/patients/:id', (req, res) => {
  const patient = { 
    id: parseInt(req.params.id), 
    name: 'John Doe', 
    age: 45, 
    condition: 'Stable' 
  };
  res.json(patient);
});

// Create new patient
app.post('/patients', (req, res) => {
  const newPatient = {
    id: Date.now(),
    ...req.body,
    createdAt: new Date().toISOString()
  };
  res.status(201).json(newPatient);
});

app.listen(PORT, () => {
  console.log(`Patient service running on port ${PORT}`);
});

module.exports = app;
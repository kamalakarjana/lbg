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
  const patientId = parseInt(req.params.id);
  const patients = [
    { id: 1, name: 'John Doe', age: 45, condition: 'Stable' },
    { id: 2, name: 'Jane Smith', age: 32, condition: 'Recovering' }
  ];
  const patient = patients.find(p => p.id === patientId);
  
  if (!patient) {
    return res.status(404).json({ error: 'Patient not found' });
  }
  
  res.json(patient);
});

// Create new patient
app.post('/patients', (req, res) => {
  const { name, age, condition } = req.body;
  
  if (!name || !age || !condition) {
    return res.status(400).json({ error: 'Name, age, and condition are required' });
  }
  
  const newPatient = {
    id: Date.now(),
    name,
    age,
    condition,
    createdAt: new Date().toISOString()
  };
  
  res.status(201).json(newPatient);
});

// Update patient
app.put('/patients/:id', (req, res) => {
  const patientId = parseInt(req.params.id);
  const { name, age, condition } = req.body;
  
  const updatedPatient = {
    id: patientId,
    name: name || 'Updated Name',
    age: age || 0,
    condition: condition || 'Updated Condition',
    updatedAt: new Date().toISOString()
  };
  
  res.json(updatedPatient);
});

// Delete patient
app.delete('/patients/:id', (req, res) => {
  const patientId = parseInt(req.params.id);
  res.status(204).send();
});

app.listen(PORT, () => {
  console.log(`Patient service running on port ${PORT}`);
});

module.exports = app;
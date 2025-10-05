const express = require('express');
const app = express();
const port = process.env.PORT || 3000;

app.use(express.json());

// In-memory data store (replace with a database in a real application)
let patients = [
  { id: '1', name: 'John Doe', age: 45, condition: 'Checkup' },
  { id: '2', name: 'Jane Smith', age: 32, condition: 'Follow-up' }
];

app.get('/health', (req, res) => {
  res.status(200).json({ status: 'OK', service: 'Patient Service' });
});

app.get('/patients', (req, res) => {
  res.json({ 
    message: 'Patients retrieved successfully',
    count: patients.length,
    patients: patients 
  });
});

app.get('/patients/:id', (req, res) => {
  const patient = patients.find(p => p.id === req.params.id);
  if (patient) {
    res.json({ 
      message: 'Patient found',
      patient: patient 
    });
  } else {
    res.status(404).json({ error: 'Patient not found' });
  }
});

app.post('/patients', (req, res) => {
  try {
    const { name, age, condition } = req.body;
    if (!name || !age || !condition) {
      return res.status(400).json({ error: 'Name, age, and condition are required' });
    }
    const newPatient = {
      id: (patients.length + 1).toString(),
      name,
      age,
      condition
    };
    patients.push(newPatient);
    res.status(201).json({ 
      message: 'Patient created successfully',
      patient: newPatient 
    });
  } catch (error) {
    res.status(500).json({ error: 'Internal server error' });
  }
});

// Only start the server if this file is run directly (not when required by tests)
if (require.main === module) {
  const server = app.listen(port, '0.0.0.0', () => {
    console.log(`Patient service listening at http://0.0.0.0:${port}`);
  });

  // Graceful shutdown
  process.on('SIGTERM', () => {
    console.log('SIGTERM signal received: closing HTTP server');
    server.close(() => {
      console.log('HTTP server closed');
    });
  });
}

// Export the app for testing
module.exports = app;
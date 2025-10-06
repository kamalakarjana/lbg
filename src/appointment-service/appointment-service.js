const express = require('express');
const cors = require('cors');
const helmet = require('helmet');

const app = express();
const PORT = process.env.PORT || 3001;

// Middleware
app.use(helmet());
app.use(cors());
app.use(express.json());

// Health check endpoint
app.get('/health', (req, res) => {
  res.status(200).json({ 
    status: 'OK', 
    service: 'appointment-service',
    timestamp: new Date().toISOString()
  });
});

// Get all appointments
app.get('/appointments', (req, res) => {
  res.json([
    { id: 1, patientId: 1, date: '2024-01-15', time: '10:00', doctor: 'Dr. Smith' },
    { id: 2, patientId: 2, date: '2024-01-16', time: '14:30', doctor: 'Dr. Johnson' }
  ]);
});

// Get appointment by ID
app.get('/appointments/:id', (req, res) => {
  const appointment = { 
    id: parseInt(req.params.id), 
    patientId: 1, 
    date: '2024-01-15', 
    time: '10:00', 
    doctor: 'Dr. Smith' 
  };
  res.json(appointment);
});

// Create new appointment
app.post('/appointments', (req, res) => {
  const newAppointment = {
    id: Date.now(),
    ...req.body,
    createdAt: new Date().toISOString()
  };
  res.status(201).json(newAppointment);
});

app.listen(PORT, () => {
  console.log(`Appointment service running on port ${PORT}`);
});

module.exports = app;
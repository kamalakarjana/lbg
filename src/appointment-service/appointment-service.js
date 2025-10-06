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
    { id: 1, patientId: 1, date: '2024-01-15', time: '10:00', doctor: 'Dr. Smith', status: 'Scheduled' },
    { id: 2, patientId: 2, date: '2024-01-16', time: '14:30', doctor: 'Dr. Johnson', status: 'Scheduled' }
  ]);
});

// Get appointment by ID
app.get('/appointments/:id', (req, res) => {
  const appointmentId = parseInt(req.params.id);
  const appointments = [
    { id: 1, patientId: 1, date: '2024-01-15', time: '10:00', doctor: 'Dr. Smith', status: 'Scheduled' },
    { id: 2, patientId: 2, date: '2024-01-16', time: '14:30', doctor: 'Dr. Johnson', status: 'Scheduled' }
  ];
  const appointment = appointments.find(a => a.id === appointmentId);
  
  if (!appointment) {
    return res.status(404).json({ error: 'Appointment not found' });
  }
  
  res.json(appointment);
});

// Create new appointment
app.post('/appointments', (req, res) => {
  const { patientId, date, time, doctor } = req.body;
  
  if (!patientId || !date || !time || !doctor) {
    return res.status(400).json({ error: 'patientId, date, time, and doctor are required' });
  }
  
  const newAppointment = {
    id: Date.now(),
    patientId,
    date,
    time,
    doctor,
    status: 'Scheduled',
    createdAt: new Date().toISOString()
  };
  
  res.status(201).json(newAppointment);
});

// Update appointment
app.put('/appointments/:id', (req, res) => {
  const appointmentId = parseInt(req.params.id);
  const { date, time, doctor, status } = req.body;
  
  const updatedAppointment = {
    id: appointmentId,
    patientId: 1,
    date: date || '2024-01-20',
    time: time || '15:00',
    doctor: doctor || 'Dr. Updated',
    status: status || 'Rescheduled',
    updatedAt: new Date().toISOString()
  };
  
  res.json(updatedAppointment);
});

// Delete appointment
app.delete('/appointments/:id', (req, res) => {
  const appointmentId = parseInt(req.params.id);
  res.status(204).send();
});

// Only start server if this file is run directly (not in tests)
if (require.main === module) {
  const server = app.listen(PORT, () => {
    console.log(`Appointment service running on port ${PORT}`);
  });
  
  // Graceful shutdown
  process.on('SIGTERM', () => {
    console.log('SIGTERM received, shutting down gracefully');
    server.close(() => {
      console.log('Process terminated');
    });
  });
}

module.exports = app; // Export app without starting server
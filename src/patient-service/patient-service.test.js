const request = require('supertest');
const app = require('./appointment-service');

describe('Appointment Service', () => {
  describe('GET /health', () => {
    it('should return health status', async () => {
      const response = await request(app).get('/health');
      expect(response.status).toBe(200);
      expect(response.body.status).toBe('OK');
      expect(response.body.service).toBe('appointment-service');
    });
  });

  describe('GET /appointments', () => {
    it('should return all appointments', async () => {
      const response = await request(app).get('/appointments');
      expect(response.status).toBe(200);
      expect(Array.isArray(response.body)).toBe(true);
    });
  });

  describe('GET /appointments/:id', () => {
    it('should return a specific appointment', async () => {
      const response = await request(app).get('/appointments/1');
      expect(response.status).toBe(200);
      expect(response.body.id).toBe(1);
    });
  });

  describe('POST /appointments', () => {
    it('should create a new appointment', async () => {
      const newAppointment = {
        patientId: 1,
        date: '2024-01-20',
        time: '11:00',
        doctor: 'Dr. Test'
      };
      const response = await request(app)
        .post('/appointments')
        .send(newAppointment);
      expect(response.status).toBe(201);
      expect(response.body.doctor).toBe('Dr. Test');
    });
  });
});
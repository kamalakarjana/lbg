const request = require('supertest');
const app = require('./appointment-service');

describe('Appointment Service API', () => {
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
      expect(response.body.length).toBe(2);
    });
  });

  describe('GET /appointments/:id', () => {
    it('should return a specific appointment', async () => {
      const response = await request(app).get('/appointments/1');
      expect(response.status).toBe(200);
      expect(response.body.id).toBe(1);
      expect(response.body.doctor).toBe('Dr. Smith');
    });

    it('should return 404 for non-existent appointment', async () => {
      const response = await request(app).get('/appointments/999');
      expect(response.status).toBe(404);
      expect(response.body.error).toBe('Appointment not found');
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
      expect(response.body.patientId).toBe(1);
      expect(response.body.id).toBeDefined();
    });

    it('should return 400 for missing required fields', async () => {
      const invalidAppointment = { patientId: 1 };
      const response = await request(app)
        .post('/appointments')
        .send(invalidAppointment);
      expect(response.status).toBe(400);
      expect(response.body.error).toContain('required');
    });
  });

  describe('PUT /appointments/:id', () => {
    it('should update an appointment', async () => {
      const updatedData = {
        date: '2024-01-25',
        time: '16:00',
        doctor: 'Dr. Updated',
        status: 'Rescheduled'
      };
      const response = await request(app)
        .put('/appointments/1')
        .send(updatedData);
      expect(response.status).toBe(200);
      expect(response.body.doctor).toBe('Dr. Updated');
      expect(response.body.status).toBe('Rescheduled');
    });
  });

  describe('DELETE /appointments/:id', () => {
    it('should delete an appointment', async () => {
      const response = await request(app).delete('/appointments/1');
      expect(response.status).toBe(204);
    });
  });
});
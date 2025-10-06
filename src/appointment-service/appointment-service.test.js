const request = require('supertest');
const app = require('./patient-service');

describe('Patient Service', () => {
  describe('GET /health', () => {
    it('should return health status', async () => {
      const response = await request(app).get('/health');
      expect(response.status).toBe(200);
      expect(response.body.status).toBe('OK');
      expect(response.body.service).toBe('patient-service');
    });
  });

  describe('GET /patients', () => {
    it('should return all patients', async () => {
      const response = await request(app).get('/patients');
      expect(response.status).toBe(200);
      expect(Array.isArray(response.body)).toBe(true);
    });
  });

  describe('GET /patients/:id', () => {
    it('should return a specific patient', async () => {
      const response = await request(app).get('/patients/1');
      expect(response.status).toBe(200);
      expect(response.body.id).toBe(1);
    });
  });

  describe('POST /patients', () => {
    it('should create a new patient', async () => {
      const newPatient = {
        name: 'Test Patient',
        age: 30,
        condition: 'Test Condition'
      };
      const response = await request(app)
        .post('/patients')
        .send(newPatient);
      expect(response.status).toBe(201);
      expect(response.body.name).toBe('Test Patient');
    });
  });
});
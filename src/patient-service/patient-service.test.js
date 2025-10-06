const request = require('supertest');
const app = require('./patient-service');

describe('Patient Service API', () => {
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
      expect(response.body.length).toBe(2);
    });
  });

  describe('GET /patients/:id', () => {
    it('should return a specific patient', async () => {
      const response = await request(app).get('/patients/1');
      expect(response.status).toBe(200);
      expect(response.body.id).toBe(1);
      expect(response.body.name).toBe('John Doe');
    });

    it('should return 404 for non-existent patient', async () => {
      const response = await request(app).get('/patients/999');
      expect(response.status).toBe(404);
      expect(response.body.error).toBe('Patient not found');
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
      expect(response.body.age).toBe(30);
      expect(response.body.condition).toBe('Test Condition');
      expect(response.body.id).toBeDefined();
    });

    it('should return 400 for missing required fields', async () => {
      const invalidPatient = { name: 'Test' };
      const response = await request(app)
        .post('/patients')
        .send(invalidPatient);
      expect(response.status).toBe(400);
      expect(response.body.error).toContain('required');
    });
  });

  describe('PUT /patients/:id', () => {
    it('should update a patient', async () => {
      const updatedData = {
        name: 'Updated Patient',
        age: 35,
        condition: 'Updated Condition'
      };
      const response = await request(app)
        .put('/patients/1')
        .send(updatedData);
      expect(response.status).toBe(200);
      expect(response.body.name).toBe('Updated Patient');
      expect(response.body.age).toBe(35);
    });
  });

  describe('DELETE /patients/:id', () => {
    it('should delete a patient', async () => {
      const response = await request(app).delete('/patients/1');
      expect(response.status).toBe(204);
    });
  });
});
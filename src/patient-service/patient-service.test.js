const request = require('supertest');
const app = require('./patient-service');

describe('Patient Service', () => {
  test('health endpoint should return 200', async () => {
    const response = await request(app).get('/health');
    expect(response.status).toBe(200);
    expect(response.body.status).toBe('OK');
    expect(response.body.service).toBe('Patient Service');
  });

  test('patients endpoint should return patients', async () => {
    const response = await request(app).get('/patients');
    expect(response.status).toBe(200);
    expect(response.body.patients).toHaveLength(2);
    expect(response.body.message).toBe('Patients retrieved successfully');
  });

  test('get patient by id should work', async () => {
    const response = await request(app).get('/patients/1');
    expect(response.status).toBe(200);
    expect(response.body.patient.id).toBe('1');
    expect(response.body.patient.name).toBe('John Doe');
  });

  test('create patient should work', async () => {
    const newPatient = {
      name: 'Test Patient',
      age: 25,
      condition: 'Test Condition'
    };
    
    const response = await request(app)
      .post('/patients')
      .send(newPatient);
    
    expect(response.status).toBe(201);
    expect(response.body.patient.name).toBe('Test Patient');
    expect(response.body.message).toBe('Patient created successfully');
  });
});
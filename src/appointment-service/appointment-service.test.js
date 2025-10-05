const request = require('supertest');
const app = require('./appointment-service');

describe('Appointment Service', () => {
  test('health endpoint should return 200', async () => {
    const response = await request(app).get('/health');
    expect(response.status).toBe(200);
    expect(response.body.status).toBe('OK');
    expect(response.body.service).toBe('Appointment Service');
  });

  test('appointments endpoint should return appointments', async () => {
    const response = await request(app).get('/appointments');
    expect(response.status).toBe(200);
    expect(response.body.appointments).toHaveLength(2);
    expect(response.body.message).toBe('Appointments retrieved successfully');
  });

  test('get appointment by id should work', async () => {
    const response = await request(app).get('/appointments/1');
    expect(response.status).toBe(200);
    expect(response.body.appointment.id).toBe('1');
    expect(response.body.appointment.patientId).toBe('1');
  });

  test('create appointment should work', async () => {
    const newAppointment = {
      patientId: '3',
      date: '2023-06-17',
      time: '11:00',
      doctor: 'Dr. Brown'
    };
    
    const response = await request(app)
      .post('/appointments')
      .send(newAppointment);
    
    expect(response.status).toBe(201);
    expect(response.body.appointment.doctor).toBe('Dr. Brown');
    expect(response.body.message).toBe('Appointment scheduled successfully');
  });

  test('get appointments by patient id should work', async () => {
    const response = await request(app).get('/appointments/patient/1');
    expect(response.status).toBe(200);
    expect(response.body.appointments.length).toBeGreaterThan(0);
    expect(response.body.appointments[0].patientId).toBe('1');
  });
});
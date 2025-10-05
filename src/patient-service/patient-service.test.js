const request = require('supertest');

describe('Patient Service', () => {
  test('basic health check test', () => {
    expect(1 + 1).toBe(2);
  });

  test('service should be defined', () => {
    const service = require('./patient-service');
    expect(service).toBeDefined();
  });
});
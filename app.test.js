const request = require('supertest');
const app = require('./app');

describe('GET /', () => {
  it('should return 200 OK and greeting', async () => {
    const res = await request(app).get('/');
    expect(res.statusCode).toEqual(200);
    expect(res.text).toContain('Hello World!');
  });
});

describe('GET /health', () => {
  it('should return 200 OK and status UP', async () => {
    const res = await request(app).get('/health');
    expect(res.statusCode).toEqual(200);
    expect(res.body.status).toBe('UP');
  });
});

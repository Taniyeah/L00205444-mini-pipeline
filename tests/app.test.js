const request = require('supertest');
const app = require('../index');

test('home page works', async () => {
  const res = await request(app).get('/');
  expect(res.statusCode).toBe(200);
});

test('health page works', async () => {
  const res = await request(app).get('/health');
  expect(res.body.status).toBe('ok');
});

test('metrics page works', async () => {
  const res = await request(app).get('/metrics');
  expect(res.statusCode).toBe(200);
  expect(res.text).toContain('http_requests_total');
});

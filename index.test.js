const request = require('supertest');
const server = require('./index');

beforeAll((done) => {
    server.listen(0, done);
});

afterAll((done) => {
    server.close(done);
});

describe('Server', () => {
  it('should serve index.html', async () => {
    const response = await request(server).get('/');
    expect(response.statusCode).toBe(200);
    expect(response.headers['content-type']).toBe('text/html; charset=utf-8');
  });
});

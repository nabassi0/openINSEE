import Fastify from 'fastify';

const fastify = Fastify({
  logger: true,
});

// health check endpoint
fastify.get('/health', async () => {
  return { status: 'ok', timestamp: new Date().toISOString() };
});

fastify.get('/', async () => {
  return { message: 'OpenINSEE API', version: '1.0.0' };
});

/**
 * Run the server!
 */
const start = async () => {
  try {
    const port = Number(process.env.PORT) || 3001;
    const host = process.env.HOST || '0.0.0.0';

    await fastify.listen({ port, host });

    fastify.log.info(`Server is running on http://${host}:${port}`);
  } catch (err) {
    fastify.log.error(err);
    process.exit(1);
  }
};

start();

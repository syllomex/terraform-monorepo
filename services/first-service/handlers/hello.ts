import { Logging } from '@shared/logging';
import { APIGatewayProxyHandlerV2 } from 'aws-lambda';

const logging = new Logging();

export const handler: APIGatewayProxyHandlerV2 = async () => {
  return {
    statusCode: 200,
    body: JSON.stringify({
      message: 'Hello from First Service!',
      log: logging.log(),
    }),
  };
};

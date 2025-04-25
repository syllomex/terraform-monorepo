import { Auth } from '@shared/auth';
import { APIGatewayProxyHandlerV2 } from 'aws-lambda';

const auth = new Auth();

export const handler: APIGatewayProxyHandlerV2 = async () => {
  return {
    statusCode: 200,
    body: JSON.stringify({
      message: 'Hello from Second Service!',
      auth: auth.authenticate(),
    }),
  };
};

import 'dotenv/config';
import { spawnSync } from 'node:child_process';

const { TF_BACKEND_BUCKET, TF_BACKEND_KEY, TF_BACKEND_REGION } = process.env;

spawnSync(
  'terraform init',
  [
    `-backend-config="bucket=${TF_BACKEND_BUCKET}"`,
    `-backend-config="key=${TF_BACKEND_KEY}"`,
    `-backend-config="region=${TF_BACKEND_REGION}"`,
  ],
  { stdio: 'inherit', shell: true }
);

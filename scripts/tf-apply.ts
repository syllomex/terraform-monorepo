import 'dotenv/config';
import { spawnSync } from 'node:child_process';

spawnSync('terraform apply', { stdio: 'inherit', shell: true });

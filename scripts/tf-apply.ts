import 'dotenv/config';
import { spawnSync } from 'node:child_process';

spawnSync('npx webpack', { stdio: 'inherit', shell: true });
spawnSync('terraform apply', { stdio: 'inherit', shell: true });

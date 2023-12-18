import { printSchema } from 'graphql';
import { makeGatewaySchema } from './gateway.mjs';
import * as fs from "fs"
import path from 'path';

import { fileURLToPath } from 'url';

const __filename = fileURLToPath(import.meta.url);

const __dirname = path.dirname(__filename);


(async () => {

  let schema = await makeGatewaySchema()
  const sdl = printSchema(schema)

  fs.writeFile(__dirname + '/schema.graphql', sdl, (e) => {
    if (e)
      console.log("Error:" + e);
  })
})();
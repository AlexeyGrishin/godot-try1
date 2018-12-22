let fs = require('fs');
let path = require('path');

for (let file of fs.readdirSync(path.join('.', 'sprites'))) {
  if (file.endsWith('.json')) {
    let json = JSON.parse(fs.readFileSync(path.join('.', 'sprites', file), {encoding: 'utf8'}));
    if (Array.isArray(json.frames)) continue;

    console.log('convert', file);

    json.frames = Object.keys(json.frames).map(filename => Object.assign(json.frames[filename], {filename}));
    fs.writeFileSync(path.join('.', 'sprites', file), JSON.stringify(json), {encoding: 'utf8'});

  }
}

'use strict';

const path = require('node:path');
const koffi = require('koffi');

if (process.argv.length !== 4) {
  console.error('Usage: node index.js <kattplay DLL/.so> <audio.wav|flac|mp3>');
  process.exit(2);
}

const libraryPath = path.resolve(process.argv[2]);
const audioPath = path.resolve(process.argv[3]);
const native = koffi.load(libraryPath);

const abiVersion = native.func('uint32_t kattplay_abi_version()');
const version = native.func('const char* kattplay_version()');
const create = native.func('void* kattplay_create(uint32_t, uint16_t)');
const destroy = native.func('void kattplay_destroy(void*)');
const load = native.func('int kattplay_load(void*, const char*)');
const play = native.func('int kattplay_play(void*)');
const setOutputMode = native.func('int kattplay_set_output_mode(void*, int)');
const stop = native.func('void kattplay_stop(void*)');
const state = native.func('int kattplay_state(void*)');
const position = native.func('double kattplay_position_seconds(void*)');
const duration = native.func('double kattplay_duration_seconds(void*)');
const lastError = native.func('const char* kattplay_last_error(void*)');

const handle = create(48000, 2);
if (!handle) throw new Error('kattplay_create returned null');
const requestedOutputMode = Number(process.env.KATTPLAY_OUTPUT_MODE ?? '0');
if (!setOutputMode(handle, requestedOutputMode)) {
  destroy(handle);
  throw new Error('set output mode failed');
}

let timer = null;
let closed = false;
function close(exitCode = 0) {
  if (closed) return;
  closed = true;
  if (timer) clearInterval(timer);
  stop(handle);
  destroy(handle);
  process.exitCode = exitCode;
}

process.on('SIGINT', () => close(130));
process.on('exit', () => {
  if (!closed) {
    stop(handle);
    destroy(handle);
    closed = true;
  }
});

console.log(`KatPlay ${version()}, ABI ${abiVersion()}`);
if (!load(handle, audioPath)) {
  const error = lastError(handle);
  close(1);
  throw new Error(`load: ${error}`);
}
if (!play(handle)) {
  const error = lastError(handle);
  close(1);
  throw new Error(`play: ${error}`);
}

timer = setInterval(() => {
  const currentState = state(handle);
  process.stdout.write(`\r${position(handle).toFixed(2)} / ${duration(handle).toFixed(2)}`);
  if (currentState === 4 || currentState === 5) {
    process.stdout.write('\n');
    if (currentState === 5) console.error(lastError(handle));
    close(currentState === 5 ? 1 : 0);
  }
}, 200);

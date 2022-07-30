#!/usr/bin/env -S lsc --prelude
require! 'fancy-log': log 
require! 'serialport': {SerialPort}
require! '@serialport/parser-inter-byte-timeout': {InterByteTimeoutParser}
require! './sleep': {sleep}

# Create a port
const port = new SerialPort {
  path: '/dev/ttyUSB0',
  baudRate: 115200,
  dataBits: 8,
  stopBits: 1,
  parity: "none",
}, (err) -> 
  if err 
    return log('Error: ', err.message)

parser = port.pipe(new InterByteTimeoutParser({ interval: 30 }))

parser.on 'data', (data) -> 
  log "Received data:", data.to-string!

do ->>
  i = 0
  while true
    log "Sending data: #{i++}"
    await port.write "main screen turn on #i"
    await sleep 100ms
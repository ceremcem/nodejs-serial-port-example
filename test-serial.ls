#!/usr/bin/env -S lsc --prelude
/* 

Note that this example changes serial port settings on the fly. 

*/
require! 'serialport': {SerialPort}
require! '@serialport/parser-inter-byte-timeout': {InterByteTimeoutParser}
require! './sleep': {sleep}

log = require('fancy-format-log')({
  format: 'HH:mm:ss.ms',   
  style: 'dim.green'                  
})

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
  log.log "Received data:", data.to-string!

do ->>
  i = 0
  while true
    log.log "Sending data: #{i++}"
    await port.write "main screen turn on #i"
    await sleep 100ms
    if i is 100
      log.info "---------------------------------------"
      log.info "Changing baudrate to 9600, parity: even"
      log.info "---------------------------------------"
      await sleep 2000ms # wait for user to read the message
      await port.update {baudRate: 9600, parity: "even"}

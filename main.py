# Write your code here :-)
import machine
import time


spi = machine.SPI(0, baudrate=10_0000, polarity=0, phase=0, bits=8,
                  firstbit=machine.SPI.MSB, sck= machine.Pin(2), mosi= machine.Pin(3), miso= machine.Pin(0))

cs = machine.Pin(machine.Pin(1), machine.Pin.OUT, value=1)

def send(b):
    write_arr = bytearray(1)
    write_arr[0] = int(b)
    cs.value(0)
    spi.write(write_arr)
    cs.value(1)
    time.sleep(0.5)

def read():
    cs.value(0)
    return_val = spi.read(1, 0x00)
    cs.value(1)
    return return_val[0]

while True:
    cmd = input("Operation: ")
    operation = 0b001
    if cmd == "-":
        operation = 0b010
    elif cmd == "*":
        operation = 0b100

    A = input("A: ")
    B = input("B: ")

    send(operation)
    send(A)
    send(B)
    time.sleep(0.5)
    result = read()
    print("Result: ", result)

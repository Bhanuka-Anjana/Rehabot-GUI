import serial

ser = serial.Serial("COM16", 9600)
if ser.isOpen():
    ser.close()


def sendSerial(msg):
    ser.open()
    ser.isOpen()
    ser.write((msg + "\r").encode())
    ser.close()


def readSerial():
    ser.open()
    ser.isOpen()
    while True:
        read_serial = ser.readline()
        read_val = read_serial.decode("utf-8").strip()
        angles = read_val.split(",")
        print(angles)


readSerial()
# sendSerial('Shoulder 70 18')
print("Completed")

import serial
import time

PORT = "COM5"
BAUD = 9600

def open_serial():
    ser = serial.Serial(PORT, BAUD, timeout=1)
    # Optional: mimic Serial Monitor DTR/RTS behaviour
    ser.setDTR(False)
    ser.setRTS(False)
    time.sleep(0.1)
    ser.setDTR(True)
    ser.setRTS(True)

    # Give Arduino time to reset
    time.sleep(2)
    return ser

def read_for(seconds, ser, prefix="RX"):
    t0 = time.time()
    while time.time() - t0 < seconds:
        line = ser.readline().decode("utf-8", errors="ignore").rstrip()
        if line:
            print(f"{prefix}: {line}")

def main():
    print("Opening port...")
    ser = open_serial()
    print("Port opened.")

    # 1) See if Arduino prints anything on boot (setup / debug prints)
    print("Listening for boot messages for 3 seconds...")
    read_for(3, ser, prefix="BOOT")

    # 2) Try sending different forms of 'Start'
    payloads = [b"Start", b"Start\n", b"Start\r\n"]

    for p in payloads:
        print(f"\nSending: {p!r}")
        ser.write(p)
        ser.flush()
        # Listen a bit after each send
        read_for(2, ser, prefix="AFTER_SEND")

    # 3) Keep listening a bit longer
    print("\nListening for any final messages for 5 seconds...")
    read_for(5, ser, prefix="FINAL")

    ser.close()
    print("Done.")

if __name__ == "__main__":
    main()

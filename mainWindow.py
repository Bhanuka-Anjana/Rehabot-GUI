import datetime
import time

import serial
import sounddevice as sd
from PySide6.QtCore import QObject, QTimer, QUrl, Signal, Slot
from PySide6.QtGui import QGuiApplication
from PySide6.QtQml import QQmlApplicationEngine
from scipy.io.wavfile import write

import voicecomand.record.recording as recording
import voicecomand.testing.model as model_functions
import voicecomand.testing.prediction as predictions
import voicecomand.training.arguments as arguments

PORT = "COM3"
BAUD = 9600

# ==================== Serial Communication =========================
# try:
#     ser = serial.Serial('COM5', 9600,timeout=1)
#     # Keep the port open
# except Exception as e:
#     print(f"Serial Error: {e}. Running without serial.")
#     ser = None
# # Comment above 3 lines (17,18,19) for start app without connect to serial, to test GUI
# # ser = None

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
# # ===================================================================

fs = 16000  # Sample rate
seconds = 2  # Duration of recording


class MainWindow(QObject):
    def __init__(self):
        # self.timer1=QTimer()
        self.ser = open_serial()
        QObject.__init__(self)
        pass

    printTime = Signal(str)
    mirrorArm = Signal(str, str)
    voiceFrontend = Signal(str, str)
    passiveArm = Signal(str, str)

    def setTime(self):
        now = datetime.datetime.now()
        formatDate = now.strftime("Now is %H:%M:%S %p of %Y/%m/%d")
        sec = now.strftime("%S")
        # print(int(sec))
        self.printTime.emit(sec)

    def sendSerial(self, msg):
        if self.ser is None:
            print(f"Serial not connected. Message ignored: {msg}")
            return
        try:
            if not self.ser.isOpen():
                self.ser.open()
            self.ser.write((msg + "\r\n").encode())
            print(f"Sent: {msg}")
        except Exception as e:
            print(f"Serial Write Error: {e}")

    @Slot()
    def btnStart(self):
        nowNew = datetime.datetime.now()
        formatDateNew = nowNew.strftime("Now is %H:%M:%S %p of %Y/%m/%d")
        print("Start - ", formatDateNew)

        myrecording = sd.rec(int(seconds * fs), samplerate=fs, channels=1)
        print("Recording Audio")
        sd.wait()
        write("mytemp/output2.wav", fs, myrecording)
        print("End Recording")

        file = "mytemp/output2.wav"
        a, b, c, d = predictions.predict_by_file(file)
        print(a, "==", b, "==", c, "==", d)
        # self.timerTest.start(50)
        self.voiceFrontend.emit(a, str(round(b * 100, 2)) + "%")

    @Slot(str, str, str, str)
    def btnStart2(self, s_max, s_min, e_max, e_min):
        # print("Shoulder Max==", s_max)
        # print("Shoulder Min==", s_min)
        # print("Elbow Max==", e_max)
        # print("Elbow Min==", e_min)
        self.isStop = 0
        
        # Stop any existing timer
        if hasattr(self, 'timer1') and self.timer1.isActive():
            self.timer1.stop()
        
        # Send commands based on which joint is active
        if int(s_max) > 0 or int(s_min) > 0:
            print("Call 01")
            self.sendSerial("Shoulder 90 0")
            time.sleep(0.5)
            self.sendSerial("Elbow 20 15")
        elif int(e_max) > 0 or int(e_min) > 0:
            print("Call 02")
            self.sendSerial("Shoulder 0 0")
            time.sleep(0.5)
            self.sendSerial("Elbow 90 15")
        
        time.sleep(1)  # Add a delay of 1 second before starting the robot

        self.sendSerial("Start")
        self.startReadPassive()

    @Slot()
    def btnStop(self):
        print("STOP ROBOT")
        # self.timer1.stop()
        self.sendSerial("Stop")
        time.sleep(0.5)
        self.sendSerial("Stop")

        # self.ser.open()
        # self.ser.isOpen()
        # self.timer1.start(1)

        # self.timer2=QTimer()
        self.isStop = 1
        # self.timer2.timeout.connect(lambda:self.checkPassiveStop())
        # self.timer2.start(1000)
        #### self.timer1.stop()

    @Slot(str, str)
    def btnWear(self, shoulder, elbow):
        print("Wear Mode ROBOT")
        print("PID_S " + shoulder, "PID_E " + elbow)
        self.sendSerial("PID_S " + shoulder)
        time.sleep(0.5)
        self.sendSerial("PID_E " + elbow)

    def startReadPassive(self):
        self.timer1 = QTimer()
        self.timer1.timeout.connect(lambda: self.readPassive())
        if self.ser and not self.ser.isOpen():
            self.ser.open()
        self.timer1.start(20)

    def readPassive(self):
        try:
            if self.ser and self.ser.isOpen():
                if self.ser.in_waiting > 0:
                    read_serial = self.ser.readline()
                    try:
                        read_val = read_serial.decode("utf-8").strip()
                    except UnicodeDecodeError:
                        return

                    if not read_val:
                        return

                    angles = read_val.split(",")
                    # print(angles)
                    
                    if len(angles) >= 2:
                        try:
                            # Validate inputs are numbers
                            float(angles[0])
                            float(angles[1])
                            # self.passiveArm.emit(angles[1], angles[0])
                        except ValueError:
                            pass
            elif self.isStop == 1:
                self.timer1.stop()

        except IndexError as error:
            if self.isStop == 1:
                self.timer1.stop()
                if  self.ser and self.ser.isOpen():
                    self.ser.close()
            print(error)
        except Exception as e:
            print(f"An exception occurred: {e}")

    def checkPassiveStop(self):
        self.isStop = self.isStop + 1
        print(self.isStop)
        if self.isStop >= 5:
            self.timer1.stop()
            self.timer2.stop()
            print("TIMER 1 and 2 Stopped")
            if self.ser.isOpen():
                self.ser.close()
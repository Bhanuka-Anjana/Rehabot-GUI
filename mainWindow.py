import datetime
import time

import serial
import sounddevice as sd
from PySide2.QtCore import QObject, QTimer, QUrl, Signal, Slot
from PySide2.QtGui import QGuiApplication
from PySide2.QtQml import QQmlApplicationEngine
from scipy.io.wavfile import write

import voicecomand.record.recording as recording
import voicecomand.testing.model as model_functions
import voicecomand.testing.prediction as predictions
import voicecomand.training.arguments as arguments

# ==================== Serial Communication =========================
ser = serial.Serial('COM15', 9600,timeout=1)
if ser.isOpen():
    ser.close()
# Comment above 3 lines (17,18,19) for start app without connect to serial, to test GUI
# ser = None
# ===================================================================

fs = 16000  # Sample rate
seconds = 2  # Duration of recording


class MainWindow(QObject):
    def __init__(self):
        # self.timer1=QTimer()
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
        if ser.isOpen():
            ser.close()
        ser.open()
        ser.isOpen()
        ser.write((msg + "\r").encode())
        ser.close()

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
        print("Shoulder " + s_max + " " + s_min)
        print("Elbow " + e_max + " " + e_min)
        self.isStop = 0
        self.sendSerial("Shoulder " + s_max + " " + s_min)
        self.sendSerial("Elbow " + e_max + " " + e_min)
        self.sendSerial("Start")
        self.startReadPassive()

    @Slot()
    def btnStop(self):
        print("STOP ROBOT")
        # self.timer1.stop()
        self.sendSerial("Stop")

        ser.open()
        ser.isOpen()
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
        self.sendSerial("PID_E " + elbow)

    def startReadPassive(self):
        self.timer1 = QTimer()
        self.timer1.timeout.connect(lambda: self.readPassive())
        ser.open()
        ser.isOpen()
        self.timer1.start(1)

    def readPassive(self):
        # if ser.in_waiting:
        #     ser.close()
        #     self.timer1.stop()
        # pass
        # read_serial = ser.readline()
        # read_val=read_serial.decode('utf-8').strip()
        # angles=read_val.split(",")
        # print(angles)
        # self.passiveArm.emit(angles[1],angles[0])
        try:
            read_serial = ser.readline()
            read_val = read_serial.decode("utf-8").strip()
            angles = read_val.split(",")
            print(angles)
            self.passiveArm.emit(angles[1], angles[0])
        except IndexError as error:
            if self.isStop == 1:
                self.timer1.stop()
                ser.close()
            print(error)
        except:
            print("An exception occurred")

    def checkPassiveStop(self):
        self.isStop = self.isStop + 1
        print(self.isStop)
        if self.isStop >= 5:
            self.timer1.stop()
            self.timer2.stop()
            print("TIMER 1 and 2 Stopped")
            if ser.isOpen():
                ser.close()

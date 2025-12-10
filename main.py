import os
import sys

from PySide6.QtGui import QGuiApplication, QIcon
from PySide6.QtQml import QQmlApplicationEngine

import voicecomand.record.recording as recording
import voicecomand.testing.model as model_functions
import voicecomand.testing.prediction as predictions
import voicecomand.training.arguments as arguments
from mainWindow import MainWindow

args = arguments.set_default_args()

# VOICE COMMAND
model_functions.load_model("model/new.ckpt")
print("Model Loaded")


if __name__ == "__main__":
    app = QGuiApplication(sys.argv)
    engine = QQmlApplicationEngine()

    # Get Context
    main = MainWindow()
    engine.rootContext().setContextProperty("backend", main)

    # Set App Extra Info
    app.setOrganizationName("Chamara Herath")
    app.setOrganizationDomain("RehaBot v1.0")

    # Set Icon
    app.setWindowIcon(QIcon("images/icon.ico"))

    # Load Initial Window
    # engine.load(os.path.join(os.path.dirname(__file__), "qml/welcomeScreen.qml"))
    engine.load(os.path.join(os.path.dirname(__file__), "qml/main.qml"))

    if not engine.rootObjects():
        sys.exit(-1)
    sys.exit(app.exec())
